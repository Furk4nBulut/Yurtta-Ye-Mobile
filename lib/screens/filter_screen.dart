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
  final ScrollController _scrollController = ScrollController();
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();

    // Delay initial fetch to prioritize UI
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<MenuProvider>(context, listen: false);
      provider.fetchCities();
      await Future.delayed(const Duration(milliseconds: 10));
      provider.fetchMenus(reset: true);
      setState(() => _isInitialLoad = false);
    });

    // Infinite scrolling
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
          !Provider.of<MenuProvider>(context, listen: false).isLoading &&
          Provider.of<MenuProvider>(context, listen: false).hasMore) {
        Provider.of<MenuProvider>(context, listen: false).fetchMenus();
        print('Fetching next page of menus');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
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
        child: _isInitialLoad
            ? const ShimmerLoading()
            : SingleChildScrollView(
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
                provider.isLoading && provider.menus.isEmpty
                    ? const ShimmerLoading()
                    : provider.error != null
                    ? AppErrorWidget(
                  error: provider.error!,
                  onRetry: () => provider.fetchMenus(reset: true),
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
                    : ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.menus.length + (provider.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == provider.menus.length && provider.hasMore) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    final menu = provider.menus[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: MealCard(
                        menu: menu,
                        isDetailed: false,
                        onTap: null,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}