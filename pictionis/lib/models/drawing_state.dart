import 'dart:async';
import 'package:async/async.dart';

import 'package:flutter/material.dart';
import 'package:pictionis/models/paint_event.dart';
import 'package:pictionis/service/auth_service.dart';

class DrawingState {
  final Map<String, PaintEvent> events = {};
  final Paint currentPaint = Paint()
    ..color = Colors.black
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 4.0;

  final StreamController<void> _localChanges =
      StreamController<void>.broadcast();

  final StreamController<void> _remoteChanges =
      StreamController<void>.broadcast();

  /// A [Stream] that fires an event every time any change is made.
  Stream<void> get allChanges =>
      StreamGroup.mergeBroadcast([remoteChanges, localChanges]);

  /// A [Stream] that fires an event every time a change is made _locally_,
  /// by the player.
  Stream<void> get localChanges => _localChanges.stream;

  /// A [Stream] that fires an event every time a change is made _remotely_,
  /// by another player.
  Stream<void> get remoteChanges => _remoteChanges.stream;

  void addLocalPaintEvent(List<Offset?> offsets) {
    // Need to reconstruct offsets otherwise its keep by ref and all events share the same offsets

    var timestamp = DateTime.now().millisecondsSinceEpoch;
    var user = Auth().currentUser!.uid;
    final key = '$timestamp-$user';
    events[key] = (PaintEvent(
      user: user,
      timestamp: timestamp,
      offsets: [...offsets],
      paint: Paint()
        ..color = currentPaint.color
        ..strokeCap = currentPaint.strokeCap
        ..strokeWidth = currentPaint.strokeWidth,
    ));
    _localChanges.add(null);
  }

  void addFirebasePaintEvent(PaintEvent event) {
    final key = '${event.timestamp}-${event.user}';
    events[key] = (event);
    _remoteChanges.add(null);
  }

  void clearPaintEvents() {
    events.clear();
  }

  void dispose() {
    _remoteChanges.close();
    _localChanges.close();
  }
}
