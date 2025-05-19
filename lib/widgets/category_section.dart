import 'package:flutter/material.dart';
import 'package:yurttaye_mobile/models/menu_item.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';

class CategorySection extends StatelessWidget {
  final String category;
  final List<MenuItem> items;
  final bool isExpanded;

  const CategorySection({
    Key? key,
    required this.category,
    required this.items,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        category,
        style: AppTheme.theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      initiallyExpanded: isExpanded,
      children: items.map((item) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item.name,
                style: AppTheme.theme.textTheme.bodyMedium,
              ),
            ),
            Chip(
              label: Text(item.gram.isEmpty ? '-' : item.gram),
              backgroundColor: Colors.deepOrange.withOpacity(0.2),
              labelStyle: AppTheme.theme.textTheme.bodySmall,
            ),
          ],
        ),
      )).toList(),
    );
  }
}