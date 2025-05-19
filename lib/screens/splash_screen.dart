import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

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
      final provider = Provider.of<MenuProvider>(context, listen: false);
      await provider.fetchMenus(reset: true);
      print('SplashScreen: Menus fetched, navigating to home');
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