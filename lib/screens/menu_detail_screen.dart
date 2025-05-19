import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/providers/theme_provider.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/config.dart';
import 'package:intl/intl.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/widgets/meal_card.dart';

class MenuDetailScreen extends StatefulWidget {
  final int menuId;
  const MenuDetailScreen({Key? key, required this.menuId}) : super(key: key);

  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  String _selectedMealType = AppConfig.mealTypes[0]; // Default to 'Kahvaltı'

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MenuProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final menu = provider.menus.firstWhere(
          (m) => m.id == widget.menuId,
      orElse: () => Menu(
        id: 0,
        cityId: 0,
        mealType: '',
        date: DateTime.now(),
        energy: '',
        items: [],
      ),
    );

    if (menu.id == 0) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('YurttaYe'),
          actions: [
            IconButton(
              icon: Icon(
                themeProvider.isDarkMode ? Icons.brightness_7 : Icons.brightness_4,
                color: Constants.white,
              ),
              tooltip: themeProvider.isDarkMode ? 'Açık Tema' : 'Koyu Tema',
              onPressed: () {
                themeProvider.toggleTheme();
                print('Theme toggled: ${themeProvider.isDarkMode ? 'Dark' : 'Light'}');
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.filter_list,
                color: Constants.white,
              ),
              tooltip: 'Filtrele',
              onPressed: () => context.pushNamed('filter'),
            ),
          ],
        ),
        body: Center(
          child: Text(
            'Menü bulunamadı',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    // Find menu for the selected meal type and same date
    final selectedDate = AppConfig.apiDateFormat.format(menu.date);
    final filteredMenu = provider.menus.firstWhere(
          (m) =>
      m.mealType == _selectedMealType &&
          AppConfig.apiDateFormat.format(m.date) == selectedDate,
      orElse: () => Menu(
        id: 0,
        cityId: 0,
        mealType: _selectedMealType,
        date: menu.date,
        energy: '',
        items: [],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('YurttaYe'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.brightness_7 : Icons.brightness_4,
              color: Constants.white,
            ),
            tooltip: themeProvider.isDarkMode ? 'Açık Tema' : 'Koyu Tema',
            onPressed: () {
              themeProvider.toggleTheme();
              print('Theme toggled: ${themeProvider.isDarkMode ? 'Dark' : 'Light'}');
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.filter_list,
              color: Constants.white,
            ),
            tooltip: 'Filtrele',
            onPressed: () => context.pushNamed('filter'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(filteredMenu.id != 0 ? filteredMenu : menu),
            _buildMealTypeToggle(),
            filteredMenu.id != 0
                ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: AbsorbPointer(
                child: MealCard(menu: filteredMenu, isDetailed: true, onTap: null),
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Seçilen öğün türü için menü bulunamadı',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            _buildNutritionInfo(filteredMenu.id != 0 ? filteredMenu : menu),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Menu menu) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.gradientDecoration(context),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('dd MMMM yyyy').format(menu.date),
                  style: AppTheme.mealTitleStyle(context),
                ),
                Text(
                  '${menu.items.length} çeşit yemek (${menu.mealType})',
                  style: AppTheme.mealSubtitleStyle(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTypeToggle() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 8,
        children: AppConfig.mealTypes.map((mealType) {
          return ChoiceChip(
            label: Text(mealType),
            selected: _selectedMealType == mealType,
            onSelected: (selected) => setState(() => _selectedMealType = mealType),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNutritionInfo(Menu menu) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.space4,
        vertical: Constants.space2,
      ),
      child: Semantics(
        label: 'Besin değerleri, ${menu.energy.isEmpty ? "bilgi yok" : menu.energy}',
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: Constants.gray600.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(Constants.space3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(Constants.space1),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Constants.kykYellow400, Constants.kykBlue600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.local_fire_department,
                        color: Constants.white,
                        size: Constants.textSm,
                      ),
                    ),
                    const SizedBox(width: Constants.space2),
                    Text(
                      'Besin Değerleri',
                      style: GoogleFonts.poppins(
                        fontSize: Constants.textBase,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Constants.white : Constants.gray800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Constants.space2),
                Center(
                  child: Tooltip(
                    message: 'Toplam kalori bilgisi',
                    child: Text(
                      menu.energy.isEmpty ? 'Bilgi yok' : menu.energy,
                      style: GoogleFonts.poppins(
                        fontSize: Constants.textBase,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Constants.white : Constants.gray800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}