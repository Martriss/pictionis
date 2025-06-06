import 'package:flutter/material.dart';
import 'package:pictionis/models/drawing_state.dart';
import 'package:provider/provider.dart';

class DrawController extends StatefulWidget {
  final Widget child;

  const DrawController({super.key, required this.child});

  @override
  State<DrawController> createState() => _DrawControllerState();
}

class _DrawControllerState extends State<DrawController> {
  List<Offset?> points = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        points.add(details.localPosition);
        context.read<DrawingState>().updateCurrentlyDrawingPaintEvent(points);
      },
      onPanEnd: (details) {
        context.read<DrawingState>().addLocalPaintEvent(points);
        points.clear();
      },
      child: widget.child,
    );
  }
}
