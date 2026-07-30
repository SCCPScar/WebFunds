import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityService {
  const ConnectivityService(this._connectivity);

  final Connectivity _connectivity;

  Stream<bool> watchIsOnline() {
    return _connectivity.onConnectivityChanged.map(
      (results) => !results.contains(ConnectivityResult.none),
    );
  }

  Future<bool> isOnlineNow() async {
    final results = await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }
}

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return const ConnectivityService(Connectivity());
});

final connectivityStatusProvider = StreamProvider<bool>((ref) {
  return ref.watch(connectivityServiceProvider).watchIsOnline();
});
