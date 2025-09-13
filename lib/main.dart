import 'package:flutter/material.dart';
import 'core/constants/app_routes.dart';
import 'features/splash/splash_view.dart';
import 'features/menu/menu_view.dart';
import 'features/games/animals/animals_view.dart';

void main() {
  runApp(const DoneTonicApp());
}

class DoneTonicApp extends StatelessWidget {
  const DoneTonicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoneTonic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      // Definición de todas las rutas de la app
      routes: {
        AppRoutes.splash: (context) => const SplashView(),
        AppRoutes.menu: (context) => const MenuView(),
        AppRoutes.animals: (context) => const AnimalsView(),
      },
      // Pantalla inicial
      initialRoute: AppRoutes.splash,
    );
  }
}
