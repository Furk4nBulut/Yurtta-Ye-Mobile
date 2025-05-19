import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/config.dart';
import 'package:yurttaye_mobile/widgets/error_widget.dart';
import 'package:yurttaye_mobile/widgets/meal_card.dart';
import 'package:yurttaye_mobile/widgets/shimmer_loading.dart';
import 'package:intl/intl.dart';
import 'package:yurttaye_mobile/models/menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedMealType = AppConfig.mealTypes[0]; // Default to 'Kahvaltı'

  @override
  void initState() {
    super.initState();
    // Defer fetchMenus to avoid calling notifyListeners during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MenuProvider>(context, listen: false);
      provider.fetchMenus(reset: true);
      print('Initiating fetchMenus from HomeScreen initState');
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MenuProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('YurttaYe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => context.pushNamed('filter'),
            tooltip: 'Filtrele',
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
            Text(
              'Hiçbir menü bulunamadı',
              style: AppTheme.theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Provider.of<MenuProvider>(context, listen: false).fetchMenus(reset: true);
                print('Retry button pressed in HomeScreen');
              },
              child: const Text('Tekrar Dene'),
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
              _buildTodayMealCard(provider),
              _buildMealTypeToggle(),
              _buildUpcomingMeals(provider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodayMealCard(MenuProvider provider) {
    final today = AppConfig.apiDateFormat.format(DateTime.now());
    final menu = provider.menus.firstWhere(
          (menu) =>
      AppConfig.apiDateFormat.format(menu.date) == today &&
          menu.mealType == _selectedMealType,
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
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Bugünkü menü bulunamadı',
                style: AppTheme.theme.textTheme.bodyLarge,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: MealCard(menu: menu),
    );
  }

  Widget _buildMealTypeToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: AppConfig.mealTypes.map((mealType) {
          return _buildMealTypeButton(mealType);
        }).toList(),
      ),
    );
  }

  Widget _buildMealTypeButton(String mealType) {
    final isSelected = _selectedMealType == mealType;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.deepOrange : Colors.grey[200],
            foregroundColor: isSelected ? Colors.white : Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: isSelected ? 2 : 0,
          ),
          onPressed: () => setState(() => _selectedMealType = mealType),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                mealType == 'Kahvaltı' ? Icons.wb_sunny : Icons.nightlight_round,
                size: 16,
                color: isSelected ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 8),
              Text(mealType),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingMeals(MenuProvider provider) {
    final upcomingMenus = provider.allMenus
        .where((menu) =>
    menu.date.isAfter(DateTime.now()) && menu.mealType == _selectedMealType)
        .take(7) // Show exactly 7 meals
        .toList();

    if (upcomingMenus.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Gelecek $_selectedMealType bulunamadı',
          style: AppTheme.theme.textTheme.bodyLarge,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gelecek Yemekler ($_selectedMealType)',
            style: AppTheme.theme.textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: upcomingMenus.length,
              itemBuilder: (context, index) {
                final menu = upcomingMenus[index];
                return Container(
                  width: 250,
                  margin: const EdgeInsets.only(right: 16),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        DateFormat('dd MMMM').format(menu.date),
                        style: AppTheme.theme.textTheme.bodyLarge,
                      ),
                      subtitle: Text(
                        '${menu.items.length} çeşit (${menu.mealType})',
                        style: AppTheme.theme.textTheme.bodySmall,
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Colors.deepOrange),
                      onTap: () => context.pushNamed(
                        'menu_detail',
                        pathParameters: {'id': menu.id.toString()},
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}