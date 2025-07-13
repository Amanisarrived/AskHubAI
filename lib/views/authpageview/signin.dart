import 'package:ashub_chatai/repo/provider/auth_provider.dart';
import 'package:ashub_chatai/views/authpageview/verificationcode.dart';
import 'package:ashub_chatai/views/authpageview/login.dart';
import 'package:ashub_chatai/widgets/authwidget/socialicon.dart';
import 'package:ashub_chatai/widgets/custombtn/authbtn/authbtn.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';
import '../../widgets/authwidget/inputfeild.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool _visiblepass = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  void _togglepass() {
    setState(() {
      _visiblepass = !_visiblepass;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authprovider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            top: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 40.h,
                        horizontal: 24.w,
                      ),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /// App name + Info icon
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "AskHubAi",
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFF6B6B),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.info_outline),
                                ),
                              ],
                            ),

                            SizedBox(height: 55.h),

                            /// Heading
                            Text(
                              "Create your Account 🚀",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 26.sp,
                              ),
                            ),
                            Text(
                              "It only takes a minute to get started",
                              style: TextStyle(
                                color: const Color(0xFF666666),
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                              ),
                            ),

                            SizedBox(height: 30.h),

                            // Input Fields
                            Inputfeild(
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Please enter your name";
                                }
                                return null;
                              },
                              controller: _nameController,
                              textCapitalization: TextCapitalization.words,
                              hinttxt: "Enter Your Name",
                              icon: const HeroIcon(HeroIcons.user),
                            ),

                            SizedBox(height: 16.h),

                            Inputfeild(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your email";
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return "Please enter a valid email";
                                }
                                return null;
                              },
                              controller: _emailController,
                              keyboardtype: TextInputType.emailAddress,
                              hinttxt: "Enter Your Email",
                              icon: const HeroIcon(HeroIcons.envelope),
                            ),

                            SizedBox(height: 16.h),

                            Inputfeild(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your password";
                                }
                                if (value.length < 6) {
                                  return "Password must be at least 6 characters";
                                }
                                return null;
                              },
                              controller: _passwordController,
                              suficIcon: IconButton(
                                onPressed: _togglepass,
                                icon: _visiblepass
                                    ? const HeroIcon(HeroIcons.eyeSlash)
                                    : const HeroIcon(HeroIcons.eye),
                              ),
                              isVisible: !_visiblepass,
                              hinttxt: "Enter Your Password",
                              icon: const HeroIcon(HeroIcons.lockClosed),
                            ),

                            SizedBox(height: 20.h),

                            // Error Message

                            /// Create Account Button
                            AuthBtn(
                              textcolor: Colors.white,
                              btntext: "Create Account",
                              backgroundcolor: const Color(0xFFFF6B6B),
                              onPressed: () async {
                                if (authprovider.isLoading) return;
                                debugPrint("Button tapped");

                                if (_formkey.currentState!.validate()) {
                                  debugPrint("Form validate");
                                  await authprovider.signUp(
                                    _nameController.text.trim(),
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                  );
                                  if (authprovider.isSignedUp) {
                                    debugPrint("Signup");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Verification code sent to your email',
                                        ),
                                      ),
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Verificationcode(
                                          email: _emailController.text.trim(),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),

                            /// Already have account
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? ",
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const Login(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      color: const Color(0xFFFF6B6B),
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 30.h),

                            /// OR Divider
                            Row(
                              children: [
                                const Expanded(child: Divider(endIndent: 10)),
                                Text("OR", style: TextStyle(fontSize: 14.sp)),
                                const Expanded(child: Divider(indent: 10)),
                              ],
                            ),

                            SizedBox(height: 40.h),

                            /// Social Icons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Socialicon(
                                  icon: const Icon(
                                    EvaIcons.google,
                                    color: Color(0xFFFF6B6B),
                                  ),
                                ),
                                Socialicon(
                                  icon: const Icon(
                                    EvaIcons.facebook,
                                    color: Color(0xFFFF6B6B),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 40.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
