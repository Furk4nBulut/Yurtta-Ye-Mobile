import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/models/city.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class CityDropdown extends StatelessWidget {
  const CityDropdown({super.key});

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
          child: DropdownButton<int>(
            value: provider.selectedCityId,
            hint: Text(
              'Şehir Seç',
              style: TextStyle(
                fontSize: Constants.textBase,
                color: Constants.gray700,
              ),
            ),
            items: [
              DropdownMenuItem<int>(
                value: null,
                child: Text(
                  'Tüm Şehirler',
                  style: TextStyle(fontSize: Constants.textBase),
                ),
              ),
              ...provider.cities.map(
                    (City city) => DropdownMenuItem<int>(
                  value: city.id,
                  child: Text(
                    city.name,
                    style: TextStyle(fontSize: Constants.textBase),
                  ),
                ),
              ),
            ],
            onChanged: provider.isLoading
                ? null
                : (int? newValue) {
              provider.setSelectedCity(newValue);
            },
            isExpanded: true,
            underline: const SizedBox(),
            icon: Icon(
              Icons.arrow_drop_down,
              color: Constants.gray700,
            ),
          ),
        );
      },
    );
  }
}