import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/animation.dart';
import '../../../services/audio_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NumbersView extends StatefulWidget {
  const NumbersView({super.key});

  @override
  State<NumbersView> createState() => _NumbersViewState();
}

class _NumbersViewState extends State<NumbersView>
    with SingleTickerProviderStateMixin {
  String? _userName;

  int currentIndex = 0;
  bool isButtonDisabled = false;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  final List<Map<String, String>> numbers = [
    {
      "number": "1",
      "word": "Uno",
      "image": "assets/images/numbers/num_1.png",
      "sound": "sounds/numbers/1.mp3",
    },
    {
      "number": "2",
      "word": "Dos",
      "image": "assets/images/numbers/num_2.png",
      "sound": "sounds/numbers/2.mp3",
    },
    {
      "number": "3",
      "word": "Tres",
      "image": "assets/images/numbers/num_3.png",
      "sound": "sounds/numbers/3.mp3",
    },
    {
      "number": "4",
      "word": "Cuatro",
      "image": "assets/images/numbers/num_4.png",
      "sound": "sounds/numbers/4.mp3",
    },
    {
      "number": "5",
      "word": "Cinco",
      "image": "assets/images/numbers/num_5.png",
      "sound": "sounds/numbers/5.mp3",
    },
    {
      "number": "6",
      "word": "Seis",
      "image": "assets/images/numbers/num_6.png",
      "sound": "sounds/numbers/6.mp3",
    },
    {
      "number": "7",
      "word": "Siete",
      "image": "assets/images/numbers/num_7.png",
      "sound": "sounds/numbers/7.mp3",
    },
    {
      "number": "8",
      "word": "Ocho",
      "image": "assets/images/numbers/num_8.jpg",
      "sound": "sounds/numbers/8.mp3",
    },
    {
      "number": "9",
      "word": "Nueve",
      "image": "assets/images/numbers/num_9.jpg",
      "sound": "sounds/numbers/9.mp3",
    },
    {
      "number": "10",
      "word": "Diez",
      "image": "assets/images/numbers/num_10.jpg",
      "sound": "sounds/numbers/10.mp3",
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
  }

  Future<void> _loadUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    setState(() {
      _userName = doc.data()?['name'] ?? 'Jugador';
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _nextWithSoundAndAnimation() async {
    if (isButtonDisabled) return;
    setState(() => isButtonDisabled = true);

    final currentNumber = numbers[currentIndex];

    // Animación de rebote visual
    _controller.forward(from: 0.0);

    // Reproduce el sonido del número
    await AudioService.playSound(currentNumber["sound"]!);

    // Espera breve antes de avanzar
    await Future.delayed(const Duration(seconds: 4));

    if (mounted) {
      setState(() {
        if (currentIndex < numbers.length - 1) {
          currentIndex++;
          isButtonDisabled = false;
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CongratulationsScreen(userName: _userName ?? 'Jugador'),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentNumber = numbers[currentIndex];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 164, 111),
      appBar: AppBar(
        title: Text(
          "Numeritos",
          style: GoogleFonts.fredoka(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 231, 97, 20),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade200, Colors.orange.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                // Aquí la clave: usamos constraints flexibles
                constraints: const BoxConstraints(
                  maxWidth: 320, // puedes ajustar según tu diseño
                  maxHeight: 320,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    currentNumber["image"]!,
                    fit: BoxFit.contain, // muestra la imagen completa
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: isButtonDisabled ? null : _nextWithSoundAndAnimation,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 231, 97, 20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 6,
              ),
              child: Text(
                currentNumber["word"]!,
                style: GoogleFonts.fredoka(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CongratulationsScreen extends StatelessWidget {
  final String userName;

  const CongratulationsScreen({super.key, required this.userName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 199, 224, 122),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/congrats.png", width: 200),
            const SizedBox(height: 30),
            Text(
              "¡Felicidades!",
              style: GoogleFonts.fredoka(fontSize: 36, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              userName,
              style: GoogleFonts.fredoka(
                fontSize: 26,
                color: Colors.orange.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "¡Completaste el juego!",
              style: GoogleFonts.fredoka(fontSize: 20, color: Colors.black87),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.all(16),
                shape: const CircleBorder(),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/menu");
              },
              child: const Icon(Icons.home, size: 32, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
