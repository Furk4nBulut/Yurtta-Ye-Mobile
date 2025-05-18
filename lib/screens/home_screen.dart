import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/widgets/city_dropdown.dart';
import 'package:yurttaye_mobile/widgets/date_picker.dart';
import 'package:yurttaye_mobile/widgets/meal_type_selector.dart';
import 'package:yurttaye_mobile/widgets/menu_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      menuProvider.fetchCities();
      menuProvider.fetchMenus();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('YurttaYe Menü'),
        backgroundColor: Constants.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => menuProvider.clearFilters(),
            tooltip: 'Filtreleri Temizle',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Menü Sorgula',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const CityDropdown(),
            const SizedBox(height: 8),
            const MealTypeSelector(),
            const SizedBox(height: 8),
            const DatePicker(),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<MenuProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (provider.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Hata: ${provider.error}'),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => provider.fetchMenus(),
                            child: const Text('Tekrar Dene'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (provider.menus.isEmpty) {
                    return const Center(child: Text('Menü bulunamadı.'));
                  }
                  return ListView.builder(
                    itemCount: provider.menus.length,
                    itemBuilder: (context, index) {
                      return MenuCard(menu: provider.menus[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}