import 'package:flutter/material.dart';
import 'package:rural_roots_demo1/screens/login_screen.dart';
import 'package:rural_roots_demo1/screens/register_screen.dart';
import 'package:rural_roots_demo1/screens/splash_screen.dart';
import 'package:rural_roots_demo1/themes/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rural Roots',
      theme: appTheme,
      // Ruta inicial 
      initialRoute: '/splash',
      

      // Rutas con nombre
      routes: {
        '/splash':(context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
