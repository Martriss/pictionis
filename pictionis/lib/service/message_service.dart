import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pictionis/models/message_event.dart';
import 'package:pictionis/service/auth_service.dart';

class MessageService {
  final User? user = Auth().currentUser;

  Future<void> sendMessage({
    required String message,
    required String roomID
  }) async {
    if (message == '') return; // No need to do something if empty

    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomID);
    final docMessages = roomRef.collection('messages').doc();

    final msg = MessageEvent(user: user?.uid ?? '', message: message);
    final json = msg.toJson();

    await docMessages.set(json);
  }
}
