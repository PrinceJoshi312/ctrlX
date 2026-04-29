import 'package:nsd/nsd.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final discoveredAgentProvider = StateProvider<String?>((ref) => null);

class DiscoveryService {
  final WidgetRef ref;
  DiscoveryService(this.ref);

  Future<void> startDiscovery() async {
    final discovery = await startDiscovery('_ctrlx._tcp');
    discovery.addListener(() {
      if (discovery.services.isNotEmpty) {
        final service = discovery.services.first;
        final host = service.host;
        final port = service.port;
        if (host != null && port != null) {
          ref.read(discoveredAgentProvider.notifier).state = 'http://$host:$port';
          stopDiscovery(discovery);
        }
      }
    });
  }
}

final discoveryServiceProvider = Provider((ref) => DiscoveryService(ref as WidgetRef));
