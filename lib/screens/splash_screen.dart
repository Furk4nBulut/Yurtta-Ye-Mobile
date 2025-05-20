import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Ensure splash screen is shown for at least 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      print('SplashScreen: Navigating to home');
      context.goNamed('home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.kykBlue600,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: Constants.text2xl * 3,
              color: Constants.white,
            ),
            const SizedBox(height: Constants.space4),
            Text(
              'YurttaYe',
              style: AppTheme.mealTitleStyle(context).copyWith(
                fontSize: Constants.text2xl,
              ),
            ),
            const SizedBox(height: Constants.space4),
            CircularProgressIndicator(
              color: Constants.kykYellow400,
            ),
          ],
        ),
      ),
    );
  }
}