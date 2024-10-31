import 'dart:async';
import 'package:async/async.dart';

import 'package:flutter/material.dart';
import 'package:pictionis/models/paint_event.dart';
import 'package:pictionis/service/auth_service.dart';

class DrawingState {
  final Map<String, PaintEvent> _events = {};
  final Paint currentPaint = Paint()
    ..color = Colors.black
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 4.0;

  Map<String, PaintEvent> get events => _events;

  final StreamController<void> _remote = StreamController<void>.broadcast();
  final StreamController<void> _add = StreamController<void>.broadcast();
  final StreamController<void> _remove = StreamController<void>.broadcast();
  final StreamController<void> _clear = StreamController<void>.broadcast();

  Stream<void> get allChanges =>
      StreamGroup.mergeBroadcast([remote, add, remove, clear]);

  Stream<void> get remote => _remote.stream;
  Stream<void> get add => _add.stream;
  Stream<void> get remove => _remove.stream;
  Stream<void> get clear => _clear.stream;

  void addLocalPaintEvent(List<Offset?> offsets) {
    // Need to reconstruct offsets otherwise its keep by ref and all events share the same offsets
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    var user = Auth().currentUser!.uid;
    final key = '$timestamp-$user';
    _events[key] = (PaintEvent(
      user: user,
      timestamp: timestamp,
      offsets: [...offsets],
      paint: Paint()
        ..color = currentPaint.color
        ..strokeCap = currentPaint.strokeCap
        ..strokeWidth = currentPaint.strokeWidth,
    ));
    _add.add(null);
  }

  void addFirebasePaintEvent(PaintEvent event) {
    final key = '${event.timestamp}-${event.user}';
    _events[key] = (event);
    _remote.add(null);
  }

  void removeLastEvent() {
    removeLocalEvent(
        events.values.lastWhere((e) => e.user == Auth().currentUser!.uid));
  }

  void removeLocalEvent(PaintEvent event) {
    final key = '${event.timestamp}-${event.user}';
    _events.remove(key);
    _remove.add(null);
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
