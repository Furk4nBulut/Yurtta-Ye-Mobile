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
final isMorning = menu.mealType.toLowerCase().contains('morning') ||
menu.mealType.toLowerCase().contains('breakfast');

return AnimatedScale(
scale: 1.0,
duration: const Duration(milliseconds: 200),
child: Card(
elevation: 4,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
child: InkWell(
onTap: () => context.go('/menu/${menu.id}'),
borderRadius: BorderRadius.circular(12),
child: Padding(
padding: const EdgeInsets.all(Constants.space4),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Row(
children: [
Icon(
isMorning ? Icons.wb_sunny : Icons.nightlight_round,
color: Constants.kykYellow400,
size: 24,
semanticLabel: isMorning ? 'Sabah menüsü' : 'Akşam menüsü',
),
const SizedBox(width: Constants.space2),
Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'${AppConfig.mealTypes[menu.mealType] ?? menu.mealType}',
style: TextStyle(
fontSize: Constants.textLg,
fontWeight: FontWeight.w600,
color: Constants.gray800,
),
overflow: TextOverflow.ellipsis,
maxLines: 1,
),
const SizedBox(height: Constants.space1),
Text(
AppConfig.displayDateFormat.format(menu.date),
style: TextStyle(
fontSize: Constants.textSm,
color: Constants.gray600,
),
),
],
),
],
),
Icon(
Icons.arrow_forward_ios,
color: Constants.kykBlue600,
size: 20,
),
],
),
),
),
),
);
}
}
