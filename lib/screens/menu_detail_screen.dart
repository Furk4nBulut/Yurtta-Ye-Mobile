import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/config.dart';
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
        body: const Center(child: Text('Menü bulunamadı')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Yemek Detayı')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDateHeader(menu),
            _buildMealTypeToggle(),
            _buildMealItems(menu),
            _buildNutritionInfo(menu),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader(Menu menu) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.gradientDecoration,
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: Colors.white),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd MMMM yyyy').format(menu.date),
                style: AppTheme.mealTitleStyle,
              ),
              Text(
                '${menu.items.length} çeşit yemek (${menu.mealType})',
                style: AppTheme.mealSubtitleStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMealTypeToggle() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: AppConfig.mealTypes.map((mealType) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _buildMealTypeChip(mealType),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMealTypeChip(String mealType) {
    final isSelected = _selectedMealType == mealType;
    return ChoiceChip(
      label: Text(mealType),
      selected: isSelected,
      selectedColor: Colors.deepOrange,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      onSelected: (selected) => setState(() => _selectedMealType = mealType),
    );
  }

  Widget _buildMealItems(Menu menu) {
    final items = menu.items; // Show all items
    print('Items for ${menu.mealType} in MenuDetail: $items');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Yemekler',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (items.isEmpty)
                const Text('Bu öğün için yemek bulunamadı')
              else
                ...items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${item.name} (${item.category})',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Chip(
                        label: Text(item.gram.isEmpty ? '-' : item.gram),
                        backgroundColor: Colors.deepOrange.withOpacity(0.2),
                      ),
                    ],
                  ),
                )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionInfo(Menu menu) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Besin Değerleri',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(menu.energy.isEmpty ? 'Bilgi yok' : menu.energy),
            ],
          ),
        ),
      ),
    );
  }
}