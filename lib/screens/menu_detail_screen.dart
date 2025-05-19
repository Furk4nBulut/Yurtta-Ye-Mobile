import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/utils/config.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/widgets/menu_item_card.dart';

class MenuDetailScreen extends StatelessWidget {
  final int menuId;

  const MenuDetailScreen({super.key, required this.menuId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MenuProvider>(
        builder: (context, provider, child) {
          final menu = provider.menus.firstWhere(
                (m) => m.id == menuId,
            orElse: () => Menu(
              id: 0,
              cityId: 0,
              mealType: '',
              date: DateTime.now(),
              energy: '',
              items: [],
            ),
          );
          if (menu.id == 0) {
            return Center(
              child: Text(
                'Menü bulunamadı.',
                style: TextStyle(
                  fontSize: Constants.textBase,
                  color: Constants.gray700,
                ),
              ),
            );
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Constants.blue500,
                foregroundColor: Constants.white,
                pinned: true,
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    AppConfig.mealTypes[menu.mealType] ?? menu.mealType,
                    style: TextStyle(
                      fontSize: Constants.textXl,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  background: Container(
                    color: Constants.blue500,
                    child: Center(
                      child: Text(
                        AppConfig.displayDateFormat.format(menu.date),
                        style: TextStyle(
                          fontSize: Constants.textLg,
                          color: Constants.gray200,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(Constants.space4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enerji: ${menu.energy}',
                        style: TextStyle(
                          fontSize: Constants.textBase,
                          color: Constants.gray700,
                        ),
                      ),
                      const SizedBox(height: Constants.space4),
                      Text(
                        'Yemekler',
                        style: TextStyle(
                          fontSize: Constants.textXl,
                          fontWeight: FontWeight.w600,
                          color: Constants.gray900,
                        ),
                      ),
                      const SizedBox(height: Constants.space2),
                      ...menu.items.map((item) => MenuItemCard(item: item)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}