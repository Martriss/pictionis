import 'package:flutter/material.dart';
import 'package:pictionis/models/paint_event.dart';

class GameState extends ChangeNotifier {
  final List<PaintEvent> events = [];
  final Paint currentPaint = Paint()
    ..color = Colors.black
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 4.0;

  void addPaintEvent(List<Offset?> offsets) {
    // Need to reconstruct offsets otherwise its keep by ref and all events share the same offsets
    events.add(PaintEvent(offsets: [...offsets], paint: currentPaint));
    notifyListeners();
  }

  void clearPaintEvents() {
    events.clear();
    notifyListeners();
  }
}
