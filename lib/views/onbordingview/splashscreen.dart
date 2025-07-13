import 'package:ashub_chatai/repo/provider/auth_provider.dart';
import 'package:ashub_chatai/views/mainscreens/home_screen.dart';
import 'package:ashub_chatai/views/onbordingview/onbordingscreen.dart';
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
      await Future.delayed(const Duration(seconds: 2));
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
          AnimatedBuilder(
            animation: _star1Animation,
            builder: (context, child) {
              return Positioned(
                top: 120.h,
                left: 60.w,
                child: Transform.scale(
                  scale: 0.8 + (_star1Animation.value * 0.4),
                  child: Opacity(
                    opacity: (0.6 + (_star1Animation.value * 0.4)).clamp(
                      0.0,
                      1.0,
                    ),
                    child: const StarWidget(size: 24, color: Color(0xFFFF6B6B)),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _star2Animation,
            builder: (context, child) {
              return Positioned(
                bottom: 120.h,
                right: 40.w,
                child: Transform.scale(
                  scale: 0.9 + (_star2Animation.value * 0.3),
                  child: Opacity(
                    opacity: (0.7 + (_star2Animation.value * 0.3)).clamp(
                      0.0,
                      1.0,
                    ),
                    child: const StarWidget(size: 20, color: Color(0xFFFF6B6B)),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _star3Animation,
            builder: (context, child) {
              return Positioned(
                bottom: 200.h,
                left: 30.w,
                child: Transform.scale(
                  scale: 0.7 + (_star3Animation.value * 0.5),
                  child: Opacity(
                    opacity: (0.5 + (_star3Animation.value * 0.5)).clamp(
                      0.0,
                      1.0,
                    ),
                    child: const StarWidget(size: 16, color: Color(0xFFFF6B6B)),
                  ),
                ),
              );
            },
          ),
          Center(
            child: AnimatedBuilder(
              animation: _logoAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _logoAnimation.value,
                  child: Opacity(
                    opacity: _logoAnimation.value.clamp(0.0, 1.0),
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
          ),
        ],
      ),
    );
  }
}

class StarWidget extends StatelessWidget {
  final double size;
  final Color color;

  const StarWidget({Key? key, required this.size, required this.color})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: StarPainter(color: color),
    );
  }
}

class StarPainter extends CustomPainter {
  final Color color;

  StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2;

    path.moveTo(centerX, centerY - radius);
    path.quadraticBezierTo(
      centerX + radius * 0.3,
      centerY - radius * 0.3,
      centerX + radius,
      centerY,
    );
    path.quadraticBezierTo(
      centerX + radius * 0.3,
      centerY + radius * 0.3,
      centerX,
      centerY + radius,
    );
    path.quadraticBezierTo(
      centerX - radius * 0.3,
      centerY + radius * 0.3,
      centerX - radius,
      centerY,
    );
    path.quadraticBezierTo(
      centerX - radius * 0.3,
      centerY - radius * 0.3,
      centerX,
      centerY - radius,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
