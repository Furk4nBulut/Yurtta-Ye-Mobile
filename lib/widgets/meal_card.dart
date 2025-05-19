import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/models/menu_item.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/widgets/category_section.dart';

class MealCard extends StatelessWidget {
  final Menu menu;
  final bool isDetailed;
  final VoidCallback? onTap;

  const MealCard({
    Key? key,
    required this.menu,
    this.isDetailed = false,
    this.onTap,
  }) : super(key: key);

  // Map meal types to icons
  IconData _getMealTypeIcon(String mealType) {
    switch (mealType) {
      case 'Kahvaltı':
        return Icons.breakfast_dining;
      case 'Akşam Yemeği':
        return Icons.dinner_dining;
      default:
        return Icons.restaurant_menu;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Group items by category
    final categories = menu.items.fold<Map<String, List<MenuItem>>>(
      {},
          (map, item) {
        map[item.category] = (map[item.category] ?? [])..add(item);
        return map;
      },
    );

    return Card(
      child: InkWell(
        onTap: onTap ??
                () => context.pushNamed(
              'menu_detail',
              pathParameters: {'id': menu.id.toString()},
            ),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Constants.gray200, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with gradient and icon
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Constants.space4),
                decoration: AppTheme.gradientDecoration,
                child: Row(
                  children: [
                    Icon(
                      _getMealTypeIcon(menu.mealType),
                      color: Constants.white,
                      size: Constants.textXl,
                    ),
                    const SizedBox(width: Constants.space2),
                    Expanded(
                      child: Text(
                        isDetailed
                            ? menu.mealType
                            : 'Bugünün ${menu.mealType}',
                        style: AppTheme.mealTitleStyle,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Constants.space4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('dd MMMM yyyy').format(menu.date),
                      style: AppTheme.theme.textTheme.bodySmall?.copyWith(
                        color: Constants.gray600,
                      ),
                    ),
                    const SizedBox(height: Constants.space3),
                    if (menu.items.isEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: Constants.textBase,
                            color: Constants.gray600,
                          ),
                          const SizedBox(width: Constants.space2),
                          Text(
                            'Bu öğün için yemek bulunamadı',
                            style: AppTheme.theme.textTheme.bodyMedium,
                          ),
                        ],
                      )
                    else
                      ...categories.entries.map(
                            (entry) => CategorySection(
                          category: entry.key,
                          items: entry.value,
                          isExpanded: isDetailed,
                        ),
                      ),
                    const SizedBox(height: Constants.space3),
                    Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          size: Constants.textBase,
                          color: Constants.kykYellow400,
                        ),
                        const SizedBox(width: Constants.space2),
                        Text(
                          menu.energy.isEmpty ? 'Kalori bilgisi yok' : menu.energy,
                          style: AppTheme.theme.textTheme.bodyMedium?.copyWith(
                            color: Constants.gray800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}