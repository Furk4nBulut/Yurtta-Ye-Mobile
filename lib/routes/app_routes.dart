import 'package:go_router/go_router.dart';
import 'package:yurttaye_mobile/screens/home_screen.dart';
import 'package:yurttaye_mobile/screens/menu_detail_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/Menu/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return MenuDetailScreen(menuId: id);
      },
    ),
  ],
);