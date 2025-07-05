import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/widgets/upcoming_meal_card.dart';

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
    return Consumer<MenuProvider>(
      builder: (context, menuProvider, child) {
        final upcomingMeals = menuProvider.getUpcomingMeals(selectedDate);
        
        if (upcomingMeals.isEmpty) {
          return const SizedBox.shrink();
        }

        return Opacity(
          opacity: opacity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Yaklaşan Yemekler',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: upcomingMeals.length,
                  itemBuilder: (context, index) {
                    final meal = upcomingMeals[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: UpcomingMealCard(
                        menu: meal,
                        onTap: () {
                          // Handle upcoming meal tap
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 