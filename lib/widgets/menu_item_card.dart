import 'package:flutter/material.dart';
import 'package:yurttaye_mobile/models/menu_item.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItem item;

  const MenuItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ListTile(
        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text('${item.category} - ${item.gram}'),
        leading: Icon(Icons.food_bank, color: Constants.accentColor),
      ),
    );
  }
}