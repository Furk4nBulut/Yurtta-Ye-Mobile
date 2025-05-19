import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.goNamed('home');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientDecoration,
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.restaurant_menu,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                Text(
                  'YurttaYe',
                  style: AppTheme.mealTitleStyle.copyWith(fontSize: 36),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}