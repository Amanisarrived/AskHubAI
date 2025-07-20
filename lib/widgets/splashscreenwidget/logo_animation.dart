import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogoAnimation extends StatelessWidget {
  const LogoAnimation({required this.logoAnimation, super.key});

  final Animation<double> logoAnimation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: logoAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: logoAnimation.value,
            child: Opacity(
              opacity: logoAnimation.value.clamp(0.0, 1.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B6B),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.asset("assets/images/logo.png"),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'AskHubAI',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFF6B6B),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
