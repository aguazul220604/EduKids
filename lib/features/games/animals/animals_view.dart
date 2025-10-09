import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      "image": "assets/images/animals/dog.png",
      "sound": "sounds/animals/dog.mp3",
    },
    {
      "name": "Gato",
      "image": "assets/images/animals/cat.png",
      "sound": "sounds/animals/cat.mp3",
    },
    {
      "name": "Vaca",
      "image": "assets/images/animals/cow.png",
      "sound": "sounds/animals/cow.mp3",
    },
    {
      "name": "Pájaro",
      "image": "assets/images/animals/bird.png",
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

      if (validatedIndexes.length == animals.length) {
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CongratulationsScreen(),
            ),
          );
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
      backgroundColor: const Color(0xFFB4DF37),
      appBar: AppBar(
        title: Text(
          "Animalitos",
          style: GoogleFonts.fredoka(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 57, 139, 61),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _playCurrentSound,
            child: Text(
              "🔊 Escuchemos",
              style: GoogleFonts.fredoka(fontSize: 20, color: Colors.white),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columnas
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: animals.length,
              itemBuilder: (context, index) {
                final animal = animals[index];
                return GestureDetector(
                  onTap: () => _onAnimalTap(index),
                  child: Opacity(
                    opacity: validatedIndexes.contains(index) ? 0.4 : 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(animal["image"]!, width: 90, height: 90),
                          const SizedBox(height: 10),
                          Text(
                            animal["name"]!,
                            style: GoogleFonts.fredoka(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
