import 'package:flutter/material.dart';
import 'package:pictionis/models/game_state.dart';
import 'package:pictionis/widgets/draw_canvas.dart';
import 'package:pictionis/widgets/draw_controller.dart';
import 'package:provider/provider.dart';

class DrawingPage extends StatelessWidget {
  const DrawingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const DrawController(
        child: DrawCanvas(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<GameState>().clearPaintEvents();
        },
        child: const Icon(Icons.clear),
      ),
    );
  }
}
