import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'features/games/animals/animals_view.dart';
import 'features/games/colors/colors_view.dart';
import 'features/games/letters/letters_view.dart';
import 'features/games/numbers/numbers_view.dart';

import 'core/constants/app_routes.dart';
import 'features/auth/presentation/login_view.dart';
import 'features/auth/presentation/signup_view.dart';
import 'features/menu/menu_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      home: const WelcomeScreen(),
      routes: {
        '/login': (context) => const LoginView(),
        '/signup': (context) => const SignupView(),
        AppRoutes.menu: (context) => const MenuView(),
        AppRoutes.animals: (context) => const AnimalsView(),
        AppRoutes.colors: (context) => const ColorsView(),
        AppRoutes.letters: (context) => const LettersView(),
        AppRoutes.numbers: (context) => const NumbersView(),
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/edukids_logo.png', width: 150),
              const SizedBox(height: 24),
              Image.asset('assets/images/title.png', width: 250),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text('Iniciar sesión'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: const Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
