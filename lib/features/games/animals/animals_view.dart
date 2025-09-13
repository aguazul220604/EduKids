import 'package:flutter/material.dart';
import '../../../services/audio_service.dart';

class AnimalsView extends StatefulWidget {
  const AnimalsView({super.key});

  @override
  State<AnimalsView> createState() => _AnimalsViewState();
}

class _AnimalsViewState extends State<AnimalsView> {
  final List<Map<String, String>> animals = [
    {
      "name": "Perro",
      "image": "assets/images/dog.png",
      "sound": "sounds/animals/dog.mp3",
    },
    {
      "name": "Gato",
      "image": "assets/images/cat.png",
      "sound": "sounds/animals/cat.mp3",
    },
    {
      "name": "Vaca",
      "image": "assets/images/cow.png",
      "sound": "sounds/animals/cow.mp3",
    },
    {
      "name": "Pájaro",
      "image": "assets/images/bird.png",
      "sound": "sounds/animals/bird.mp3",
    },
  ];

  int currentIndex = 0;
  Set<int> validatedIndexes = {};
  String? correctAnswer;

  void _playCurrentSound() async {
    final currentAnimal = animals[currentIndex];
    await AudioService.playSound(currentAnimal["sound"]!);
    setState(() {
      correctAnswer = currentAnimal["name"];
    });
  }

  void _onAnimalTap(int index) {
    if (animals[index]["name"] == correctAnswer) {
      validatedIndexes.add(index);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("¡Correcto! 🎉")));

      if (validatedIndexes.length == animals.length) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("¡Completaste todos los animales!")),
        );

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, "/menu");
          }
        });
      } else {
        int nextIndex = (currentIndex + 1) % animals.length;
        while (validatedIndexes.contains(nextIndex)) {
          nextIndex = (nextIndex + 1) % animals.length;
        }

        setState(() {
          currentIndex = nextIndex;
          correctAnswer = null;
        });
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Intenta de nuevo")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Juego: Animales")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _playCurrentSound,
            child: const Text("Reproducir sonido"),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 20,
            children: animals.asMap().entries.map((entry) {
              final index = entry.key;
              final animal = entry.value;

              return GestureDetector(
                onTap: () => _onAnimalTap(index),
                child: Opacity(
                  opacity: validatedIndexes.contains(index) ? 0.4 : 1.0,
                  child: Image.asset(animal["image"]!, width: 100, height: 100),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
