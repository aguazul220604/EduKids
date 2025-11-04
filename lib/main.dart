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
                const Text(
                  '¡Bienvenido a EduKids!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ComicNeue',
                    color: Color(0xFF6A1B9A),
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

                // Botón Iniciar sesión
                SizedBox(
                  width: buttonWidth,
                  child: _GradientButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    text: 'Iniciar sesión',
                    colors: const [
                      Color(0xFFFF8C42), // Naranja brillante
                      Color(0xFFFFB347),
                      Color(0xFFFF8C42),
                    ],
                    icon: Icons.login,
                  ),
                ),
                const SizedBox(height: 20),

                // Botón Registrarse
                SizedBox(
                  width: buttonWidth,
                  child: _GradientButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    text: 'Registrarse',
                    colors: const [
                      Color(0xFF4CAF50), // Verde alegre
                      Color(0xFF81C784),
                      Color(0xFF4CAF50),
                    ],
                    icon: Icons.person_add,
                  ),
                ),

                const SizedBox(height: 40),

                // Frase motivadora
                const _AnimatedText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 🌈 Botón con gradiente (igual tamaño)
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

// 🌟 Texto animado final
class _AnimatedText extends StatefulWidget {
  const _AnimatedText();

  @override
  State<_AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<_AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              const Color(0xFFFFA726),
              const Color(0xFFFF6B6B),
              const Color(0xFF4CAF50),
            ],
            transform: GradientRotation(
              _controller.value * 6.28319,
            ), // 2π animación
          ).createShader(bounds),
          child: const Text(
            '¡La aventura de aprender comienza ahora!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'ComicNeue',
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: Colors.black38,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
