import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/config.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
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
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<MenuProvider>(context, listen: false);
      provider.fetchCities();
      await Future.delayed(const Duration(milliseconds: 500));
      provider.fetchMenus(reset: true);
      setState(() => _isInitialLoad = false);
    });

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
        title: const Text('Yemek Filtrele'),
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
            child: Text(
              'Sıfırla',
              style: AppTheme.theme.textTheme.bodyMedium?.copyWith(
                color: Constants.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: _isInitialLoad
            ? const ShimmerLoading()
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Constants.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // City Filter (Chips with Icons)
                Text(
                  'Şehir Seç',
                  style: AppTheme.theme.textTheme.displaySmall,
                ),
                const SizedBox(height: Constants.space3),
                provider.cities.isEmpty
                    ? Text(
                  'Şehirler yükleniyor...',
                  style: AppTheme.theme.textTheme.bodyMedium,
                )
                    : Wrap(
                  spacing: Constants.space2,
                  runSpacing: Constants.space2,
                  children: provider.cities.map((city) {
                    final isSelected = provider.selectedCityId == city.id;
                    return ChoiceChip(
                      label: Text(city.name),
                      avatar: Icon(
                        Icons.location_city,
                        size: Constants.textSm,
                        color: isSelected ? Constants.gray800 : Constants.gray600,
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        provider.setSelectedCity(selected ? city.id : null);
                        print('Selected cityId: ${selected ? city.id : null}');
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: Constants.space6),
                // Meal Type Filter (Chips with Icons)
                Text(
                  'Öğün Tipi',
                  style: AppTheme.theme.textTheme.displaySmall,
                ),
                const SizedBox(height: Constants.space3),
                Wrap(
                  spacing: Constants.space2,
                  runSpacing: Constants.space2,
                  children: AppConfig.mealTypes.map((mealType) {
                    final isSelected = provider.selectedMealType == mealType;
                    return ChoiceChip(
                      label: Text(mealType),
                      avatar: Icon(
                        mealType == 'Kahvaltı' ? Icons.breakfast_dining : Icons.dinner_dining,
                        size: Constants.textSm,
                        color: isSelected ? Constants.gray800 : Constants.gray600,
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        provider.setSelectedMealType(selected ? mealType : null);
                        print('Selected mealType: ${selected ? mealType : null}');
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: Constants.space6),
                // Date Filter (Button with Calendar Icon)
                Text(
                  'Tarih Seç',
                  style: AppTheme.theme.textTheme.displaySmall,
                ),
                const SizedBox(height: Constants.space3),
                OutlinedButton.icon(
                  onPressed: () async {
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
                  icon: Icon(
                    Icons.calendar_today,
                    size: Constants.textBase,
                    color: Constants.kykBlue600,
                  ),
                  label: Text(
                    _selectedDate == null
                        ? 'Tarih seçin'
                        : AppConfig.displayDateFormat.format(_selectedDate!),
                    style: AppTheme.theme.textTheme.bodyMedium?.copyWith(
                      color: Constants.gray800,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Constants.gray200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: Constants.space4,
                      vertical: Constants.space3,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: Constants.space8),
                // Results Section
                Text(
                  'Filtrelenmiş Menüler',
                  style: AppTheme.theme.textTheme.displayMedium,
                ),
                const SizedBox(height: Constants.space4),
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
                    padding: const EdgeInsets.symmetric(vertical: Constants.space4),
                    child: Text(
                      'Seçilen filtrelerle menü bulunamadı.',
                      style: AppTheme.theme.textTheme.bodyMedium?.copyWith(
                        color: Constants.kykBlue600,
                      ),
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
                          padding: EdgeInsets.all(Constants.space4),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    final menu = provider.menus[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Constants.space4),
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