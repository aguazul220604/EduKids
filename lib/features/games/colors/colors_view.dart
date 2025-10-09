import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/audio_service.dart';

class ColorsView extends StatefulWidget {
  const ColorsView({super.key});

  @override
  State<ColorsView> createState() => _ColorsViewState();
}

class _ColorsViewState extends State<ColorsView> {
  final List<Map<String, dynamic>> colorsGame = [
    {
      "name": "Rojo",
      "color": Colors.red,
      "sound": "sounds/colors/red.mp3",
      "images": [
        "assets/images/colors/red_1.jpg",
        "assets/images/colors/red_2.jpg",
        "assets/images/colors/red_3.jpg",
        "assets/images/colors/red_4.jpg",
      ],
    },
    {
      "name": "Azul",
      "color": Colors.blue,
      "sound": "sounds/colors/blue.mp3",
      "images": [
        "assets/images/colors/blue_1.jpg",
        "assets/images/colors/blue_2.jpg",
        "assets/images/colors/blue_3.jpg",
        "assets/images/colors/blue_4.jpg",
      ],
    },
    {
      "name": "Verde",
      "color": Colors.green,
      "sound": "sounds/colors/green.mp3",
      "images": [
        "assets/images/colors/green_1.jpg",
        "assets/images/colors/green_2.jpg",
        "assets/images/colors/green_3.jpg",
        "assets/images/colors/green_4.jpg",
      ],
    },
    {
      "name": "Amarillo",
      "color": Colors.yellow,
      "sound": "sounds/colors/yellow.mp3",
      "images": [
        "assets/images/colors/yellow_1.jpg",
        "assets/images/colors/yellow_2.jpg",
        "assets/images/colors/yellow_3.jpg",
        "assets/images/colors/yellow_4.jpg",
      ],
    },
  ];

  int? selectedColorIndex;
  Set<int> validatedColors = {};

  void _playColorSound(int index) async {
    final color = colorsGame[index];
    await AudioService.playSound(color["sound"]!);

    setState(() {
      selectedColorIndex = index;
      validatedColors.add(index);
    });

    if (validatedColors.length == colorsGame.length) {
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
    final currentColor = selectedColorIndex != null
        ? colorsGame[selectedColorIndex!]
        : null;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 126, 171),
      appBar: AppBar(
        title: Text(
          "Colorcitos",
          style: GoogleFonts.fredoka(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 72, 136),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: colorsGame.asMap().entries.map((entry) {
                final index = entry.key;
                final color = entry.value;
                final isValidated = validatedColors.contains(index);

                return GestureDetector(
                  onTap: () => _playColorSound(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: color["color"],
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: isValidated
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 32,
                              )
                            : null,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        color["name"],
                        style: GoogleFonts.fredoka(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 30),

          if (currentColor != null)
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: currentColor["images"].map<Widget>((imgPath) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(imgPath, fit: BoxFit.cover),
                    ),
                  );
                }).toList(),
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
