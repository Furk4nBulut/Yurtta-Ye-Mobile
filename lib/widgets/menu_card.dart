import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/utils/config.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class MenuCard extends StatelessWidget {
  final Menu menu;

  const MenuCard({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => context.go('/menu/${menu.id}'),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(Constants.space4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppConfig.mealTypes[menu.mealType] ?? menu.mealType}',
                    style: TextStyle(
                      fontSize: Constants.textLg,
                      fontWeight: FontWeight.w600,
                      color: Constants.gray900,
                    ),
                  ),
                  const SizedBox(height: Constants.space1),
                  Text(
                    AppConfig.displayDateFormat.format(menu.date),
                    style: TextStyle(
                      fontSize: Constants.textSm,
                      color: Constants.gray700,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Constants.blue500,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}