import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/widgets/menu_item_card.dart';

class MenuScreen extends StatelessWidget {
  final int menuId;

  const MenuScreen({super.key, required this.menuId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menü Detayları'),
        backgroundColor: Constants.amber400,
      ),
      body: Consumer<MenuProvider>(
        builder: (context, provider, child) {
          final menu = provider.menus.firstWhere((m) => m.id == menuId, orElse: () => Menu(id: 0, cityId: 0, mealType: '', date: DateTime.now(), energy: '', items: []));
          if (menu.id == 0) {
            return const Center(child: Text('Menü bulunamadı.'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${menu.mealType} - ${menu.date.toString().substring(0, 10)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text('Enerji: ${menu.energy}'),
                const SizedBox(height: 16),
                const Text('Yemekler', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView(
                    children: menu.items.map((item) => MenuItemCard(item: item)).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}