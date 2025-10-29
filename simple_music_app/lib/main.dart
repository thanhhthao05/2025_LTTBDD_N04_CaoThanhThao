import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const SimpleMusicApp());
}

class SimpleMusicApp extends StatelessWidget {
  const SimpleMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
