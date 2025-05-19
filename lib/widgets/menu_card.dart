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
      elevation: 2,
      child: ListTile(
        title: Text(
          '${AppConfig.mealTypes[menu.mealType] ?? menu.mealType} - ${AppConfig.displayDateFormat.format(menu.date)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Enerji: ${menu.energy}'),
        trailing: Icon(Icons.arrow_forward, color: Constants.primaryColor),
        onTap: () => context.go('/menu/${menu.id}'),
      ),
    );
  }
}