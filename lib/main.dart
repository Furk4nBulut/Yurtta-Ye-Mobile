import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/routes/app_routes.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuProvider()),
      ],
      child: MaterialApp.router(
        title: 'YurttaYe Menü',
        theme: AppTheme.theme,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}