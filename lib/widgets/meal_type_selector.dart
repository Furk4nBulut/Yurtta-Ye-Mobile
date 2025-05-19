import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/utils/config.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class MealTypeSelector extends StatelessWidget {
  const MealTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: Constants.space4),
          decoration: BoxDecoration(
            color: Constants.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Constants.gray200),
          ),
          child: DropdownButton<String>(
            value: provider.selectedMealType,
            hint: Text(
              'Öğün Seç',
              style: TextStyle(
                fontSize: Constants.textBase,
                color: Constants.gray600,
              ),
            ),
            items: [
              DropdownMenuItem(
                value: null,
                child: Text(
                  AppConfig.allMealTypesLabel,
                  style: TextStyle(fontSize: Constants.textBase),
                ),
              ),
              ...AppConfig.mealTypes.entries.map(
                    (entry) => DropdownMenuItem(
                  value: entry.key,
                  child: Text(
                    entry.value,
                    style: TextStyle(fontSize: Constants.textBase),
                  ),
                ),
              ),
            ],
            onChanged: provider.isLoading
                ? null
                : (String? newValue) {
              provider.setSelectedMealType(newValue);
            },
            isExpanded: true,
            underline: const SizedBox(),
            icon: Icon(
              Icons.arrow_drop_down,
              color: Constants.gray600,
            ),
            dropdownColor: Constants.white,
          ),
        );
      },
    );
  }
}