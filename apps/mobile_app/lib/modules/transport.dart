import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'commands.dart';
import 'history.dart';

enum ConnectionStatus { connected, disconnected, connecting, error }

final connectionStatusProvider = StateProvider<ConnectionStatus>((ref) => ConnectionStatus.disconnected);
final lastMessageProvider = StateProvider<String>((ref) => "No messages yet");
final isPairedProvider = StateProvider<bool>((ref) => false);
final screenshotProvider = StateProvider<String?>((ref) => null);

class SocketService {
  final Ref ref;
  late io.Socket socket;

  SocketService(this.ref);

import 'package:shared_preferences/shared_preferences.dart';

// ... (inside SocketService)
  Future<void> connect(String url) async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('pair_token');
    
    ref.read(connectionStatusProvider.notifier).state = ConnectionStatus.connecting;
    socket = io.io(url, io.OptionBuilder().setTransports(['websocket']).build());

    socket.onConnect((_) {
      ref.read(connectionStatusProvider.notifier).state = ConnectionStatus.connected;
      if (savedToken != null) {
        socket.emit('pair', {'token': savedToken});
      }
    });
    
    socket.on('pair_result', (data) async {
      if (data['success'] == true) {
        ref.read(isPairedProvider.notifier).state = true;
        prefs.setString('pair_token', data['token']);
        prefs.setString('last_url', url);
      }
    });
// ...

    socket.on('command_response', (data) {
      final response = CommandResponse.fromJson(data);
      final isSuccess = response.status == 'success';
      ref.read(lastMessageProvider.notifier).state = isSuccess ? "Success" : "Error: ${response.error}";
      if (isSuccess && response.data?['image'] != null) {
        ref.read(screenshotProvider.notifier).state = response.data['image'];
      }
      ref.read(actionHistoryProvider.notifier).addLog("Action", isSuccess);
    });
  }

  void pair(String pin) => socket.emit('pair', {'code': pin});
import 'security.dart';

// ... (inside SocketService)
  Future<void> sendCommand(CommandRequest req) async {
    if (ref.read(securityEnabledProvider)) {
      final authenticated = await ref.read(securityServiceProvider).authenticate();
      if (!authenticated) return;
    }
    
    final cmdJson = req.toJson();
    ref.read(recordingProvider.notifier).addCommand(cmdJson);
    socket.emit('command', cmdJson);
  }
  void sendMouse(double dx, double dy) => socket.emit('command', {'category': 'input', 'action': 'mouse_move', 'payload': {'dx': dx, 'dy': dy}});
  void sendClick() => socket.emit('command', {'category': 'input', 'action': 'mouse_click', 'payload': {'button': 'left'}});
}

final socketServiceProvider = Provider((ref) => SocketService(ref));
