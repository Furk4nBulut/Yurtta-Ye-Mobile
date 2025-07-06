import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yurttaye_mobile/screens/filter_screen.dart';
import 'package:yurttaye_mobile/screens/home_screen.dart';
import 'package:yurttaye_mobile/screens/menu_detail_screen.dart';
import 'package:yurttaye_mobile/screens/settings_screen.dart';
import 'package:yurttaye_mobile/screens/splash_screen.dart';
import 'package:yurttaye_mobile/utils/localization.dart';
import 'package:yurttaye_mobile/widgets/ad_wrapper.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'menu/:id',
          name: 'menu_detail',
          pageBuilder: (context, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
            return CustomTransitionPage(
              key: state.pageKey,
              child: AdWrapper(
                routeName: 'menu_detail',
                showAdOnEnter: true,
                child: MenuDetailScreen(menuId: id),
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 300),
              reverseTransitionDuration: const Duration(milliseconds: 300),
            );
          },
        ),
        GoRoute(
          path: 'filter',
          name: 'filter',
          builder: (context, state) => AdWrapper(
            routeName: 'filter',
            showAdOnEnter: true,
            child: const FilterScreen(),
          ),
        ),
        GoRoute(
          path: 'settings',
          name: 'settings',
          builder: (context, state) => AdWrapper(
            routeName: 'settings',
            showAdOnEnter: true,
            child: const SettingsScreen(),
          ),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return Scaffold(
      body: Center(child: Text('${Localization.getText('page_not_found', languageCode)}: ${state.error}')),
    );
  },
);