import 'package:flutter/material.dart';
import 'package:pictionis/models/game_state.dart';
import 'package:pictionis/models/paint_event.dart';
import 'package:provider/provider.dart';

class DrawCanvas extends StatelessWidget {
  const DrawCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(builder: (context, state, _) {
      return CustomPaint(
        painter: Painter(state.events),
        size: Size.infinite,
      );
    });
  }
}

class Painter extends CustomPainter {
  final List<PaintEvent> events;

  Painter(this.events);

  @override
  void paint(Canvas canvas, Size size) {
    for (var event in events) {
      for (int i = 0; i < event.offsets.length - 1; i++) {
        if (event.offsets[i] != null && event.offsets[i + 1] != null) {
          canvas.drawLine(
              event.offsets[i]!, event.offsets[i + 1]!, event.paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
