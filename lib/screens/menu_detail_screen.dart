import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
                  color: Constants.gray600,
                ),
              ),
            );
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Constants.kykBlue600,
                foregroundColor: Constants.white,
                pinned: true,
                expandedHeight: 180,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.go('/home'),
                  tooltip: 'Ana Sayfaya Dön',
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    AppConfig.mealTypes[menu.mealType] ?? menu.mealType,
                    style: TextStyle(
                      fontSize: Constants.textXl,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  background: Container(
                    color: Constants.kykBlue600,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: Constants.space8),
                          Text(
                            AppConfig.displayDateFormat.format(menu.date),
                            style: TextStyle(
                              fontSize: Constants.textLg,
                              color: Constants.gray100,
                            ),
                          ),
                          const SizedBox(height: Constants.space2),
                          Text(
                            'Enerji: ${menu.energy}',
                            style: TextStyle(
                              fontSize: Constants.textBase,
                              color: Constants.gray100,
                            ),
                          ),
                        ],
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
                        'Yemekler',
                        style: TextStyle(
                          fontSize: Constants.textXl,
                          fontWeight: FontWeight.w600,
                          color: Constants.gray800,
                        ),
                      ),
                      const SizedBox(height: Constants.space2),
                      ...menu.items.map((item) => MenuItemCard(item: item)),
                      const SizedBox(height: Constants.space4),
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