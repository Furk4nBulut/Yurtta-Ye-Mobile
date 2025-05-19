import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/home');
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
    return PopScope(
      canPop: false, // Disables system back navigation
      child: Scaffold(
        backgroundColor: Constants.kykBlue600,
        body: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 120,
                  height: 120,
                  semanticLabel: 'YurttaYe Logosu',
                ),
                const SizedBox(height: Constants.space4),
                Text(
                  'YurttaYe',
                  style: TextStyle(
                    fontSize: Constants.text2xl,
                    fontWeight: FontWeight.w700,
                    color: Constants.white,
                  ),
                ),
                const SizedBox(height: Constants.space2),
                Text(
                  'KYK Yurt Menüleri',
                  style: TextStyle(
                    fontSize: Constants.textBase,
                    color: Constants.gray100,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}