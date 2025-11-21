import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
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
      home: const SplashScreen(),
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

/// 🟡 SPLASH SCREEN (powered.png durante 2 segundos)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => const WelcomeScreen(),
          transitionsBuilder: (_, animation, __, child) {
            final curve = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );
            return FadeTransition(opacity: curve, child: child);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF176),
      body: Center(child: Image.asset('assets/powered.png', width: 200)),
    );
  }
}

/// 🧡 PANTALLA PRINCIPAL
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = MediaQuery.of(context).size.width * 0.7;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF176),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/edukids_logo.png', width: 150),
              const SizedBox(height: 20),
              Image.asset('assets/images/title.png', height: 140),
              const SizedBox(height: 50),

              // 🔸 Botón Iniciar sesión
              SizedBox(
                width: buttonWidth,
                child: _OutlinedOrangeButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  text: 'Iniciar sesión',
                  icon: Icons.person_2_rounded,
                ),
              ),
              const SizedBox(height: 20),

              // 🔸 Botón Registrarse
              SizedBox(
                width: buttonWidth,
                child: _OutlinedOrangeButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  text: 'Registrarse',
                  icon: Icons.person_add,
                ),
              ),
              const SizedBox(height: 50),

              // 🔸 Texto inferior
              Text(
                '¡La aventura de aprender comienza ahora!',
                style: GoogleFonts.fredoka(
                  fontSize: 25,
                  color: Colors.orange.shade800,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 🟠 BOTÓN CON BORDE NARANJA
class _OutlinedOrangeButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;

  const _OutlinedOrangeButton({
    required this.onPressed,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.orange.shade800, size: 26),
      label: Text(
        text,
        style: TextStyle(
          color: Colors.orange.shade800,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'ComicNeue',
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide(color: Colors.orange.shade800, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
        shadowColor: Colors.orange.shade200,
        elevation: 3,
      ),
    );
  }
}
