import 'package:flutter/material.dart';
import '../../core/constants/app_routes.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menú Principal')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _menuButton(context, 'Animales', AppRoutes.animals),
          _menuButton(context, 'Colores', AppRoutes.colors),
          _menuButton(context, 'Letras', AppRoutes.letters),
          _menuButton(context, 'Números', AppRoutes.numbers),
        ],
      ),
    );
  }

  Widget _menuButton(BuildContext context, String title, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
