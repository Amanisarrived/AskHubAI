import 'package:ashub_chatai/widgets/splashscreenwidget/star_widget.dart';
import 'package:flutter/material.dart';

class StarAnimation extends StatelessWidget {
  StarAnimation({
    required this.starOpacity,
    required this.starSize,
    super.key,
    required this.starAnimation,
    this.left,
    this.bottom,
    this.top,
    this.right,
  });

  late Animation<double> starAnimation;
  final double starSize;
  final double starOpacity;
  final double? left;
  final double? bottom;
  final double? top;
  final double? right;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: starAnimation,
      builder: (context, child) {
        return Positioned(
          bottom: bottom,
          left: left,
          top: top,
          right: right,
          child: Transform.scale(
            scale: starSize,
            child: Opacity(
              opacity: starOpacity,
              child: StarWidget(size: 16 * starSize, color: Color(0xFFFF6B6B)),
            ),
          ),
        );
      },
    );
  }
}
