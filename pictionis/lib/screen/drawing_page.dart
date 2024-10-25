import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pictionis/firebase_draw_controller.dart';
import 'package:pictionis/models/drawing_state.dart';
import 'package:pictionis/widgets/draw_canvas.dart';
import 'package:pictionis/widgets/draw_controller.dart';
import 'package:pictionis/widgets/tool_selector.dart';
import 'package:provider/provider.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  late final DrawingState _drawingState;
  late final FirebaseDrawController? _firebaseDrawController;

  @override
  void initState() {
    super.initState();
    _drawingState = DrawingState();
    final firestore = context.read<FirebaseFirestore?>();
    if (firestore == null) {
      log("Firestore instance wasn't provided. "
          'Running without _firestoreController.');
    } else {
      _firebaseDrawController = FirebaseDrawController(
        instance: firestore,
        drawingState: _drawingState,
        roomID: "TEST",
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _firebaseDrawController?.dispose();
    _drawingState.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => _drawingState,
      child: Scaffold(
        body: const DrawController(
          child: DrawCanvas(),
        ),
        floatingActionButton: ToolSelector(),
      ),
    );
  }
}
