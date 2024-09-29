import 'package:flutter/material.dart';
import 'package:hand_gesture/screens/landing.dart';
import 'package:hand_gesture/utils/scheme.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request Bluetooth permissions
  await Permission.bluetooth.request();
  await Permission.bluetoothScan.request();
  await Permission.bluetoothConnect.request();
  await Permission.location.request();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    themeMode: ThemeMode.system,
    theme: Scheme.lightTheme,
    routes: {
      '/': (context) => const Landing(),
    },
  ));
}
