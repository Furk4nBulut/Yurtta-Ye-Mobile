import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';

class MealTypeSelector extends StatelessWidget {
  const MealTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (context, provider, child) {
        return DropdownButton<String>(
          hint: const Text('Öğün Seç'),
          value: provider.selectedMealType,
          items: const [
            DropdownMenuItem(value: null, child: Text('Tüm Öğünler')),
            DropdownMenuItem(value: 'Breakfast', child: Text('Sabah')),
            DropdownMenuItem(value: 'Dinner', child: Text('Akşam')),
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