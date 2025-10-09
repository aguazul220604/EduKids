import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/audio_service.dart';

class LettersView extends StatefulWidget {
  const LettersView({super.key});

  @override
  State<LettersView> createState() => _LettersViewState();
}

class _LettersViewState extends State<LettersView> {
  final List<Map<String, String>> vowels = [
    {
      "letter": "A",
      "image": "assets/images/letters/a.png",
      "sound": "sounds/letters/a.mp3",
    },
    {
      "letter": "E",
      "image": "assets/images/letters/e.png",
      "sound": "sounds/letters/e.mp3",
    },
    {
      "letter": "I",
      "image": "assets/images/letters/i.png",
      "sound": "sounds/letters/i.mp3",
    },
    {
      "letter": "O",
      "image": "assets/images/letters/o.png",
      "sound": "sounds/letters/o.mp3",
    },
    {
      "letter": "U",
      "image": "assets/images/letters/u.png",
      "sound": "sounds/letters/u.mp3",
    },
  ];

  final Set<String> selectedVowels = {};

  void _playSound(String soundPath, String letter) async {
    await AudioService.playSound(soundPath);

    setState(() {
      selectedVowels.add(letter);
    });

    if (selectedVowels.length == vowels.length) {
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CongratulationsScreen(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 63, 197, 214),
      appBar: AppBar(
        title: Text(
          "Letritas",
          style: GoogleFonts.fredoka(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(121, 23, 78, 85),
        centerTitle: true,
      ),
      body: Center(
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: vowels.map((vowel) {
            final isSelected = selectedVowels.contains(vowel["letter"]);
            return GestureDetector(
              onTap: () {
                if (!isSelected) {
                  _playSound(vowel["sound"]!, vowel["letter"]!);
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: const Offset(2, 2),
                        ),
                      ],
                      border: isSelected
                          ? Border.all(color: Colors.orange, width: 4)
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Opacity(
                        opacity: isSelected ? 0.5 : 1.0,
                        child: Image.asset(vowel["image"]!, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          }).toList(),
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
