import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/audio_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LettersView extends StatefulWidget {
  const LettersView({super.key});

  @override
  State<LettersView> createState() => _LettersViewState();
}

class _LettersViewState extends State<LettersView>
    with SingleTickerProviderStateMixin {
  String? _userName;

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
      _userName = doc.data()?['name'] ?? 'Jugador';
    });
  }

  final Set<String> selectedVowels = {};
  String? activeLetter;
  bool isButtonDisabled = false;

  void _playSound(String soundPath, String letter) async {
    if (isButtonDisabled) return;
    setState(() => isButtonDisabled = true);

    await AudioService.playSound(soundPath);

    setState(() {
      activeLetter = letter;
      selectedVowels.add(letter);
    });

    await Future.delayed(const Duration(seconds: 2));

    if (selectedVowels.length == vowels.length) {
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CongratulationsScreen(userName: _userName ?? 'Jugador'),
          ),
        );
      });
    } else {
      setState(() => isButtonDisabled = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeVowel = vowels.firstWhere(
      (v) => v["letter"] == activeLetter,
      orElse: () => {},
    );

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
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Letra grande animada
          if (activeVowel.isNotEmpty)
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellow.withOpacity(0.8 * value),
                          blurRadius: 30 * value,
                          spreadRadius: 5 * value,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        activeVowel["image"]!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),

          // Letras pequeñas
          Expanded(
            child: Center(
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
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: isSelected ? 0.5 : 1.0,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            vowel["image"]!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
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
