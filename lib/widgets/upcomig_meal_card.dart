import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/models/menu_item.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class UpcomingMealCard extends StatelessWidget {
  final Menu menu;
  final VoidCallback? onTap;

  const UpcomingMealCard({
    Key? key,
    required this.menu,
    this.onTap,
  }) : super(key: key);

  // Returns icon based on meal type
  IconData _getMealTypeIcon(String mealType) {
    switch (mealType) {
      case 'Kahvaltı':
        return Icons.breakfast_dining;
      case 'Akşam Yemeği':
        return Icons.dinner_dining;
      default:
        return Icons.restaurant_menu;
    }
  }

  // Returns icon based on category
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'ana yemek':
        return Icons.restaurant;
      case 'çorba':
        return Icons.soup_kitchen;
      case 'tatlı':
        return Icons.cake;
      case 'içecek':
        return Icons.local_drink;
      default:
        return Icons.food_bank;
    }
  }

  // Shortens meal type for header
  String _getShortMealType(String mealType) {
    switch (mealType) {
      case 'Kahvaltı':
        return 'Sabah';
      case 'Akşam Yemeği':
        return 'Akşam';
      default:
        return mealType;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // Group menu items by category
    final categories = menu.items.fold<Map<String, List<MenuItem>>>(
      {},
          (map, item) {
        map[item.category] = (map[item.category] ?? [])..add(item);
        return map;
      },
    );

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 10, // Strong floating effect
        color: isDarkMode ? Constants.gray600 : Constants.gray100, // Distinct background
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with meal type and date
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Constants.space2),
              decoration: AppTheme.gradientDecoration(context), // Square corners
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meal type and icon
                  Row(
                    children: [
                      Icon(
                        _getMealTypeIcon(menu.mealType),
                        color: Constants.white,
                        size: Constants.textSm,
                      ),
                      const SizedBox(width: Constants.space1),
                      Expanded(
                        child: Text(
                          _getShortMealType(menu.mealType),
                          style: GoogleFonts.poppins(
                            fontSize: Constants.textLg,
                            fontWeight: FontWeight.w600,
                            color: Constants.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Constants.space1),
                  // Date
                  Text(
                    DateFormat('dd MMM yyyy').format(menu.date),
                    style: GoogleFonts.poppins(
                      fontSize: Constants.textBase,
                      fontWeight: FontWeight.w500,
                      color: Constants.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Yellow accent divider
            Container(
              height: 2,
              color: Constants.kykYellow400,
            ),
            // Body with categories and details
            Padding(
              padding: const EdgeInsets.all(Constants.space2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (menu.items.isEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: Constants.textSm,
                          color: Constants.gray600,
                        ),
                        const SizedBox(width: Constants.space1),
                        Expanded(
                          child: Text(
                            'Bu öğün için yemek bulunamadı',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Constants.gray600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  else ...[
                    // Categories
                    ...categories.entries.map(
                          (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: Constants.space2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _getCategoryIcon(entry.key),
                                  size: Constants.textSm,
                                  color: Constants.kykBlue600,
                                ),
                                const SizedBox(width: Constants.space1),
                                Expanded(
                                  child: Text(
                                    '${entry.key} (${entry.value.length})',
                                    style: AppTheme.categoryTitleStyle(context),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: Constants.space1),
                            Text(
                              entry.value.map((item) => item.name).join(', '),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Constants.gray600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (entry != categories.entries.last)
                              Padding(
                                padding: const EdgeInsets.only(top: Constants.space1),
                                child: Divider(
                                  color: Constants.gray200.withOpacity(0.5),
                                  height: 1,
                                  thickness: 1,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    // Calorie info
                    if (menu.energy.isNotEmpty) ...[
                      const SizedBox(height: Constants.space2),
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            size: Constants.textSm,
                            color: Constants.kykYellow400,
                          ),
                          const SizedBox(width: Constants.space1),
                          Expanded(
                            child: Text(
                              menu.energy,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: isDarkMode ? Constants.white : Constants.gray800,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}