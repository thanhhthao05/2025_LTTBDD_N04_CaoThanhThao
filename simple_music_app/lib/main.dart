import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
// 📁 Màn hình chính

void main() {
  runApp(const SimpleMusicApp());
}

class SimpleMusicApp extends StatelessWidget {
  const SimpleMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Music App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),

      // ✅ Màn hình đầu tiên hiển thị
      home: const LoginScreen(),

      // ✅ Khai báo routes để điều hướng dễ dàng
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) =>
            const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
