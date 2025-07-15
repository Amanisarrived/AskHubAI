import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Onbording2 extends StatelessWidget {
  const Onbording2({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.0001.h,
          horizontal: 0,
        ),
        child: Column(
          children: [
            Image(
              image: AssetImage("assets/images/onbording2.png"),
              width: 320.w,
            ).animate().fadeIn().slideY(
              begin: 0.3,
              end: 0,
              duration: 600.ms,
              curve: Curves.easeOut,
            ),
            SizedBox(height: 20.h),
            Text(
              textAlign: TextAlign.center,
              "24/7 Answers, Ideas & Support",
              style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            Text(
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
              "From quick facts to deep conversations,\n your AI is trained to assist you across topics",
            ),
          ],
        ),
      ),
    );
  }
}
