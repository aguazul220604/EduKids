import 'package:flutter/material.dart';
import '../../../services/audio_service.dart';
import '../../../core/constants/app_routes.dart';

class LettersView extends StatefulWidget {
  const LettersView({super.key});

  @override
  State<LettersView> createState() => _LettersViewState();
}

class _LettersViewState extends State<LettersView> {
  final List<Map<String, String>> vowels = [
    {
      "letter": "A",
      "image": "assets/images/letters/a.jpg",
      "sound": "sounds/letters/a.mp3",
    },
    {
      "letter": "E",
      "image": "assets/images/letters/e.jpg",
      "sound": "sounds/letters/e.mp3",
    },
    {
      "letter": "I",
      "image": "assets/images/letters/i.jpg",
      "sound": "sounds/letters/i.mp3",
    },
    {
      "letter": "O",
      "image": "assets/images/letters/o.jpg",
      "sound": "sounds/letters/o.mp3",
    },
    {
      "letter": "U",
      "image": "assets/images/letters/u.jpg",
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("¡Completaste todas las vocales!")),
      );
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, AppRoutes.menu);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Juego: Vocales")),
      body: Center(
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: vowels.map((vowel) {
            final isSelected = selectedVowels.contains(vowel["letter"]);
            return GestureDetector(
              onTap: () {
                if (!isSelected) {
                  _playSound(vowel["sound"]!, vowel["letter"]!);
                }
              },
              child: Opacity(
                opacity: isSelected ? 0.5 : 1.0,
                child: Image.asset(vowel["image"]!, width: 100, height: 100),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
