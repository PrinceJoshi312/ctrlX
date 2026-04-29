import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../modules/history.dart';
import '../../modules/transport.dart';

import '../../modules/security.dart';

class DashboardPanel extends ConsumerWidget {
  const DashboardPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(actionHistoryProvider);
    final lastMsg = ref.watch(lastMessageProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dashboard', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text('Status: $lastMsg', style: const TextStyle(color: Colors.grey)),
          const Divider(height: 20),

          // Security Toggle
          SwitchListTile(
            title: const Text('Biometric Protection'),
            subtitle: const Text('Auth before sending commands'),
            value: ref.watch(securityEnabledProvider), 
            onChanged: (val) => ref.read(securityEnabledProvider.notifier).state = val,
            secondary: const Icon(Icons.fingerprint),
          ),

          const Divider(height: 40),
          const Text('Recent Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, i) => ListTile(
                leading: Icon(history[i].success ? Icons.check_circle : Icons.error, color: history[i].success ? Colors.green : Colors.red),
                title: Text(history[i].label),
                subtitle: Text(history[i].timestamp.toLocal().toString().split('.')[0]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
