import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/utils/config.dart';

class MealTypeSelector extends StatelessWidget {
  const MealTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (context, provider, child) {
        return DropdownButton<String>(
          hint: const Text('Öğün Seç'),
          value: provider.selectedMealType,
          items: [
            DropdownMenuItem(value: null, child: Text(AppConfig.allMealTypesLabel)),
            ...AppConfig.mealTypes.entries.map(
                  (entry) => DropdownMenuItem(
                value: entry.key,
                child: Text(entry.value),
              ),
            ),
          ],
          onChanged: (String? newValue) {
            provider.setSelectedMealType(newValue);
          },
          isExpanded: true,
        );
      },
    );
  }
}