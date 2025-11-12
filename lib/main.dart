import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'core/constants/app_routes.dart';
import 'features/auth/presentation/login_view.dart';
import 'features/auth/presentation/signup_view.dart';
import 'features/menu/menu_view.dart';
import 'features/games/animals/animals_view.dart';
import 'features/games/colors/colors_view.dart';
import 'features/games/letters/letters_view.dart';
import 'features/games/numbers/numbers_view.dart';

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
      theme: ThemeData(primarySwatch: Colors.yellow, fontFamily: 'ComicNeue'),
      home: const WelcomeScreen(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
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
    final double buttonWidth = MediaQuery.of(context).size.width * 0.7;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF59D), // Amarillo claro
              Color(0xFFFFEB3B), // Amarillo vibrante
              Color(0xFFFFD54F), // Dorado cálido
            ],
            stops: [0.1, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Image.asset('assets/images/edukids_logo.png', width: 150),
                const SizedBox(height: 20),

                // Título principal
                Image.asset('assets/images/title.png', height: 140),

                const SizedBox(height: 50),

                // Botón Iniciar sesión
                SizedBox(
                  width: buttonWidth,
                  child: _GradientButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    text: 'Iniciar sesión',
                    colors: const [Color(0xFFFF8C42), Color(0xFFFF8C42)],
                    icon: Icons.person_2_rounded,
                  ),
                ),
                const SizedBox(height: 20),

                // Botón Registrarse
                SizedBox(
                  width: buttonWidth,
                  child: _GradientButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    text: 'Registrarse',
                    colors: const [Color(0xFF4CAF50), Color(0xFF4CAF50)],
                    icon: Icons.person_add,
                  ),
                ),

                const SizedBox(height: 50),

                const Text(
                  '¡La aventura de aprender comienza ahora!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ComicNeue',
                    color: Color.fromARGB(255, 141, 10, 255),
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.black26,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final List<Color> colors;
  final IconData icon;

  const _GradientButton({
    required this.onPressed,
    required this.text,
    required this.colors,
    this.icon = Icons.arrow_forward,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'ComicNeue',
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 26, color: Colors.white),
            const SizedBox(width: 12),
            Text(text),
          ],
        ),
      ),
    );
  }
}
