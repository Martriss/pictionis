import 'dart:async';
import 'package:async/async.dart';

import 'package:flutter/material.dart';
import 'package:pictionis/models/paint_event.dart';
import 'package:pictionis/service/auth_service.dart';

class DrawingState {
  final Map<String, PaintEvent> _events = {};
  PaintEvent? currentlyDrawingPaintEvent;
  final Paint selectedPaint = Paint()
    ..color = Colors.black
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 4.0;

  Map<String, PaintEvent> get events => _events;

  final StreamController<void> _remote = StreamController<void>.broadcast();
  final StreamController<void> _add = StreamController<void>.broadcast();
  final StreamController<PaintEvent> _remove =
      StreamController<PaintEvent>.broadcast();
  final StreamController<void> _clear = StreamController<void>.broadcast();

  Stream<void> get allChanges =>
      StreamGroup.mergeBroadcast([remote, add, remove, clear]);

  Stream<void> get remote => _remote.stream;
  Stream<void> get add => _add.stream;
  Stream<PaintEvent> get remove => _remove.stream;
  Stream<void> get clear => _clear.stream;

  void addLocalPaintEvent(List<Offset?> offsets) {
    // Need to reconstruct offsets otherwise its keep by ref and all events share the same offsets
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final user = Auth().currentUser!.uid;
    final key = '$timestamp-$user';
    _events[key] = (PaintEvent(
      user: user,
      timestamp: timestamp,
      offsets: [...offsets],
      paint: Paint()
        ..color = selectedPaint.color
        ..strokeCap = selectedPaint.strokeCap
        ..strokeWidth = selectedPaint.strokeWidth,
    ));
    _add.add(null);
    currentlyDrawingPaintEvent = null;
  }

  void addFirebasePaintEvent(PaintEvent event) {
    final key = '${event.timestamp}-${event.user}';
    _events[key] = (event);
    _remote.add(null);
  }

  void updateCurrentlyDrawingPaintEvent(List<Offset?> offsets) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final user = Auth().currentUser!.uid;
    currentlyDrawingPaintEvent = PaintEvent(
        user: user,
        timestamp: timestamp,
        offsets: [...offsets],
        paint: selectedPaint);
    _remote.add(null);
  }

  void removeLastEvent() {
    final last = events.values
        .where((e) => e.user == Auth().currentUser!.uid)
        .lastOrNull;
    if (last != null) removeLocalEvent(last);
  }

  void removeLocalEvent(PaintEvent event) {
    final key = '${event.timestamp}-${event.user}';
    _events.remove(key);
    _remove.add(event);
  }

  void removeFirebaseEvent(PaintEvent event) {
    final key = '${event.timestamp}-${event.user}';
    _events.remove(key);
    _remote.add(null);
  }

  void clearPaintEvents() {
    _events.clear();
    _clear.add(null);
  }

  void dispose() {
    _remote.close();
    _add.close();
    _remove.close();
    _clear.close();
  }
}
