import 'package:flutter/material.dart';

class PaintEvent {
  final String user;
  final int timestamp;
  final List<Offset?> offsets;
  final Paint paint;

  const PaintEvent({
    required this.user,
    required this.timestamp,
    required this.offsets,
    required this.paint,
  });

  factory PaintEvent.fromJson(Map<String, dynamic> json) {
    List<Offset?> offsets = (json['offsets'] as List).map((item) {
      if (item == null) return null;
      return Offset(item['x'], item['y']);
    }).toList();

    Paint paint = Paint()
      ..color = Color(json['color'])
      ..strokeCap = StrokeCap.round
      ..strokeWidth = json['width'];

    return PaintEvent(
      user: json['user'] as String,
      timestamp: json['timestamp'] as int,
      offsets: offsets,
      paint: paint,
    );
  }

  Map<String, dynamic> toJson() => {
        'user': user,
        'timestamp': timestamp,
        'offsets': offsets
            .map((offset) =>
                offset != null ? {'x': offset.dx, 'y': offset.dy} : null)
            .toList(),
        'color': paint.color.value,
        'width': paint.strokeWidth,
      };
}
