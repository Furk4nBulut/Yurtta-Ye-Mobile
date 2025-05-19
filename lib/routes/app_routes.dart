import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yurttaye_mobile/screens/home_screen.dart';
import 'package:yurttaye_mobile/screens/menu_detail_screen.dart';
import 'package:yurttaye_mobile/screens/splash_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'menu/:id',
          pageBuilder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return CustomPage(
              child: MenuDetailScreen(menuId: id),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
      ],
    ),
  ],
);

class CustomPage<T> extends CustomTransitionPage<T> {
  CustomPage({
    required super.child,
    required super.transitionsBuilder,
  }) : super(
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
  );
}