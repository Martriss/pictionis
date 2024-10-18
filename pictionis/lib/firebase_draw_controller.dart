import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:pictionis/models/drawing_state.dart';
import 'package:pictionis/models/paint_event.dart';

// https://docs.flutter.dev/cookbook/games/firestore-multiplayer#4-create-a-firestore-controller-class
class FirebaseDrawController {
  static final _log = Logger('FirestoreController');

  final FirebaseFirestore instance;

  final DrawingState drawingState;
  final String roomID;

  /// For now, there is only one match. But in order to be ready
  /// for match-making, put it in a Firestore collection called matches.
  late final _roomRef = instance.collection('rooms').doc(roomID);

  late final _drawEventsRef = _roomRef.collection('drawEvents');

  StreamSubscription? _roomFirestoreSubscription;

  StreamSubscription? _roomLocalSubscription;

  FirebaseDrawController(
      {required this.instance,
      required this.drawingState,
      required this.roomID}) {
    // Subscribe to the remote changes (from Firestore).
    _roomFirestoreSubscription = _drawEventsRef.snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        drawingState.addFirebasePaintEvent(
            PaintEvent.fromJson(snapshot.docs.last.data()));
      }
    });

    // Subscribe to the local changes in game state.
    _roomLocalSubscription = drawingState.localChanges.listen((_) {
      if (drawingState.events.isNotEmpty) {
        log(drawingState.events.last.toJson().toString());
        _drawEventsRef.add(drawingState.events.last.toJson());
      }
    });

    log('Initialized');
  }

  void dispose() {
    _roomFirestoreSubscription?.cancel();
    _roomLocalSubscription?.cancel();

    _log.fine('Disposed');
  }
}

class FirebaseControllerException implements Exception {
  final String message;

  FirebaseControllerException(this.message);

  @override
  String toString() => 'FirebaseControllerException: $message';
}
