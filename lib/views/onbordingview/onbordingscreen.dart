import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ashub_chatai/views/authpageview/signin.dart';
import 'package:ashub_chatai/widgets/onbordingwidget/onbording1.dart';
import 'package:ashub_chatai/widgets/onbordingwidget/onbording2.dart';
import 'package:ashub_chatai/widgets/onbordingwidget/onbording3.dart';
import '../../widgets/custombtn/onbordingbtn/onbordingbtn.dart';

class Onbordingscreen extends StatefulWidget {
  const Onbordingscreen({super.key});

  @override
  State<Onbordingscreen> createState() => _OnbordingscreenState();
}

class _OnbordingscreenState extends State<Onbordingscreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  void nextPage() {
    if (currentPage < 2) {
      currentPage++;
      _pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Signin()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              physics: const ClampingScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              controller: _pageController,
              children: const [
                Onbording1(),
                Onbording2(),
                Onbording3(),
              ],
            ),

            /// Dots Indicator
            Positioned(
              bottom: 100.h, // Responsive position
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: const WormEffect(
                    activeDotColor: Color(0xFFFF6B6B),
                    dotColor: Color(0xFFFFF1F1),
                  ),
                ),
              ),
            ),

            /// Buttons
            Positioned(
              bottom: 20.h,
              left: 25.w,
              right: 25.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Onbordingbtn(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const Signin()),
                      );
                    },
                    backgroundcolor: const Color(0xFFFFF1F1),
                    textcolor: const Color(0xFFFF6B6B),
                    btntext: 'Skip',
                  ),
                  Onbordingbtn(
                    onPressed: nextPage,
                    backgroundcolor: const Color(0xFFFF6B6B),
                    textcolor: Colors.white,
                    btntext: 'Next',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
