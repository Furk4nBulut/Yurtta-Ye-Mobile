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
      color: Constants.gray50,
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
                    style: TextStyle(
                      fontSize: Constants.textXl,
                      fontWeight: FontWeight.w700,
                      color: Constants.kykBlue600,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Constants.kykBlue600,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: Constants.space2),
              Text(
                AppConfig.displayDateFormat.format(menu.date),
                style: TextStyle(
                  fontSize: Constants.textSm,
                  color: Constants.gray600,
                ),
              ),
              const SizedBox(height: Constants.space3),
              Text(
                'Yemekler',
                style: TextStyle(
                  fontSize: Constants.textBase,
                  fontWeight: FontWeight.w600,
                  color: Constants.gray800,
                ),
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