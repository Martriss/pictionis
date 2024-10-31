import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pictionis/models/drawing_state.dart';
import 'package:pictionis/models/paint_event.dart';

// https://docs.flutter.dev/cookbook/games/firestore-multiplayer#4-create-a-firestore-controller-class
class FirebaseDrawController {
  final FirebaseFirestore instance;

  final DrawingState drawingState;
  final String roomID;

  late final _roomRef = instance.collection('rooms').doc(roomID);

  late final _drawEventsRef = _roomRef.collection('drawEvents');

  StreamSubscription? _roomFirestoreSubscription;

  StreamSubscription? _roomLocalSubscription;

  FirebaseDrawController(
      {required this.instance,
      required this.drawingState,
      required this.roomID}) {
    _roomFirestoreSubscription = _drawEventsRef.snapshots().listen((snapshot) {
      if (snapshot.docChanges.isNotEmpty) {
        for (var docChange in snapshot.docChanges) {
          switch (docChange.type) {
            case DocumentChangeType.added:
              final data = docChange.doc.data();
              if (data != null) {
                final event = PaintEvent.fromJson(data);
                drawingState.addFirebasePaintEvent(event);
              }
              break;
            case DocumentChangeType.removed:
              log('message');
              // TODO: add removeEvent from gamestate
              break;
            case DocumentChangeType.modified:
              // Should not happen
              break;
          }
        }
      }
    });

//TODO: Add user id to event
    _roomLocalSubscription = drawingState.localChanges.listen((_) {
      if (drawingState.events.isNotEmpty) {
        final lastEvent = drawingState.events.entries.last.value.toJson();
        _drawEventsRef.add(lastEvent);
      }
    });
  }

  void dispose() {
    _roomFirestoreSubscription?.cancel();
    _roomLocalSubscription?.cancel();
  }
}

class FirebaseControllerException implements Exception {
  final String message;

  FirebaseControllerException(this.message);

  @override
  String toString() => 'FirebaseControllerException: $message';
}
