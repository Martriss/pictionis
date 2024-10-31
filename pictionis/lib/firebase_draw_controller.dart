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
  StreamSubscription? _clearSubscription;

  FirebaseDrawController(
      {required this.instance,
      required this.drawingState,
      required this.roomID}) {
    _roomFirestoreSubscription =
        _drawEventsRef.orderBy("timestamp").snapshots().listen((snapshot) {
      if (snapshot.docChanges.isNotEmpty) {
        for (var docChange in snapshot.docChanges) {
          final data = docChange.doc.data();
          if (data != null) {
            final event = PaintEvent.fromJson(data);
            switch (docChange.type) {
              case DocumentChangeType.added:
                drawingState.addFirebasePaintEvent(event);
                break;
              case DocumentChangeType.removed:
                drawingState.removeFirebaseEvent(event);
                break;
              case DocumentChangeType.modified:
                // Should not happen
                break;
            }
          }
        }
      }
    });

    _roomLocalSubscription = drawingState.add.listen((_) {
      if (drawingState.events.isNotEmpty) {
        final lastEvent = drawingState.events.entries.last.value.toJson();
        _drawEventsRef.add(lastEvent);
      }
    });

    _clearSubscription = drawingState.clear.listen((_) {
      _drawEventsRef.get().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
    });
  }

  void dispose() {
    _roomFirestoreSubscription?.cancel();
    _roomLocalSubscription?.cancel();
    _clearSubscription?.cancel();
  }
}

class FirebaseControllerException implements Exception {
  final String message;

  FirebaseControllerException(this.message);

  @override
  String toString() => 'FirebaseControllerException: $message';
}
