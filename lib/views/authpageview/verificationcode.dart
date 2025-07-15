import 'package:ashub_chatai/repo/provider/auth_provider.dart';
import 'package:ashub_chatai/views/authpageview/accountcreatedpage.dart';
import 'package:ashub_chatai/views/authpageview/login.dart';
import 'package:ashub_chatai/views/authpageview/signin.dart';
import 'package:ashub_chatai/views/authpageview/verification_feild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../widgets/custombtn/authbtn/authbtn.dart';

class Verificationcode extends StatefulWidget {
  const Verificationcode({required this.email, super.key});

  final String email;

  @override
  State<Verificationcode> createState() => _VerificationcodeState();
}

class _VerificationcodeState extends State<Verificationcode> {
  final _otp1 = TextEditingController();
  final _otp2 = TextEditingController();
  final _otp3 = TextEditingController();
  final _otp4 = TextEditingController();
  final _otp5 = TextEditingController();
  final _otp6 = TextEditingController();

  @override
  void dispose() {
    _otp1.dispose();
    _otp2.dispose();
    _otp3.dispose();
    _otp4.dispose();
    _otp5.dispose();
    _otp6.dispose();
    super.dispose();
  }

  String _getOtpCode() {
    return _otp1.text + _otp2.text + _otp3.text + _otp4.text + _otp5.text + _otp6.text;
  }

  Future<void> _verifyOtp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final otpCode = _getOtpCode();

    if (otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
      return;
    }

    await authProvider.verifyEmail(widget.email, otpCode);

    if (mounted && authProvider.errorMessage == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Accountcreatedpage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage ?? 'Verification failed')),
      );
    }
  }

  void _navigateBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Signin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.07.h,
                horizontal: screenWidth * 0.03.w,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "AskHubAi",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFF6B6B),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _navigateBack,
                            icon: const Icon(Icons.arrow_back),
                            tooltip: 'Back',
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.info_outline),
                            tooltip: 'Info',
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.05.h),
                    child: Column(
                      children: [
                        Text(
                          "Enter Verification Code",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.sp,
                          ),
                        )
                            .animate()
                            .scale(
                          begin: const Offset(0.5, 0.5),
                          duration: 500.ms,
                          curve: Curves.easeOut,
                        )
                            .fadeIn(duration: 500.ms),
                        Text(
                          textAlign: TextAlign.center,
                          "We've sent an OTP code to ${widget.email}\n(It may take a few seconds to arrive)",
                          style: TextStyle(
                            color: const Color(0xFF666666),
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                          ),
                        )
                            .animate()
                            .scale(
                          begin: const Offset(0.5, 0.5),
                          duration: 500.ms,
                          curve: Curves.easeOut,
                        )
                            .fadeIn(duration: 500.ms),
                        SizedBox(height: 40.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            VerificationFeild(controller: _otp1),
                            VerificationFeild(controller: _otp2),
                            VerificationFeild(controller: _otp3),
                            VerificationFeild(controller: _otp4),
                            VerificationFeild(controller: _otp5),
                            VerificationFeild(controller: _otp6),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        if (authProvider.errorMessage != null)
                          Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: Text(
                              authProvider.errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        SizedBox(height: 20.h),
                        AuthBtn(
                          textcolor: Colors.white,
                          btntext: authProvider.isLoading ? 'Verifying...' : 'Verify',
                          backgroundcolor: const Color(0xFFFF6B6B),
                          onPressed: authProvider.isLoading ? null : _verifyOtp,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}