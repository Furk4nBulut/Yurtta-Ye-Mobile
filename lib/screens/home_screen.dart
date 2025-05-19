import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/providers/theme_provider.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/config.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/widgets/error_widget.dart';
import 'package:yurttaye_mobile/widgets/meal_card.dart';
import 'package:yurttaye_mobile/widgets/shimmer_loading.dart';
import 'package:intl/intl.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/widgets/upcomig_meal_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedMealIndex = 0; // 0: Kahvaltı, 1: Akşam Yemeği

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MenuProvider>(context, listen: false);
      provider.fetchMenus(reset: true);
      print('Initiating fetchMenus from HomeScreen initState');
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MenuProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final selectedMealType = AppConfig.mealTypes[_selectedMealIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('YurttaYe'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.brightness_7 : Icons.brightness_4,
              color: Constants.white,
            ),
            tooltip: themeProvider.isDarkMode ? 'Açık Tema' : 'Koyu Tema',
            onPressed: () {
              themeProvider.toggleTheme();
              print('Theme toggled: ${themeProvider.isDarkMode ? 'Dark' : 'Light'}');
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filtrele',
            onPressed: () => context.pushNamed('filter'),
          ),
        ],
      ),
      body: provider.isLoading && provider.menus.isEmpty && provider.allMenus.isEmpty
          ? const ShimmerLoading()
          : provider.error != null
          ? AppErrorWidget(
        error: provider.error!,
        onRetry: () {
          provider.fetchMenus(reset: true);
          print('Retrying fetchMenus from HomeScreen error widget');
        },
      )
          : provider.menus.isEmpty && provider.allMenus.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: Constants.text2xl * 2,
              color: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(height: Constants.space4),
            Text(
              'Hiçbir menü bulunamadı',
              style: Theme.of(context).textTheme.displayMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: Constants.space3),
            OutlinedButton.icon(
              onPressed: () {
                Provider.of<MenuProvider>(context, listen: false).fetchMenus(reset: true);
                print('Retry button pressed in HomeScreen');
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Tekrar Dene'),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: () async {
          await provider.fetchMenus(reset: true);
          print('RefreshIndicator triggered in HomeScreen');
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTodayMealCard(provider, selectedMealType),
              _buildUpcomingMeals(provider, selectedMealType, screenWidth),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedMealIndex,
        onTap: (index) {
          setState(() => _selectedMealIndex = index);
          print('Selected meal type: ${AppConfig.mealTypes[index]}');
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.breakfast_dining),
            label: 'Kahvaltı',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dinner_dining),
            label: 'Akşam Yemeği',
          ),
        ],
      ),
    );
  }

  Widget _buildTodayMealCard(MenuProvider provider, String selectedMealType) {
    final today = AppConfig.apiDateFormat.format(DateTime.now());
    final menu = provider.menus.firstWhere(
          (menu) => AppConfig.apiDateFormat.format(menu.date) == today && menu.mealType == selectedMealType,
      orElse: () => provider.menus.firstWhere(
            (menu) => AppConfig.apiDateFormat.format(menu.date) == today,
        orElse: () => provider.menus.isNotEmpty
            ? provider.menus.first
            : Menu(
          id: 0,
          cityId: 0,
          mealType: '',
          date: DateTime.now(),
          energy: '',
          items: [],
        ),
      ),
    );

    if (menu.id == 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Constants.space4,
          vertical: Constants.space2,
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(Constants.space3),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: Constants.textBase,
                  color: Theme.of(context).iconTheme.color,
                ),
                const SizedBox(width: Constants.space2),
                Expanded(
                  child: Text(
                    'Bugünkü menü bulunamadı',
                    style: Theme.of(context).textTheme.bodyLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.space4,
        vertical: Constants.space2,
      ),
      child: MealCard(menu: menu),
    );
  }

  Widget _buildUpcomingMeals(MenuProvider provider, String selectedMealType, double screenWidth) {
    final upcomingMenus = provider.allMenus
        .where((menu) => menu.date.isAfter(DateTime.now()) && menu.mealType == selectedMealType)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date))
      ..take(7);

    if (upcomingMenus.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Constants.space4,
          vertical: Constants.space2,
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              size: Constants.textBase,
              color: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(width: Constants.space2),
            Expanded(
              child: Text(
                'Gelecek $selectedMealType bulunamadı',
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    final cardWidth = screenWidth * 0.65; // 65% of screen width, max 280

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.space4,
        vertical: Constants.space2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Gelecek $selectedMealType',
                  style: Theme.of(context).textTheme.displayMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.arrow_forward,
                size: Constants.textBase,
                color: Constants.kykBlue600,
              ),
            ],
          ),
          const SizedBox(height: Constants.space3),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: upcomingMenus.map((menu) {
                return Container(
                  width: cardWidth.clamp(200.0, 280.0), // Responsive width
                  margin: const EdgeInsets.only(right: Constants.space3),
                  child: UpcomingMealCard(
                    menu: menu,
                    onTap: () => context.pushNamed(
                      'menu_detail',
                      pathParameters: {'id': menu.id.toString()},
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}