import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/models/city.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';

class CityDropdown extends StatelessWidget {
  const CityDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (context, provider, child) {
        return DropdownButton<int>(
          hint: const Text('Şehir Seç'),
          value: provider.selectedCityId,
          items: [
            const DropdownMenuItem<int>(
              value: null,
              child: Text('Tüm Şehirler'),
            ),
            ...provider.cities.map((City city) => DropdownMenuItem<int>(
              value: city.id,
              child: Text(city.name),
            )),
          ],
          onChanged: (int? newValue) {
            provider.setSelectedCity(newValue);
          },
          isExpanded: true,
        );
      },
    );
  }
}