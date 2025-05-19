import 'package:flutter/material.dart';
import 'package:yurttaye_mobile/models/menu_item.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItem item;

  const MenuItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.space4,
        vertical: Constants.space3,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Constants.gray200),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.food_bank_outlined,
            color: Constants.amber400,
            size: 24,
          ),
          const SizedBox(width: Constants.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: Constants.textBase,
                    fontWeight: FontWeight.w500,
                    color: Constants.gray900,
                  ),
                ),
                Text(
                  '${item.category} - ${item.gram}',
                  style: TextStyle(
                    fontSize: Constants.textSm,
                    color: Constants.gray700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}