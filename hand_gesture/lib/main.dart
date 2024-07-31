import 'package:flutter/material.dart';
import 'package:hand_gesture/screens/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    themeMode: ThemeMode.system,
    routes: {
      '/': (context) => const Home(),
    },
  ));
}
