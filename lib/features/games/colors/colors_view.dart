import 'package:flutter/material.dart';
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("¡Completaste los colores!")),
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, "/menu");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentColor = selectedColorIndex != null
        ? colorsGame[selectedColorIndex!]
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text("Juego: Colores")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Wrap(
            spacing: 20,
            children: colorsGame.asMap().entries.map((entry) {
              final index = entry.key;
              final color = entry.value;

              return GestureDetector(
                onTap: () => _playColorSound(index),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: color["color"],
                  child: validatedColors.contains(index)
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),

          if (currentColor != null)
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: currentColor["images"].map<Widget>((imgPath) {
                  return Image.asset(imgPath, fit: BoxFit.contain);
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
