import 'package:flutter/material.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/widgets/menu_card.dart';
import 'package:yurttaye_mobile/widgets/today_menu_card.dart';

class MenuList extends StatelessWidget {
  final Menu? todayMenu;
  final List<Menu> menus;
  final Animation<double> fadeAnimation;

  const MenuList({
    super.key,
    required this.todayMenu,
    required this.menus,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (todayMenu != null) ...[
          TodayMenuCard(menu: todayMenu!),
          const SizedBox(height: Constants.space4),
        ] else ...[
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(Constants.space4),
              child: Text(
                'Bugün için menü bulunamadı.',
                style: TextStyle(
                  fontSize: Constants.textBase,
                  color: Constants.gray600,
                ),
              ),
            ),
          ),
          const SizedBox(height: Constants.space4),
        ],
        if (menus.isNotEmpty)
          Text(
            'Diğer Menüler',
            style: TextStyle(
              fontSize: Constants.textXl,
              fontWeight: FontWeight.w600,
              color: Constants.gray800,
            ),
          ),
        const SizedBox(height: Constants.space2),
        FadeTransition(
          opacity: fadeAnimation,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: menus.length,
            itemBuilder: (context, index) {
              final menu = menus[index];
              if (todayMenu != null && menu.id == todayMenu!.id) {
                return const SizedBox.shrink();
              }
              return MenuCard(menu: menu);
            },
          ),
        ),
      ],
    );
  }
}