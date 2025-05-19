import 'package:flutter/material.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/widgets/city_dropdown.dart';
import 'package:yurttaye_mobile/widgets/date_picker.dart';
import 'package:yurttaye_mobile/widgets/meal_type_selector.dart';

class FilterCard extends StatelessWidget {
  const FilterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 300),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Constants.space4),
          child: Column(
            children: [
              const CityDropdown(),
              const SizedBox(height: Constants.space3),
              const MealTypeSelector(),
              const SizedBox(height: Constants.space3),
              const DatePicker(),
            ],
          ),
        ),
      ),
    );
  }
}