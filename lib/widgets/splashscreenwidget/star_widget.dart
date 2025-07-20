import 'package:ashub_chatai/widgets/splashscreenwidget/star_painter.dart';
import 'package:flutter/material.dart';

class StarWidget extends StatelessWidget {
  final double size;
  final Color color;

  const StarWidget({Key? key, required this.size, required this.color})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: StarPainter(color: color), //put star painter here
    );
  }
}
