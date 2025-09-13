import 'package:flutter/material.dart';
import 'core/constants/app_routes.dart';
import 'features/splash/splash_view.dart';
import 'features/menu/menu_view.dart';
import 'features/games/animals/animals_view.dart';
import 'features/games/colors/colors_view.dart';
import 'features/games/letters/letters_view.dart';
import 'features/games/numbers/numbers_view.dart';

void main() {
  runApp(const EduKidsApp());
}

class EduKidsApp extends StatelessWidget {
  const EduKidsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduKids',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        AppRoutes.splash: (context) => const SplashView(),
        AppRoutes.menu: (context) => const MenuView(),
        AppRoutes.animals: (context) => const AnimalsView(),
        AppRoutes.colors: (context) => const ColorsView(),
        AppRoutes.letters: (context) => const LettersView(),
        AppRoutes.numbers: (context) => const NumbersView(),
      },
      initialRoute: AppRoutes.splash,
    );
  }
}
