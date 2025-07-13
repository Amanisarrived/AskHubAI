import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Onbording3 extends StatelessWidget {
  const Onbording3({super.key});

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
              image: AssetImage("assets/images/onbording1.png"),
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
              "Your Data. Your Control.",
              style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15.h),
            Text(
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
              "Your chats are private. We never sell your \n data. You're always in change of what you \n share",
            ),
          ],
        ),
      ),
    );
  }
}
