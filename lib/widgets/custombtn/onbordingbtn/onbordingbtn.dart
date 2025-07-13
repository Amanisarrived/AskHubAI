import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Onbordingbtn extends StatelessWidget {
  const Onbordingbtn({
    required this.textcolor,
    required this.btntext,
    required this.backgroundcolor,
    required this.onPressed,
    super.key,
  });
  final String btntext;
  final Color textcolor;
  final Color backgroundcolor;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundcolor,
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 50.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      ),
      child: Text(
        btntext,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
          color: textcolor,
        ),
      ),
    );
  }
}
