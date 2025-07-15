import 'package:ashub_chatai/views/authpageview/login.dart';
import 'package:ashub_chatai/widgets/custombtn/authbtn/authbtn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Accountcreatedpage extends StatelessWidget {
  const Accountcreatedpage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          "AskHubAi",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Color(0xFFFF6B6B),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.05.h),
          child: Column(
            children: [
              Text(
                "Account Created 🎉",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
              ),
              Text(
                textAlign: TextAlign.center,
                "Thanks for joining! Let's login and explore what \n you can do",
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Color(0xFF666666),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Image(
                    image: AssetImage("assets/images/created.png"),
                    width: 320.w,
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .moveY(
                    begin: -10, // 👇 Up-Down distance
                    end: 10,
                    duration: 1000.ms,
                    curve: Curves.easeInOut,
                  ),
              SizedBox(height: 50.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: AuthBtn(
                  textcolor: Colors.white,
                  btntext: "Log In",
                  backgroundcolor: Color(0xFFFF6B6B),
                  onPressed: () {
                    throw Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Login()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
