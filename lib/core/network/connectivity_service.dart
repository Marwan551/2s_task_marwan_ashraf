import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return !(result as List).contains(ConnectivityResult.none);
  }

  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(
      (result) {
        return !(result as List).contains(ConnectivityResult.none);
      },
    );
  }
}

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

final isConnectedProvider = StreamProvider<bool>((ref) {
  return ref.watch(connectivityServiceProvider).onConnectivityChanged;
});
