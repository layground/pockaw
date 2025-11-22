// create connectivity service class also its riverpod provider to check/listen internet connection
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/utils/logger.dart';

enum ConnectionStatus {
  online,
  offline,
}

final connectivityServiceProvider = Provider<ConnectivityService>(
  (ref) => ConnectivityService(),
);

final connectionStatusProvider = StreamProvider<ConnectionStatus>(
  (ref) => ref.watch(connectivityServiceProvider).connectionStatusStream,
);

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<ConnectionStatus> _connectionStatusController =
      StreamController<ConnectionStatus>.broadcast();

  Stream<ConnectionStatus> get connectionStatusStream =>
      _connectionStatusController.stream;

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    final hasConnection =
        result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet);

    if (!hasConnection) {
      _connectionStatusController.add(ConnectionStatus.offline);
      Log.i('Connection Status: Offline', label: 'ConnectivityService');
    } else {
      _connectionStatusController.add(ConnectionStatus.online);
      Log.i('Connection Status: Online', label: 'ConnectivityService');
    }
  }

  Future<bool> hasInternetConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet);
  }

  void dispose() {
    _connectionStatusController.close();
  }
}
