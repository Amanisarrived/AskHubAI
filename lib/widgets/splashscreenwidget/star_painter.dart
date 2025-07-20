import 'package:flutter/material.dart';

class StarPainter extends CustomPainter {
  final Color color;

  StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2;

    path.moveTo(centerX, centerY - radius);
    path.quadraticBezierTo(
      centerX + radius * 0.3,
      centerY - radius * 0.3,
      centerX + radius,
      centerY,
    );
    path.quadraticBezierTo(
      centerX + radius * 0.3,
      centerY + radius * 0.3,
      centerX,
      centerY + radius,
    );
    path.quadraticBezierTo(
      centerX - radius * 0.3,
      centerY + radius * 0.3,
      centerX - radius,
      centerY,
    );
    path.quadraticBezierTo(
      centerX - radius * 0.3,
      centerY - radius * 0.3,
      centerX,
      centerY - radius,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
