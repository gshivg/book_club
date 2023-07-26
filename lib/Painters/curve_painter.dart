import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    // TODO: Set properties to paint
    // paint.color = Colors.green[800]!;
    paint.shader =
        ui.Gradient.linear(Offset.zero, Offset(size.width / 2, size.height), [
      const Color(0xff16697A),
      const Color(0xff141414),
    ]);
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 2.0;

    var path = Path();
    // TODO: Draw path
    // path.lineTo(size.width, size.height);
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.35);
    path.quadraticBezierTo(
        size.width / 2, size.height * 0.25, size.width, size.height * 0.35);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CurvePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(CurvePainter oldDelegate) => false;
}
