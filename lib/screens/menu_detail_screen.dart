import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/widgets/meal_card.dart';
import 'package:intl/intl.dart';

class MenuDetailScreen extends StatelessWidget {
  final int menuId;

  const MenuDetailScreen({Key? key, required this.menuId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MenuProvider>(context);
    final menu = provider.allMenus.firstWhere(
          (menu) => menu.id == menuId,
      orElse: () => provider.menus.firstWhere(
            (menu) => menu.id == menuId,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(menu?.mealType ?? 'Menü Detay'),
      ),
      body: menu == null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: Constants.text2xl * 2,
              color: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(height: Constants.space4),
            Text(
              'Menü bulunamadı',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(Constants.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MealCard(
              menu: menu,
              isDetailed: true,
            ),
            const SizedBox(height: Constants.space4),
            Text(
              'Tarih: ${DateFormat('dd MMMM yyyy').format(menu.date)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: Constants.space2),
            Text(
              'Kalori: ${menu.energy.isEmpty ? 'Bilgi yok' : menu.energy}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}