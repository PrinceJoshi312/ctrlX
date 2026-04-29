import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../modules/transport.dart';

class StatusIndicator extends StatelessWidget {
  final ConnectionStatus status;
  const StatusIndicator({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case ConnectionStatus.connected:
        color = Colors.green;
        label = "CONNECTED";
        break;
      case ConnectionStatus.connecting:
        color = Colors.orange;
        label = "CONNECTING...";
        break;
      case ConnectionStatus.error:
        color = Colors.red;
        label = "CONNECTION ERROR";
        break;
      case ConnectionStatus.disconnected:
      default:
        color = Colors.grey;
        label = "DISCONNECTED";
    }

    return Column(
      children: [
        Icon(Icons.circle, color: color, size: 48),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
