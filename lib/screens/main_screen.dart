// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 

import 'package:rural_roots_demo1/screens/profile_screen.dart';
import 'package:rural_roots_demo1/screens/map/map_screen.dart';
import 'package:rural_roots_demo1/screens/chat/chat_screen.dart';
import 'package:rural_roots_demo1/screens/settings/setting_screen.dart';
import 'package:rural_roots_demo1/services/user_service.dart';
import 'package:rural_roots_demo1/themes/app_colors.dart';
import 'package:rural_roots_demo1/themes/app_text_styles.dart';

/// Pantalla principal de la aplicación con navegación inferior
/// Esta pantalla contiene el BottomNavigationBar y maneja el cambio entre pestañas
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    
    // Inicializar las pantallas
    _screens = [
      ProfileScreen(onNavigateToMap: _navigateToMap),
      const MapScreen(),
      const ChatScreen(),
      const SettingsScreen(),
    ];
    
 
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userService = Provider.of<UserService>(context, listen: false);
      userService.addListener(_onUserChanged);
    });
  }

  @override
  void dispose() {
   
    final userService = Provider.of<UserService>(context, listen: false);
    userService.removeListener(_onUserChanged);
    super.dispose();
  }

  /// Callback que se ejecuta cuando cambia el estado del usuario
  void _onUserChanged() {
    // Actualizar UI cuando cambie el rol u otros datos del usuario
    if (mounted) {
      setState(() {});
    }
  }

  /// Navega a la pestaña del mapa
  void _navigateToMap() {
    setState(() {
      _currentIndex = 1; // Índice de MapScreen
    });
  }

  @override
  Widget build(BuildContext context) {
   
    final userService = Provider.of<UserService>(context);
    
    return Scaffold(
      // IndexedStack mantiene el estado de todas las pantallas
      // Solo muestra la pantalla activa según _currentIndex
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.textSecondary,
        elevation: 8,
        selectedLabelStyle: AppTextStyles.bodySecondary.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.bodySecondary.copyWith(
          fontSize: 12,
        ),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: userService.isFarmer ? 'Mi Finca' : 'Inicio',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Mapa',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}