import 'dart:math' as math;

import 'package:flutter/material.dart';

class DateRangePainter extends StatelessWidget {
  const DateRangePainter({
    super.key,
    this.start,
    this.end,
    this.radius = 16,
    this.color = Colors.blue,
  });

  final Offset? start;

  final Offset? end;

  final double radius;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter:
            RangePainter(start: start, end: end, radius: radius, color: color),
      ),
    );
  }
}

class RangePainter extends CustomPainter {
  const RangePainter({
    required this.radius,
    required this.color,
    this.start,
    this.end,
  });

  final Offset? start;

  final Offset? end;

  final double radius;

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = true
      ..color = color;
    final path = Path();
    if (start != null && end != null) {
      path
        ..addArc(
          Rect.fromLTWH(start!.dx, 0, radius * 2, radius * 2),
          math.pi * 0.5,
          math.pi,
        )
        ..addRect(
          Rect.fromLTRB(start!.dx + radius, 0, end!.dx + radius, radius * 2),
        )
        ..addArc(
          Rect.fromLTWH(end!.dx, 0, radius * 2, radius * 2),
          math.pi * 1.5,
          math.pi,
        );
    } else if (start != null) {
      path
        ..addArc(
          Rect.fromLTWH(start!.dx, 0, radius * 2, radius * 2),
          math.pi * 0.5,
          math.pi,
        )
        ..addRect(Rect.fromLTRB(start!.dx + radius, 0, size.width, radius * 2));
    } else if (end != null) {
      path
        ..addRect(Rect.fromLTWH(0, 0, end!.dx + radius, radius * 2))
        ..addArc(
          Rect.fromLTWH(end!.dx, 0, radius * 2, radius * 2),
          math.pi * 1.5,
          math.pi,
        );
    } else {
      path.addRect(Rect.fromLTWH(0, 0, size.width, radius * 2));
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
