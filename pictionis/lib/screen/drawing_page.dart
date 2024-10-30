import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pictionis/firebase_draw_controller.dart';
import 'package:pictionis/models/drawing_state.dart';
import 'package:pictionis/widgets/draw_canvas.dart';
import 'package:pictionis/widgets/draw_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  late final DrawingState _drawingState;
  late final FirebaseDrawController? _firebaseDrawController;
  final _key = GlobalKey<ExpandableFabState>();

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
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          key: _key,
          openCloseStackAlignment: Alignment.bottomLeft,
          pos: ExpandableFabPos.right,
          type: ExpandableFabType.up,
          distance: 60.0,
          overlayStyle: ExpandableFabOverlayStyle(
            color: Colors.white.withOpacity(0.9),
          ),
          children: [
            FloatingActionButton.small(
              child: const Icon(Icons.line_weight),
              onPressed: () async {
                double? widthValue = await showDialog<double>(
                    context: context,
                    builder: (BuildContext context) => StrokeWidthDialog(
                          curValue: _drawingState.currentPaint.strokeWidth,
                        ));
                _drawingState.currentPaint.strokeWidth =
                    widthValue ?? _drawingState.currentPaint.strokeWidth;
                _key.currentState?.toggle();
              },
            ),
            FloatingActionButton.small(
              onPressed: () async {
                await _colorPickerDialogBuilder(context);
                _key.currentState?.toggle();
              },
              child: const Icon(Icons.palette),
            ),
            FloatingActionButton.small(
              onPressed: () {},
              child: const Icon(Icons.undo),
            ),
            FloatingActionButton.small(
              onPressed: () {},
              child: const Icon(Icons.restart_alt),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _colorPickerDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: BlockPicker(
            pickerColor: _drawingState.currentPaint.color,
            onColorChanged: (color) {
              _drawingState.currentPaint.color = color;
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}

class StrokeWidthDialog extends StatefulWidget {
  const StrokeWidthDialog({
    super.key,
    required this.curValue,
  });

  final double curValue;

  @override
  State<StrokeWidthDialog> createState() => _StrokeWidthDialogState();
}

class _StrokeWidthDialogState extends State<StrokeWidthDialog> {
  double? _currentSliderValue;

  @override
  Widget build(BuildContext context) {
    final value = _currentSliderValue ?? widget.curValue;
    return AlertDialog(
      alignment: Alignment.bottomLeft,
      content: SizedBox(
        height: 20,
        child: Slider(
          value: value,
          min: 4,
          max: 32,
          divisions: 7,
          label: value.round().toString(),
          onChanged: (double value) {
            setState(() {
              _currentSliderValue = value;
            });
          },
          onChangeEnd: (value) => Navigator.of(context).pop(value),
        ),
      ),
    );
  }
}
