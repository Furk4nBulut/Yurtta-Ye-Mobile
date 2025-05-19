import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/config.dart';
import 'package:yurttaye_mobile/widgets/meal_card.dart';
import 'package:intl/intl.dart';

class MenuDetailScreen extends StatefulWidget {
  final int menuId;
  const MenuDetailScreen({Key? key, required this.menuId}) : super(key: key);

  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  String _selectedMealType = AppConfig.mealTypes[0]; // Default to 'Kahvaltı'

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MenuProvider>(context);
    final menu = provider.menus.firstWhere(
          (m) => m.id == widget.menuId,
      orElse: () => Menu(
        id: 0,
        cityId: 0,
        mealType: '',
        date: DateTime.now(),
        energy: '',
        items: [],
      ),
    );

    if (menu.id == 0) {
      return Scaffold(
        appBar: AppBar(title: const Text('Yemek Detayı')),
        body: Center(
          child: Text(
            'Menü bulunamadı',
            style: Theme.of(context).textTheme.bodyLarge, // Use Theme.of(context)
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Yemek Detayı')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(menu),
            _buildMealTypeToggle(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MealCard(menu: menu, isDetailed: true, onTap: null),
            ),
            _buildNutritionInfo(menu),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Menu menu) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.gradientDecoration(context), // Pass context
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('dd MMMM yyyy').format(menu.date),
                  style: AppTheme.mealTitleStyle(context), // Pass context
                ),
                Text(
                  '${menu.items.length} çeşit yemek (${menu.mealType})',
                  style: AppTheme.mealSubtitleStyle(context), // Pass context
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTypeToggle() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 8,
        children: AppConfig.mealTypes.map((mealType) {
          return ChoiceChip(
            label: Text(mealType),
            selected: _selectedMealType == mealType,
            onSelected: (selected) => setState(() => _selectedMealType = mealType),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNutritionInfo(Menu menu) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Besin Değerleri',
                style: Theme.of(context).textTheme.displaySmall, // Use Theme.of(context)
              ),
              const SizedBox(height: 8),
              Text(
                menu.energy.isEmpty ? 'Bilgi yok' : menu.energy,
                style: Theme.of(context).textTheme.bodyLarge, // Use Theme.of(context)
              ),
            ],
          ),
        ),
      ),
    );
  }
}