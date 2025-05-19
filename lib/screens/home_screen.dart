import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/config.dart';
import 'package:intl/intl.dart';

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
    Provider.of<MenuProvider>(context, listen: false).fetchMenus();
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
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hata: ${provider.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.fetchMenus(),
              child: const Text('Yeniden Dene'),
            ),
          ],
        ),
      )
          : provider.menus.isEmpty
          ? const Center(child: Text('Hiçbir menü bulunamadı'))
          : SingleChildScrollView(
        child: Column(
          children: [
            _buildTodayMealCard(provider),
            _buildMealTypeToggle(),
            _buildUpcomingMeals(provider),
          ],
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
        orElse: () => Menu(
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
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: Text('Bugünkü menü bulunamadı')),
          ),
        ),
      );
    }

    final items = menu.items; // Show all items
    print('Items for ${_selectedMealType}: $items');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.pushNamed('menu_detail', pathParameters: {'id': menu.id.toString()}),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bugünün Yemeği (${menu.mealType})',
                  style: AppTheme.theme.textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('dd MMMM yyyy').format(menu.date),
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                if (items.isEmpty)
                  const Text('Bu öğün için yemek bulunamadı')
                else
                  ...items.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Expanded(child: Text('${item.name} (${item.category})')),
                        Text(item.gram.isEmpty ? '-' : item.gram, style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, size: 16, color: Colors.deepOrange),
                    const SizedBox(width: 4),
                    Text(menu.energy.isEmpty ? 'Bilgi yok' : menu.energy),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealTypeToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            backgroundColor: isSelected ? Colors.deepOrange : Colors.grey[300],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
              Text(
                mealType,
                style: TextStyle(color: isSelected ? Colors.white : Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingMeals(MenuProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gelecek Yemekler',
            style: AppTheme.theme.textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          ...provider.menus.take(5).map((menu) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.deepOrange),
                title: Text(DateFormat('dd MMMM').format(menu.date)),
                subtitle: Text('${menu.items.length} çeşit yemek (${menu.mealType})'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.pushNamed('menu_detail', pathParameters: {'id': menu.id.toString()}),
              ),
            ),
          )),
        ],
      ),
    );
  }
}