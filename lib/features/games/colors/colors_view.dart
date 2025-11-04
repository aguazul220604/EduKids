import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/audio_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ColorsView extends StatefulWidget {
  const ColorsView({super.key});

  @override
  State<ColorsView> createState() => _ColorsViewState();
}

class _ColorsViewState extends State<ColorsView>
    with SingleTickerProviderStateMixin {
  String? _userName;
  final List<Map<String, dynamic>> colorsGame = [
    {
      "name": "Rojo",
      "color": Colors.red,
      "sound": "sounds/colors/red.mp3",
      "images": [
        "assets/images/colors/red_1.png",
        "assets/images/colors/red_2.png",
        "assets/images/colors/red_3.png",
        "assets/images/colors/red_4.png",
      ],
    },
    {
      "name": "Azul",
      "color": Colors.blue,
      "sound": "sounds/colors/blue.mp3",
      "images": [
        "assets/images/colors/blue_1.png",
        "assets/images/colors/blue_2.png",
        "assets/images/colors/blue_3.png",
        "assets/images/colors/blue_4.png",
      ],
    },
    {
      "name": "Verde",
      "color": Colors.green,
      "sound": "sounds/colors/green.mp3",
      "images": [
        "assets/images/colors/green_1.png",
        "assets/images/colors/green_2.png",
        "assets/images/colors/green_3.png",
        "assets/images/colors/green_4.png",
      ],
    },
    {
      "name": "Amarillo",
      "color": Colors.yellow,
      "sound": "sounds/colors/yellow.mp3",
      "images": [
        "assets/images/colors/yellow_1.png",
        "assets/images/colors/yellow_2.png",
        "assets/images/colors/yellow_3.png",
        "assets/images/colors/yellow_4.png",
      ],
    },
  ];

  int? selectedColorIndex;
  Set<int> validatedColors = {};
  bool isButtonDisabled = false;

  // Animación de rebote
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

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

  Future<void> _playColorSound(int index) async {
    if (isButtonDisabled) return;

    setState(() => isButtonDisabled = true);

    final color = colorsGame[index];

    // Inicia animación de rebote
    _controller.forward(from: 0.0);

    // Reproduce el sonido
    await AudioService.playSound(color["sound"]!);

    // Marca como seleccionado
    setState(() {
      selectedColorIndex = index;
      validatedColors.add(index);
    });

    // Pausa breve antes de desbloquear
    await Future.delayed(const Duration(seconds: 2));

    if (validatedColors.length == colorsGame.length) {
      // Si ya terminó todos los colores
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
      setState(() => isButtonDisabled = false); // desbloquea botones
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
          // Botones de colores
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
                  onTap: isButtonDisabled ? null : () => _playColorSound(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: color["color"],
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(2, 2),
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

          const SizedBox(height: 70),

          // Mostrar imágenes del color seleccionado
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
                      child: Container(
                        color: Colors.white,
                        child: Image.asset(imgPath, fit: BoxFit.contain),
                      ),
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
