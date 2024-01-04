import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

var primaryColor = const Color(0xFF00A95C);
var secondaryColor = Colors.blue[100];

Future<bool> checkConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    // Connected to a mobile network.
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    // Connected to a WiFi network.
    return true;
  }
  // Neither mobile data nor WiFi data is connected.
  return false;
}
