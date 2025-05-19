import 'package:flutter/material.dart';
import 'package:yurttaye_mobile/models/menu_item.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

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

  // Map categories to icons
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'ana yemek':
        return Icons.restaurant;
      case 'çorba':
        return Icons.soup_kitchen;
      case 'tatlı':
        return Icons.cake;
      case 'içecek':
        return Icons.local_drink;
      default:
        return Icons.food_bank;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Constants.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getCategoryIcon(category),
                size: Constants.textBase,
                color: Constants.kykBlue600,
              ),
              const SizedBox(width: Constants.space2),
              Text(
                category,
                style: AppTheme.categoryTitleStyle,
              ),
            ],
          ),
          const SizedBox(height: Constants.space2),
          if (isExpanded)
            ...items.map(
                  (item) => Padding(
                padding: const EdgeInsets.only(left: Constants.space4, bottom: Constants.space1),
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: Constants.textXs,
                      color: Constants.gray600,
                    ),
                    const SizedBox(width: Constants.space2),
                    Expanded(
                      child: Text(
                        '${item.name} (${item.gram})',
                        style: AppTheme.theme.textTheme.bodyMedium?.copyWith(
                          color: Constants.gray800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Text(
              items.map((item) => item.name).join(', '),
              style: AppTheme.theme.textTheme.bodySmall?.copyWith(
                color: Constants.gray600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}