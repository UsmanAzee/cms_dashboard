// https://plus.fluttercommunity.dev/docs/connectivity_plus/usage

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final networkConnectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  final Connectivity connectivity = Connectivity();
  return connectivity.onConnectivityChanged;
});

final connectivityProvider = StateNotifierProvider<ConnectionUtils, bool>((ref) => ConnectionUtils(ref));

class ConnectionUtils extends StateNotifier<bool> {
  final Ref ref;

  ConnectionUtils(this.ref) : super(true) {
    final connectionStateProvider = ref.watch(networkConnectivityProvider);
    if (connectionStateProvider.hasValue) {
      state = connectionStateProvider.value == ConnectivityResult.ethernet ||
          connectionStateProvider.value == ConnectivityResult.mobile ||
          connectionStateProvider.value == ConnectivityResult.wifi ||
          connectionStateProvider.value == ConnectivityResult.vpn;
    }
  }
}
