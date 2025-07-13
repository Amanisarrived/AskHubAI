import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Onbording1 extends StatelessWidget {
  const Onbording1({super.key});

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
              image: AssetImage("assets/images/onbording3.png"),
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
              "Meet Your Smarter \n Assistant",
              style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
                "Chat with your AI companion-designed to help you think, plan,create, \n and explore faster then ever ",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
