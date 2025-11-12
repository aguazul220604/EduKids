import 'package:edukids/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_routes.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    setState(() {
      _userName = doc.data()?['name'] ?? 'Usuario';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF176),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/edukids_logo.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 8),
              if (_userName != null)
                Text(
                  'Hola, $_userName',
                  style: GoogleFonts.fredoka(
                    fontSize: 22,
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                '¡A jugar!',
                style: GoogleFonts.fredoka(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                ),
              ),
              const SizedBox(height: 32),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _menuButton(
                    context,
                    'Animales',
                    AppRoutes.animals,
                    'assets/images/animales.png',
                  ),
                  _menuButton(
                    context,
                    'Colores',
                    AppRoutes.colors,
                    'assets/images/colores.png',
                  ),
                  _menuButton(
                    context,
                    'Letras',
                    AppRoutes.letters,
                    'assets/images/letras.png',
                  ),
                  _menuButton(
                    context,
                    'Números',
                    AppRoutes.numbers,
                    'assets/images/numeros.png',
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    // Cierra sesión en Firebase (siempre)
                    await FirebaseAuth.instance.signOut();

                    // Intenta cerrar sesión en Google (si aplica)
                    final GoogleSignIn googleSignIn = GoogleSignIn();
                    final isSignedIn = await googleSignIn.isSignedIn();
                    if (isSignedIn) {
                      try {
                        await googleSignIn.signOut();
                        await googleSignIn.disconnect();
                      } catch (_) {
                        // Ignoramos errores menores del plugin
                      }
                    }

                    // Redirige al usuario a la pantalla de bienvenida
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WelcomeScreen(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    }
                  } catch (e) {
                    // Solo log interno (sin mostrar SnackBar)
                    print('⚠️ Error cerrando sesión (ignorado): $e');
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuButton(
    BuildContext context,
    String title,
    String route,
    String imagePath,
  ) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 6,
        shadowColor: Colors.black26,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.orange.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath, width: 80, height: 80),
              const SizedBox(height: 12),
              Text(
                title,
                style: GoogleFonts.fredoka(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
