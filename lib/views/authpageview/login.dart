import 'package:ashub_chatai/repo/provider/auth_provider.dart';
import 'package:ashub_chatai/views/authpageview/signin.dart';
import 'package:ashub_chatai/views/mainscreens/home_screen.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';
import '../../widgets/authwidget/inputfeild.dart';
import '../../widgets/authwidget/socialicon.dart';
import '../../widgets/custombtn/authbtn/authbtn.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _visiblepass = false;
  final _loginemailController = TextEditingController();
  final _loginpasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).clearError();
    });
  }

  void _togglepass() {
    setState(() {
      _visiblepass = !_visiblepass;
    });
  }

  @override
  void dispose() {
    _loginemailController.dispose();
    _loginpasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(AuthProvider authProvider) async {
    if (_formKey.currentState!.validate()) {
      await authProvider.login(
        _loginemailController.text.trim(),
        _loginpasswordController.text.trim(),
      );
      if (mounted) {
        if (authProvider.isLoggedIn && authProvider.errorMessage == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      }
    }
  }

  void _handleSocialLogin(String provider) {
    //will be used later
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$provider login not implemented yet')),
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
                        vertical: screenHeight * 0.05.h,
                        horizontal: screenWidth * 0.03.w,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.info_outline),
                                  tooltip: 'Info',
                                ),
                              ],
                            ),
                            SizedBox(height: 40.h),
                            Padding(
                              padding: EdgeInsets.only(
                                top: screenHeight * 0.03.h,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Welcome back 👋",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                  Text(
                                    "Log in to continue your chat journey",
                                    style: TextStyle(
                                      color: const Color(0xFF666666),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  if (authProvider.errorMessage != null) ...[
                                    SizedBox(height: 20.h),
                                    Text(
                                      authProvider.errorMessage!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                  SizedBox(height: 30.h),
                                  Inputfeild(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please Enter Your Email";
                                      }
                                      if (!RegExp(
                                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                      ).hasMatch(value)) {
                                        return "Please enter a valid email";
                                      }
                                      return null;
                                    },
                                    controller: _loginemailController,
                                    keyboardtype: TextInputType.emailAddress,
                                    hinttxt: "Enter Your Email",
                                    icon: const HeroIcon(HeroIcons.envelope),
                                  ),
                                  SizedBox(height: 20.h),
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
                                    controller: _loginpasswordController,
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
                                  AuthBtn(
                                    textcolor: Colors.white,
                                    btntext: authProvider.isLoading
                                        ? 'Logging in...'
                                        : 'Log In',
                                    backgroundcolor: const Color(0xFFFF6B6B),
                                    onPressed: authProvider.isLoading
                                        ? null
                                        : () => _handleLogin(authProvider),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Don't have an account? ",
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => const Signin(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Create one",
                                          style: TextStyle(
                                            color: const Color(0xFFFF6B6B),
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 40.h),
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: Divider(endIndent: 10),
                                      ),
                                      Text(
                                        "OR",
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                      const Expanded(
                                        child: Divider(indent: 10),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 40.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                ],
                              ),
                            ),
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
