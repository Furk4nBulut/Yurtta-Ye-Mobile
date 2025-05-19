import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/utils/config.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/widgets/menu_item_card.dart';

class TodayMenuCard extends StatelessWidget {
  final Menu menu;

  const TodayMenuCard({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => context.go('/menu/${menu.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(Constants.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Günün Menüsü: ${AppConfig.mealTypes[menu.mealType] ?? menu.mealType}',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                    semanticLabel: 'Menü Detayları',
                  ),
                ],
              ),
              const SizedBox(height: Constants.space2),
              Text(
                AppConfig.displayDateFormat.format(menu.date),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: Constants.space3),
              Text(
                'Yemekler',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: Constants.space2),
              ...menu.items.map((item) => MenuItemCard(item: item)).toList(),
            ],
          ),
        ),
      ),
    );
  }
}