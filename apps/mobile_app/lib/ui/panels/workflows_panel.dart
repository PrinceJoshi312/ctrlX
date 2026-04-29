import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../modules/transport.dart';
import '../../modules/commands.dart';
import '../../modules/history.dart';

class WorkflowsPanel extends ConsumerWidget {
  const WorkflowsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socket = ref.read(socketServiceProvider);
    final recording = ref.watch(recordingProvider);
    final controller = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Macros & Workflows', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          
          // Recording Section
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: recording.isRecording ? Colors.red[50] : Colors.indigo[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  recording.isRecording 
                    ? 'RECORDING (${recording.commands.length} actions)' 
                    : 'Macro Builder',
                  style: TextStyle(fontWeight: FontWeight.bold, color: recording.isRecording ? Colors.red : Colors.indigo),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!recording.isRecording) 
                      ElevatedButton.icon(
                        onPressed: () => ref.read(recordingProvider.notifier).start(), 
                        icon: const Icon(Icons.fiber_manual_record), 
                        label: const Text('Start Recording')
                      ),
                    if (recording.isRecording)
                      ElevatedButton.icon(
                        onPressed: () => ref.read(recordingProvider.notifier).stop(), 
                        icon: const Icon(Icons.stop), 
                        label: const Text('Stop Recording'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                      ),
                  ],
                ),
                if (!recording.isRecording && recording.commands.isNotEmpty) ...[
                   const SizedBox(height: 10),
                   TextField(controller: controller, decoration: const InputDecoration(hintText: 'Enter Workflow Name', border: OutlineInputBorder())),
                   const SizedBox(height: 10),
                   ElevatedButton(
                     onPressed: () {
                       socket.sendCommand(CommandRequest(category: 'workflow', action: 'save', payload: {
                         'name': controller.text,
                         'description': 'Saved via mobile builder',
                         'commands': recording.commands,
                       }));
                       ref.read(recordingProvider.notifier).start(); // Reset
                       ref.read(recordingProvider.notifier).stop(); 
                     }, 
                     child: const Text('Save to Desktop')
                   ),
                ]
              ],
            ),
          ),
          
          const Divider(height: 60),
          const Text('Run Saved Workflow', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Workflow Name',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.bolt),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => socket.sendCommand(CommandRequest(category: 'workflow', action: 'run', payload: {'name': controller.text})),
            child: const Text('Execute Sequence'),
          ),
        ],
      ),
    );
  }
}
