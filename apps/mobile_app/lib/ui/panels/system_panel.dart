import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../modules/transport.dart';
import '../../modules/commands.dart';
import '../widgets/control_button.dart';

class SystemPanel extends ConsumerWidget {
  const SystemPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socket = ref.read(socketServiceProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Volume & Media', style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(onPressed: () => socket.sendCommand(CommandRequest(category: 'system', action: 'volume', payload: {'action': 'down'})), icon: const Icon(Icons.volume_down)),
              IconButton(onPressed: () => socket.sendCommand(CommandRequest(category: 'system', action: 'volume', payload: {'action': 'mute'})), icon: const Icon(Icons.volume_off)),
              IconButton(onPressed: () => socket.sendCommand(CommandRequest(category: 'system', action: 'volume', payload: {'action': 'up'})), icon: const Icon(Icons.volume_up)),
            ],
          ),
          const Divider(),
          ControlBtn(
            icon: Icons.lock, 
            label: 'Lock PC', 
            color: Colors.redAccent,
            onTap: () => socket.sendCommand(CommandRequest(category: 'system', action: 'lock')),
          ),
        ],
      ),
    );
  }
}
