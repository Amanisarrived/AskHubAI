import 'package:ashub_chatai/repo/provider/auth_provider.dart';
import 'package:ashub_chatai/views/mainscreens/home_screen.dart';
import 'package:ashub_chatai/views/onbordingview/onbordingscreen.dart';
import 'package:ashub_chatai/widgets/splashscreenwidget/logo_animation.dart';
import 'package:ashub_chatai/widgets/splashscreenwidget/star_animation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _star1Controller;
  late AnimationController _star2Controller;
  late AnimationController _star3Controller;
  late AnimationController _logoController;

  late Animation<double> _star1Animation;
  late Animation<double> _star2Animation;
  late Animation<double> _star3Animation;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _star1Controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _star2Controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _star3Controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Initialize animations
    _star1Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _star1Controller, curve: Curves.easeInOut),
    );

    _star2Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _star2Controller, curve: Curves.easeInOut),
    );

    _star3Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _star3Controller, curve: Curves.easeInOut),
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    // Start animations and check login status
    _startAnimations();
    _checkLoginStatus();
  }

  void _startAnimations() {
    _logoController.forward();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _star1Controller.repeat(reverse: true);
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _star2Controller.repeat(reverse: true);
      }
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        _star3Controller.repeat(reverse: true);
      }
    });
  }

  Future<void> _checkLoginStatus() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      // Wait for animations and token loading
      await Future.delayed(const Duration(seconds: 6));
      if (mounted) {
        debugPrint(
          'SplashScreen: isLoggedIn=${authProvider.isLoggedIn}, token=${authProvider.token?.substring(0, 10)}..., error=${authProvider.errorMessage}',
        );
        if (authProvider.isLoggedIn && authProvider.token != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Onbordingscreen()),
          );
        }
      }
    } catch (e) {
      debugPrint('SplashScreen error: $e');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Onbordingscreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _star1Controller.dispose();
    _star2Controller.dispose();
    _star3Controller.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Stack(
        children: [
          StarAnimation(
            top: 120.w,
            left: 60.h,
            starOpacity: (0.6 + (_star1Animation.value * 0.4)).clamp(0.0, 1.0),
            starSize: 0.8 + (_star1Animation.value * 0.4),
            starAnimation: _star1Animation,
          ),

          StarAnimation(
            bottom: 120.h,
            right: 40.w,
            starOpacity: (0.7 + (_star2Animation.value * 0.3)).clamp(0.0, 1.0),
            starSize: 1.2 + (_star2Animation.value * 0.5),
            starAnimation: _star2Animation,
          ),

          StarAnimation(
            bottom: 220.h,
            left: 30.w,
            starOpacity: (0.5 + (_star3Animation.value * 0.5)).clamp(0.0, 1.0),
            starSize: 0.8 + (_star3Animation.value * 0.3),
            starAnimation: _star3Animation,
          ),

          LogoAnimation(logoAnimation: _logoAnimation),
        ],
      ),
    );
  }
}
