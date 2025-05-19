import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/models/menu_item.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
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
        onTap: onTap ?? () => context.pushNamed('menu_detail', pathParameters: {'id': menu.id.toString()}),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    menu.mealType == 'Kahvaltı' ? Icons.wb_sunny : Icons.nightlight_round,
                    color: Colors.deepOrange,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isDetailed ? menu.mealType : 'Bugünün Yemeği (${menu.mealType})',
                      style: AppTheme.theme.textTheme.displaySmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('dd MMMM yyyy').format(menu.date),
                style: AppTheme.theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              if (menu.items.isEmpty)
                Text(
                  'Bu öğün için yemek bulunamadı',
                  style: AppTheme.theme.textTheme.bodyMedium,
                )
              else
                ...categories.entries.map((entry) => CategorySection(
                  category: entry.key,
                  items: entry.value,
                  isExpanded: isDetailed,
                )),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.local_fire_department, size: 16, color: Colors.deepOrange),
                  const SizedBox(width: 4),
                  Text(
                    menu.energy.isEmpty ? 'Bilgi yok' : menu.energy,
                    style: AppTheme.theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}