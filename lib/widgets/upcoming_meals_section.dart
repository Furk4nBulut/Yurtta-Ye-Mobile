import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/widgets/upcoming_meal_card.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yurttaye_mobile/utils/localization.dart';
import 'package:yurttaye_mobile/providers/language_provider.dart';

class UpcomingMealsSection extends StatelessWidget {
  final DateTime selectedDate;
  final double opacity;

  const UpcomingMealsSection({
    Key? key,
    required this.selectedDate,
    required this.opacity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final languageCode = languageProvider.currentLanguageCode;
    
    return Consumer<MenuProvider>(
      builder: (context, menuProvider, child) {
        final upcomingMeals = menuProvider.getUpcomingMeals(selectedDate);
        
        if (upcomingMeals.isEmpty) {
          return const SizedBox.shrink();
        }

        return Opacity(
          opacity: opacity,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.only(top: 12, bottom: 20),
            decoration: BoxDecoration(
              color: isDark ? Constants.kykGray800 : Constants.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Constants.black : Constants.black).withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Localization.getText('upcoming_meals_section', languageCode),
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Constants.white : Constants.kykGray800,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Tümünü gör aksiyonu
                        },
                        child: Text(
                          Localization.getText('view_all', languageCode),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Constants.kykPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: upcomingMeals.length,
                    itemBuilder: (context, index) {
                      final meal = upcomingMeals[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: SizedBox(
                          width: 260,
                          child: UpcomingMealCard(
                            menu: meal,
                            onTap: () {
                              // Handle upcoming meal tap
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 