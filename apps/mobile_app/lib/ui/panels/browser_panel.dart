import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../modules/transport.dart';
import '../../modules/commands.dart';

class BrowserPanel extends ConsumerWidget {
  const BrowserPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socket = ref.read(socketServiceProvider);
    final controller = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Browser Automation', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'URL or Search Query', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            children: [
              ActionChip(label: const Text('Open URL'), onPressed: () => socket.sendCommand(CommandRequest(category: 'browser', action: 'open_url', payload: {'url': controller.text}))),
              ActionChip(label: const Text('Google'), onPressed: () => socket.sendCommand(CommandRequest(category: 'browser', action: 'google_search', payload: {'query': controller.text}))),
            ],
          ),
        ],
      ),
    );
  }
}
