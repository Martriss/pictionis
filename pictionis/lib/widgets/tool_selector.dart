import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:pictionis/models/drawing_state.dart';

class ToolSelector extends StatelessWidget {
  ToolSelector({
    super.key,
    required DrawingState drawingState,
  }) : _drawingState = drawingState;

  final _key = GlobalKey<ExpandableFabState>();
  final DrawingState _drawingState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100.0),
      child: ExpandableFab(
        key: _key,
        openCloseStackAlignment: Alignment.bottomLeft,
        pos: ExpandableFabPos.right,
        type: ExpandableFabType.up,
        distance: 60.0,
        overlayStyle: ExpandableFabOverlayStyle(
          color: Colors.white.withOpacity(0.9),
        ),
        children: [
          // Stroke width
          FloatingActionButton.small(
            heroTag: "stroke_width_selector",
            child: const Icon(Icons.line_weight),
            onPressed: () async {
              double? widthValue = await showDialog<double>(
                  context: context,
                  builder: (BuildContext context) => StrokeWidthDialog(
                        curValue: _drawingState.selectedPaint.strokeWidth,
                      ));
              _drawingState.selectedPaint.strokeWidth =
                  widthValue ?? _drawingState.selectedPaint.strokeWidth;
              _key.currentState?.toggle();
            },
          ),
          //Color picker
          FloatingActionButton.small(
            heroTag: "color_selector",
            onPressed: () async {
              await showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: BlockPicker(
                      pickerColor: _drawingState.selectedPaint.color,
                      onColorChanged: (color) {
                        _drawingState.selectedPaint.color = color;
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
              );
              _key.currentState?.toggle();
            },
            child: const Icon(Icons.palette),
          ),
          // Shape selection
          const FloatingActionButton.small(
            heroTag: "shape_selector",
            backgroundColor: Colors.grey,
            onPressed: null,
            child: Icon(Icons.shape_line_outlined),
          ),
          // Undo
          FloatingActionButton.small(
            heroTag: "undo",
            onPressed: () {
              _drawingState.removeLastEvent();
              _key.currentState?.toggle();
            },
            child: const Icon(Icons.undo),
          ),
          // Redo
          const FloatingActionButton.small(
            heroTag: "redo",
            backgroundColor: Colors.grey,
            onPressed: null,
            child: Icon(Icons.redo),
          ),
          // Reset
          // TODO: confirm dialog
          FloatingActionButton.small(
            heroTag: "reset",
            onPressed: () {
              _drawingState.clearPaintEvents();
              _key.currentState?.toggle();
            },
            child: const Icon(Icons.restart_alt),
          )
        ],
      ),
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
