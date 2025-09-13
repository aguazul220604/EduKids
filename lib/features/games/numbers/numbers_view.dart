import 'package:flutter/material.dart';
import '../../../services/audio_service.dart';
import '../../../core/constants/app_routes.dart';

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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("¡Completaste los números!")),
            );
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pushReplacementNamed(context, AppRoutes.menu);
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
      appBar: AppBar(title: const Text("Juego: Números")),
      body: Center(
        child: GestureDetector(
          onTap: _playAndNext,
          child: Image.asset(currentNumber["image"]!, width: 200, height: 200),
        ),
      ),
    );
  }
}
