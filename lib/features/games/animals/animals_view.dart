import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/audio_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnimalsView extends StatefulWidget {
  const AnimalsView({super.key});

  @override
  State<AnimalsView> createState() => _AnimalsViewState();
}

class _AnimalsViewState extends State<AnimalsView> {
  String? _userName;
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
  bool isAudioPlayed = false;
  bool isButtonDisabled = false;

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

  void _playCurrentSound() async {
    if (isButtonDisabled) return;
    setState(() => isButtonDisabled = true);

    await AudioService.stopSound();

    final currentAnimal = animals[currentIndex];
    await AudioService.playSound(currentAnimal["sound"]!);

    setState(() {
      correctAnswer = currentAnimal["name"];
      isAudioPlayed = true;
      isButtonDisabled = false;
    });
  }

  void _onAnimalTap(int index) async {
    if (isButtonDisabled) return;

    if (!isAudioPlayed) {
      _showMessageDialog(
        title: "Escuchemos",
        message: "Debes presionar el botón 🔊 antes de elegir un animalito",
        color: Colors.orange,
      );
      return;
    }

    if (animals[index]["name"] == correctAnswer) {
      setState(() => isButtonDisabled = true);
      await AudioService.stopSound();

      validatedIndexes.add(index);

      _showMessageDialog(
        title: "¡Correcto!",
        message: "¡Has seleccionado el animalito correcto!",
        color: Colors.green,
        onClose: () {
          if (validatedIndexes.length == animals.length) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CongratulationsScreen(userName: _userName ?? 'Jugador'),
              ),
            );
          } else {
            int nextIndex = (currentIndex + 1) % animals.length;
            while (validatedIndexes.contains(nextIndex)) {
              nextIndex = (nextIndex + 1) % animals.length;
            }
            setState(() {
              currentIndex = nextIndex;
              correctAnswer = null;
              isAudioPlayed = false;
              isButtonDisabled = false;
            });
          }
        },
      );
    } else {
      _showMessageDialog(
        title: "¡Ups!",
        message: "Ese no es el animalito correcto\n¡Intenta de nuevo!",
        color: Colors.red,
      );
    }
  }

  void _showMessageDialog({
    required String title,
    required String message,
    required Color color,
    VoidCallback? onClose,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 3),
                  ),
                  child: Icon(
                    title == "¡Correcto!"
                        ? Icons.check_rounded
                        : Icons.close_rounded,
                    size: 40,
                    color: color,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: GoogleFonts.fredoka(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onClose != null) onClose();
                  },
                  child: Text(
                    "ENTENDIDO",
                    style: GoogleFonts.fredoka(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
          const SizedBox(height: 90),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
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
              style: GoogleFonts.fredoka(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "$userName",
              style: GoogleFonts.fredoka(
                fontSize: 26,
                color: Colors.orange.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "¡Completaste el juego de los animalitos!",
              style: GoogleFonts.fredoka(fontSize: 20, color: Colors.black87),
              textAlign: TextAlign.center,
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
