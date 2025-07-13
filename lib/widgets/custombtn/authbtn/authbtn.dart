import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthBtn extends StatelessWidget {
  final Color textcolor;
  final String btntext;
  final Color backgroundcolor;
  final Future<void> Function()? onPressed; // Changed to Future<void> Function()?

  const AuthBtn({
    super.key,
    required this.textcolor,
    required this.btntext,
    required this.backgroundcolor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed != null
          ? () => onPressed!()
          : null, // Wrap async function in synchronous callback
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundcolor,
        minimumSize: Size(double.infinity, 48.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Text(
        btntext,
        style: TextStyle(
          color: textcolor,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}