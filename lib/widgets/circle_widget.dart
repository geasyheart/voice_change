import 'dart:ui';

import 'package:flutter/material.dart';

class CircleProgressBarPainter extends CustomPainter {
  Paint _paintBackground;
  Paint _paintFore;
  var progress;

  final double radius;

  CircleProgressBarPainter(this.progress, {this.radius = 43.0}) {
    _paintBackground = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..isAntiAlias = true;
    _paintFore = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        radius, // radius
        _paintBackground);
    Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius, // radius
    );
    canvas.drawArc(rect, 0.0, progress * 3.14 / 180, false, _paintFore);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
