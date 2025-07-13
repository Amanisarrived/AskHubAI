import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Socialicon extends StatelessWidget {
  const Socialicon({required this.icon,super.key});

  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 2,color: Color(0xFFE0E0E0))
      ),
      padding: const EdgeInsets.all(4),
      child: IconButton(
        icon: icon,
        iconSize: 25.r,
        onPressed: () {

        },
      ),
    );
  }
}
