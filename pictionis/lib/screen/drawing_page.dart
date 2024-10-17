import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  List<Offset?> points = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Pictionis"),
      // ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('drawings').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Offset?> pointsFromFirestore = [];
          for (var doc in snapshot.data!.docs) {
            var points = doc['points'];
            pointsFromFirestore.add(Offset(points[0], points[1]));
            pointsFromFirestore.add(Offset(points[2], points[3]));
          }

          return GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                points.add(details.localPosition);
              });
            },
            onPanEnd: (details) {
              if (points.length >= 2) {
                saveDrawing(points.first!, points.last!);
              }
              setState(() {
                points.add(null);
              });
            },
            child: CustomPaint(
              painter: ShapePainter(pointsFromFirestore + points),
              size: Size.infinite,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            points.clear();
          });
        },
        child: const Icon(Icons.clear),
      ),
    );
  }

  void saveDrawing(Offset startPoint, Offset endPoint) async {
    await FirebaseFirestore.instance.collection('drawings').add({
      'points': [startPoint.dx, startPoint.dy, endPoint.dx, endPoint.dy],
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

class ShapePainter extends CustomPainter {
  final List<Offset?> points;

  ShapePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
