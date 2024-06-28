import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FacePainter extends CustomPainter {
  final double expressionValue;
  final double okvalue;
  final double badvalue;
  final double goodvalue;
  final double okeyeball;
  final double badeyeball;
  final double goodeyeball;

  const FacePainter({
    required this.expressionValue,
    required this.okvalue,
    required this.badvalue,
    required this.goodvalue,
    required this.okeyeball,
    required this.badeyeball,
    required this.goodeyeball,
  });

  @override
  void paint(Canvas canvas, Size size) {
    drawEye(canvas, size, Offset(size.width * 0.35, size.height * 0.35));
    drawEye(canvas, size, Offset(size.width * 0.65, size.height * 0.35));

    drawMouth(canvas, size, expressionValue);
  }

  void drawEye(Canvas canvas, Size size, Offset position) {
    Paint eyePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(position, size.width * 0.08, eyePaint);
    Offset dotPosition = position;

    Paint dotPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    if (expressionValue < 2) {
      dotPosition =
          Offset(position.dx - badeyeball, position.dy - size.width * 0.02);
      canvas.drawCircle(dotPosition, size.width * 0.02, dotPaint);
    } else if (expressionValue < 3) {
      dotPosition =
          Offset(position.dx - goodeyeball, position.dy + size.width * 0.03);
      canvas.drawCircle(dotPosition, size.width * 0.02, dotPaint);
    } else {
      dotPosition =
          Offset(position.dx, position.dy + size.width * okeyeball - 5);
      canvas.drawCircle(dotPosition, size.width * 0.02, dotPaint);
    }
  }

  void drawMouth(Canvas canvas, Size size, double value) {
    Paint mouthPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    Path path = Path();

    if (value < 2) {
      path.moveTo(size.width * 0.2, size.height * 0.73);
      path.quadraticBezierTo(size.width * 0.5, size.height * badvalue,
          size.width * 0.7, size.height * 0.7);
    } else if (value < 3) {
      path.moveTo(size.width * 0.25, size.height * 0.6);
      path.quadraticBezierTo(size.width * 0.55, size.height * goodvalue,
          size.width * 0.8, size.height * 0.6);
    } else {
      path.moveTo(size.width * 0.25, size.height * 0.7);
      path.quadraticBezierTo(size.width * 0.5, size.height * okvalue,
          size.width * 0.8, size.height * 0.7);
    }

    canvas.drawPath(path, mouthPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 200);
    path.quadraticBezierTo(size.width / 2, 0, 0, 200);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
