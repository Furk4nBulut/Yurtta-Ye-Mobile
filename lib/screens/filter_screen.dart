import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/config.dart';
import 'package:yurttaye_mobile/widgets/error_widget.dart';
import 'package:yurttaye_mobile/widgets/meal_card.dart';
import 'package:yurttaye_mobile/widgets/shimmer_loading.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> with SingleTickerProviderStateMixin {
  DateTime? _selectedDate;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();

    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MenuProvider>(context, listen: false).fetchMenus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              print('Filters cleared: cityId=${provider.selectedCityId}, mealType=${provider.selectedMealType}, date=${provider.selectedDate}');
            },
            child: const Text('Sıfırla', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // City Filter
                Text(
                  'Şehir',
                  style: AppTheme.theme.textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  value: provider.selectedCityId,
                  hint: const Text('Bir şehir seçin'),
                  isExpanded: true,
                  items: provider.cities.map((city) {
                    return DropdownMenuItem<int>(
                      value: city.id,
                      child: Text(city.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    provider.setSelectedCity(value);
                    print('Selected cityId: $value');
                  },
                ),
                const SizedBox(height: 16),
                // Meal Type Filter
                Text(
                  'Öğün Tipi',
                  style: AppTheme.theme.textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: AppConfig.mealTypes.map((mealType) {
                    return ChoiceChip(
                      label: Text(mealType),
                      selected: provider.selectedMealType == mealType,
                      onSelected: (selected) {
                        provider.setSelectedMealType(selected ? mealType : null);
                        print('Selected mealType: ${selected ? mealType : null}');
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                // Date Filter
                Text(
                  'Tarih',
                  style: AppTheme.theme.textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                      final formattedDate = AppConfig.apiDateFormat.format(picked);
                      provider.setSelectedDate(formattedDate);
                      print('Selected date: $formattedDate');
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      _selectedDate == null
                          ? 'Tarih seçin'
                          : AppConfig.displayDateFormat.format(_selectedDate!),
                      style: AppTheme.theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Results Section
                Text(
                  'Filtrelenmiş Menüler',
                  style: AppTheme.theme.textTheme.displayMedium,
                ),
                const SizedBox(height: 16),
                provider.isLoading
                    ? const ShimmerLoading()
                    : provider.error != null
                    ? AppErrorWidget(
                  error: provider.error!,
                  onRetry: provider.fetchMenus,
                )
                    : provider.menus.isEmpty
                    ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Seçilen filtrelerle menü bulunamadı.',
                      style: AppTheme.theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
                    ),
                  ),
                )
                    : Column(
                  children: provider.menus.map((menu) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: MealCard(
                        menu: menu,
                        isDetailed: false, // Collapsed categories
                        onTap: null, // Disable tap to stay in FilterScreen
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}