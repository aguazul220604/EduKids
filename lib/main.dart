import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'ComicNeue',
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          accentColor: const Color(0xFFFF6B6B),
          backgroundColor: const Color(0xFFFFF9C4),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontFamily: 'ComicNeue',
            fontWeight: FontWeight.bold,
            color: Color(0xFF6A1B9A),
          ),
          bodyLarge: TextStyle(
            fontFamily: 'ComicNeue',
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
      home: const SplashScreen(),
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

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.3,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _colorAnimation = ColorTween(
      begin: const Color(0xFFFF6B6B),
      end: const Color(0xFF4CAF50),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();

    Future.delayed(const Duration(seconds: 8), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _colorAnimation.value,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Transform.rotate(
                        angle: _scaleAnimation.value * 0.1,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: const Color(0xFFFFD700),
                        width: 3,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Image.asset(
                        'assets/images/edukids_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    'EduKids',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'ComicNeue',
                      shadows: [
                        Shadow(
                          blurRadius: 15,
                          color: Colors.black45,
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, color: Colors.yellow, size: 30),
                          Icon(
                            Icons.auto_awesome,
                            color: Colors.orange,
                            size: 30,
                          ),
                          Icon(Icons.celebration, color: Colors.pink, size: 30),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '¡Aprendiendo es divertido!',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'ComicNeue',
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black,
                              offset: Offset(2, 2),
                            ),
                          ],
                          letterSpacing: 1.1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF6B6B),
                      ),
                      strokeWidth: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF6B6B), // Rojo coral vibrante
              Color(0xFFFFD166), // Amarillo soleado
              Color(0xFF06D6A0), // Verde esmeralda
              Color(0xFF118AB2), // Azul brillante
              Color(0xFF6A4C93), // Morado divertido
            ],
            stops: [0.0, 0.3, 0.6, 0.8, 1.0],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo con animación de rebote y rotación
                _AnimatedLogo(),
                const SizedBox(height: 30),

                // Título con fondo divertido
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFFFFD700),
                      width: 3,
                    ),
                  ),
                  child: Image.asset('assets/images/title.png', width: 300),
                ),
                const SizedBox(height: 50),

                // Botón de iniciar sesión - Naranja vibrante
                _GradientButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  text: 'Iniciar sesión',
                  colors: const [
                    Color(0xFFFF8C42), // Naranja vibrante
                    Color(0xFFFFB347), // Naranja claro
                    Color(0xFFFF8C42),
                  ],
                  icon: Icons.login,
                ),
                const SizedBox(height: 20),

                // Botón de registrarse - Verde divertido
                _GradientButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  text: 'Registrarse',
                  colors: const [
                    Color(0xFF2ECC71), // Verde brillante
                    Color(0xFF27AE60), // Verde esmeralda
                    Color(0xFF2ECC71),
                  ],
                  icon: Icons.person_add,
                ),
                const SizedBox(height: 30),

                // Texto decorativo con colores cambiantes
                const _AnimatedText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedLogo extends StatefulWidget {
  @override
  State<_AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<_AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(
      begin: -20,
      end: 10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _rotateAnimation = Tween<double>(
      begin: -0.05,
      end: 0.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value),
          child: Transform.rotate(angle: _rotateAnimation.value, child: child),
        );
      },
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFF6B6B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Image.asset(
            'assets/images/edukids_logo.png',
            fit: BoxFit.contain,
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
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(0.6),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: colors.last.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          textStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'ComicNeue',
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                shadows: [
                  Shadow(
                    blurRadius: 8,
                    color: Colors.black45,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedText extends StatefulWidget {
  const _AnimatedText();

  @override
  State<_AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<_AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: const Color(0xFFFFD700), // Dorado
      end: const Color(0xFFFF6B6B), // Rojo coral
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: [
            const Color(0xFFFFD700),
            const Color(0xFFFF6B6B),
            const Color(0xFF4CAF50),
          ],
          stops: const [0.0, 0.5, 1.0],
          transform: GradientRotation(_controller.value * 6.28319), // 2*PI
        ).createShader(bounds);
      },
      child: Text(
        '¡La aventura de aprender comienza ahora!',
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          fontFamily: 'ComicNeue',
          fontStyle: FontStyle.italic,
          color: Colors.white,
          shadows: [
            Shadow(blurRadius: 10, color: Colors.black, offset: Offset(2, 2)),
            Shadow(blurRadius: 15, color: Colors.black45, offset: Offset(4, 4)),
          ],
          letterSpacing: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
