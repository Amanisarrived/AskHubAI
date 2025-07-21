import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Onbordingbtn extends StatelessWidget {
  const Onbordingbtn({
    required this.btntext,
    required this.onPressed,
    required this.gradientColors,
    this.textcolor = Colors.white,
    super.key,
  });

  final String btntext;
  final VoidCallback onPressed;
  final List<Color> gradientColors;
  final Color textcolor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 50.w),
            child: Center(
              child: Text(
                btntext,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: textcolor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
