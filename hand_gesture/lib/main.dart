import 'package:flutter/material.dart';
import 'package:hand_gesture/screens/landing.dart';
import 'package:hand_gesture/utils/scheme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
