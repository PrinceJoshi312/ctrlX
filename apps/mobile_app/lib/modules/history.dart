import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActionLog {
  final String id;
  final String label;
  final DateTime timestamp;
  final bool success;

  ActionLog({required this.id, required this.label, required this.timestamp, required this.success});
}

class ActionHistoryNotifier extends StateNotifier<List<ActionLog>> {
  ActionHistoryNotifier() : super([]);

  void addLog(String label, bool success) {
    state = [
      ActionLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        label: label,
        timestamp: DateTime.now(),
        success: success,
      ),
      ...state,
    ].take(10).toList(); // Keep last 10 actions
  }
}

final actionHistoryProvider = StateNotifierProvider<ActionHistoryNotifier, List<ActionLog>>((ref) {
  return ActionHistoryNotifier();
});

class RecordingState {
  final bool isRecording;
  final List<Map<String, dynamic>> commands;
  RecordingState({this.isRecording = false, this.commands = const []});
}

class RecordingNotifier extends StateNotifier<RecordingState> {
  RecordingNotifier() : super(RecordingState());

  void start() => state = RecordingState(isRecording: true, commands: []);
  void stop() => state = RecordingState(isRecording: false, commands: state.commands);
  void addCommand(Map<String, dynamic> cmd) {
    if (state.isRecording) {
      state = RecordingState(isRecording: true, commands: [...state.commands, cmd]);
    }
  }
}

final recordingProvider = StateNotifierProvider<RecordingNotifier, RecordingState>((ref) => RecordingNotifier());
