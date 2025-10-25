import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityService {
  Future<bool> get isConnected;
}

class ConnectivityServiceImpl implements ConnectivityService {
// region properties
  final Connectivity connectivity;
// endregion

// region constructor
  ConnectivityServiceImpl({required this.connectivity});
// endregion

// region methods
  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
// endregion
}