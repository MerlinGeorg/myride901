import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

///
/// This class checks if device has internet connectivity or not
///
class NetworkManager {
  StreamController<bool> _onInternetConnected = StreamController.broadcast();

  Stream<bool> get internetConnectionStream => _onInternetConnected.stream;

  Connectivity connectivity = Connectivity();

  bool? _isInternetConnected;

  initialiseNetworkManager() async {
    List<ConnectivityResult> result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  Future<bool> isConnected() async {
    List<ConnectivityResult> result = await connectivity.checkConnectivity();
    return await _checkStatus(result);
  }

  Future<bool> _checkStatus(List<ConnectivityResult> result) async {
    bool isInternet = false;
    if (result.contains(ConnectivityResult.mobile)) {
      isInternet = true;
    } else if (result.contains(ConnectivityResult.wifi)) {
      isInternet = true;
    } else if (result.contains(ConnectivityResult.none)) {
      isInternet = false;
    } else {
      isInternet = false;
    }

    if (isInternet) {
      _onInternetConnected.sink.add(await _updateConnectionStatus());
    } else {
      _isInternetConnected = isInternet;
      _onInternetConnected.sink.add(isInternet);
    }
    return isInternet;
  }

  Future<bool> _updateConnectionStatus() async {
    bool? isConnected;
    try {
      final List<InternetAddress> result =
          await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
      return false;
    }
    return isConnected!;
  }

  disposeStream() {
    _onInternetConnected.close();
  }
}
