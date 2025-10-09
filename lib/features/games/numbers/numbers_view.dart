import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/audio_service.dart';

class NumbersView extends StatefulWidget {
  const NumbersView({super.key});

  @override
  State<NumbersView> createState() => _NumbersViewState();
}

class _NumbersViewState extends State<NumbersView> {
  int currentIndex = 0;

  final List<Map<String, String>> numbers = List.generate(10, (index) {
    final num = index + 1;
    return {
      "number": "$num",
      "image": "assets/images/numbers/num_$num.jpg",
      "sound": "sounds/numbers/num_$num.mp3",
    };
  });

  Future<void> _playAndNext() async {
    final currentNumber = numbers[currentIndex];
    await AudioService.playSound(currentNumber["sound"]!);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          if (currentIndex < numbers.length - 1) {
            currentIndex++;
          } else {
            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const CongratulationsScreen(),
                ),
              );
            });
          }
        });
      }
    });
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
        child: GestureDetector(
          onTap: _playAndNext,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade200, Colors.orange.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: const Offset(4, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                currentNumber["image"]!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CongratulationsScreen extends StatelessWidget {
  const CongratulationsScreen({super.key});

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
              "Completaste el juego",
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
