import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../modules/transport.dart';
import '../../modules/commands.dart';

class RemotePanel extends ConsumerWidget {
  const RemotePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socket = ref.read(socketServiceProvider);
    final textController = TextEditingController();

    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onPanUpdate: (details) => socket.sendMouse(details.delta.dx, details.delta.dy),
            onTap: () => socket.sendClick(),
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Center(child: Text('TRACKPAD', style: TextStyle(color: Colors.grey, letterSpacing: 4))),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: 'Type message...',
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  socket.sendCommand(CommandRequest(category: 'system', action: 'text', payload: {'text': textController.text}));
                  textController.clear();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
