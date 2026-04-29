import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'modules/transport.dart';
import 'modules/discovery.dart';
import 'ui/widgets/status_indicator.dart';
import 'ui/panels/dashboard_panel.dart';
import 'ui/panels/remote_panel.dart';
import 'ui/panels/system_panel.dart';
import 'ui/panels/browser_panel.dart';
import 'ui/panels/media_panel.dart';

void main() {
  runApp(const ProviderScope(child: CtrlXApp()));
}

final navigationProvider = StateProvider<int>((ref) => 0);

class CtrlXApp extends ConsumerWidget {
  const CtrlXApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPaired = ref.watch(isPairedProvider);
    final status = ref.watch(connectionStatusProvider);

    return MaterialApp(
      title: 'CtrlX',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: status == ConnectionStatus.connected && isPaired 
        ? const MainShell() 
        : const SetupScreen(),
    );
  }
}

class SetupScreen extends ConsumerWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(connectionStatusProvider);
    final discoveredUrl = ref.watch(discoveredAgentProvider);
    final isPaired = ref.watch(isPairedProvider);
    final pinController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('CtrlX Setup')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            StatusIndicator(status: status),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => ref.read(discoveryServiceProvider).startDiscovery(),
              child: const Text('Search for Agent'),
            ),
            if (discoveredUrl != null) ...[
              Text('Found: $discoveredUrl'),
              ElevatedButton(onPressed: () => ref.read(socketServiceProvider).connect(discoveredUrl), child: const Text('Connect')),
            ],
            if (status == ConnectionStatus.connected && !isPaired) ...[
              TextField(controller: pinController, decoration: const InputDecoration(labelText: 'PIN')),
              ElevatedButton(onPressed: () => ref.read(socketServiceProvider).pair(pinController.text), child: const Text('Pair')),
            ],
          ],
        ),
      ),
    );
  }
}

class MainShell extends ConsumerWidget {
  import 'ui/panels/browser_panel.dart';
  import 'ui/panels/media_panel.dart';
  import 'ui/panels/workflows_panel.dart';

  void main() {
  // ... (inside MainShell build)
      final index = ref.watch(navigationProvider);
      final screens = [
        const DashboardPanel(), 
        const RemotePanel(), 
        const SystemPanel(), 
        const BrowserPanel(), 
        const WorkflowsPanel(),
        const MediaPanel()
      ];

      return Scaffold(
        body: SafeArea(child: screens[index]),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          type: BottomNavigationBarType.fixed,
          onTap: (val) => ref.read(navigationProvider.notifier).state = val,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Status'),
            BottomNavigationBarItem(icon: Icon(Icons.mouse), label: 'Remote'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'System'),
            BottomNavigationBarItem(icon: Icon(Icons.language), label: 'Browser'),
            BottomNavigationBarItem(icon: Icon(Icons.bolt), label: 'Workflows'),
            BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Media'),
          ],
        ),
      );

}
