import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/widgets/exit_dialog.dart';
import 'package:yurttaye_mobile/widgets/filter_card.dart';
import 'package:yurttaye_mobile/widgets/loading_indicator.dart';
import 'package:yurttaye_mobile/widgets/error_view.dart';
import 'package:yurttaye_mobile/widgets/menu_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    final menuProvider = Provider.of<MenuProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      menuProvider.fetchCities();
      menuProvider.fetchMenus();
      _controller.forward();
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
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldExit = await ExitDialog.show(context);
        if (shouldExit) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('KYK Menü'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                Provider.of<MenuProvider>(context, listen: false).clearFilters();
                _controller.reset();
                _controller.forward();
              },
              tooltip: 'Filtreleri Temizle',
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            final provider = Provider.of<MenuProvider>(context, listen: false);
            await provider.fetchMenus();
            _controller.reset();
            _controller.forward();
          },
          color: Constants.kykBlue600,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(Constants.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menüleri Keşfet',
                    style: TextStyle(
                      fontSize: Constants.text2xl,
                      fontWeight: FontWeight.w700,
                      color: Constants.gray800,
                    ),
                  ),
                  const SizedBox(height: Constants.space4),
                  const FilterCard(),
                  const SizedBox(height: Constants.space4),
                  Consumer<MenuProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return const LoadingIndicator();
                      }
                      if (provider.error != null) {
                        return ErrorView(
                          error: provider.error!,
                          onRetry: () {
                            provider.fetchMenus();
                            _controller.reset();
                            _controller.forward();
                          },
                        );
                      }
                      return MenuList(
                        todayMenu: provider.todayMenu,
                        menus: provider.menus,
                        fadeAnimation: _fadeAnimation,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}