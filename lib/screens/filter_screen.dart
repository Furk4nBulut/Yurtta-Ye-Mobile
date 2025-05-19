import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/utils/config.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MenuProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtrele'),
        actions: [
          TextButton(
            onPressed: () {
              provider.clearFilters();
              setState(() => _selectedDate = null);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filtreler sıfırlandı')),
              );
            },
            child: const Text('Sıfırla', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Şehir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<int>(
              isExpanded: true,
              value: provider.selectedCityId,
              hint: const Text('Bir şehir seçin'),
              items: provider.cities.map((city) {
                return DropdownMenuItem<int>(
                  value: city.id,
                  child: Text(city.name),
                );
              }).toList(),
              onChanged: (value) => provider.setSelectedCity(value),
            ),
            const SizedBox(height: 16),
            const Text('Öğün Tipi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: AppConfig.mealTypes.map((mealType) {
                return ChoiceChip(
                  label: Text(mealType),
                  selected: provider.selectedMealType == mealType,
                  onSelected: (selected) =>
                      provider.setSelectedMealType(selected ? mealType : null),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Tarih', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'Tarih seçin'
                        : AppConfig.displayDateFormat.format(_selectedDate!),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                      provider.setSelectedDate(AppConfig.apiDateFormat.format(picked));
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}