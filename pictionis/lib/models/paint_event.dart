import 'package:flutter/material.dart';

class PaintEvent {
  final List<Offset?> offsets;
  final Paint paint;

  const PaintEvent({
    required this.offsets,
    required this.paint,
  });

  factory PaintEvent.fromJson(Map<String, dynamic> json) {
    List<Offset?> offsets = (json['offsets'] as List).map((item) {
      if (item == null) return null;
      return Offset(item[0], item[1]);
    }).toList();

    Paint paint = Paint()
      ..color = Color(json['color'])
      ..strokeCap = StrokeCap.round
      ..strokeWidth = json['width'];

    return PaintEvent(
      offsets: offsets,
      paint: paint,
    );
  }

  Map<String, dynamic> toJson() => {
        'offsets': offsets,
        'color': paint.color.value,
        'width': paint.strokeWidth,
      };
}
