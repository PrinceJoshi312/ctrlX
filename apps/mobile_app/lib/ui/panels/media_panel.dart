import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import '../../modules/transport.dart';
import '../../modules/commands.dart';

class MediaPanel extends ConsumerWidget {
  const MediaPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenshot = ref.watch(screenshotProvider);
    final socket = ref.read(socketServiceProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton.icon(
            onPressed: () => socket.sendCommand(CommandRequest(category: 'agent', action: 'screenshot')),
            icon: const Icon(Icons.camera_alt),
            label: const Text('Capture Screen'),
          ),
        ),
        if (screenshot != null) 
          Expanded(child: InteractiveViewer(child: Image.memory(base64Decode(screenshot)))),
      ],
    );
  }
}
