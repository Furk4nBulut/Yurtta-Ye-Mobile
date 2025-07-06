import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/models/menu_item.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/providers/theme_provider.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/config.dart';
import 'package:intl/intl.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuDetailScreen extends StatefulWidget {
  final int menuId;
  const MenuDetailScreen({Key? key, required this.menuId}) : super(key: key);

  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  String _selectedMealType = AppConfig.mealTypes[0];

  /// Yemek türü sabitini al
  String _getMealTypeConstant(String mealType) {
    switch (mealType) {
      case 'Kahvaltı':
        return Constants.breakfastType;
      case 'Öğle Yemeği':
        return Constants.lunchType;
      case 'Akşam Yemeği':
        return Constants.dinnerType;
      default:
        return Constants.lunchType;
    }
  }

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
        appBar: _buildAppBar(themeProvider, _getMealTypeConstant(menu.mealType)),
        body: _buildEmptyState(),
      );
    }

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

    final mealTypeConstant = _getMealTypeConstant(filteredMenu.id != 0 ? filteredMenu.mealType : menu.mealType);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Constants.kykGray900 : Constants.kykGray50,
      appBar: _buildAppBar(themeProvider, mealTypeConstant),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroHeader(filteredMenu.id != 0 ? filteredMenu : menu, mealTypeConstant),
            const SizedBox(height: Constants.space3),
            _buildMealTypeSelector(mealTypeConstant),
            const SizedBox(height: Constants.space3),
            filteredMenu.id != 0
                ? _buildMenuContent(filteredMenu, mealTypeConstant)
                : _buildNoMenuForMealType(mealTypeConstant),
            const SizedBox(height: Constants.space3),
            _buildNutritionSection(filteredMenu.id != 0 ? filteredMenu : menu, mealTypeConstant),
            const SizedBox(height: Constants.space3),
            _buildMealHoursInfo(mealTypeConstant),
            const SizedBox(height: Constants.space3),
            _buildDisclaimerInfo(mealTypeConstant),
            const SizedBox(height: Constants.space4),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeProvider themeProvider, String mealTypeConstant) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appBarBg = isDark ? Constants.darkSurface : Constants.kykPrimary;
    final appBarFg = isDark ? Constants.darkTextPrimary : Constants.white;
    
    return AppBar(
      elevation: 0,
      backgroundColor: appBarBg,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: appBarFg.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.restaurant_menu,
              color: appBarFg,
              size: 20,
            ),
          ),
          const SizedBox(width: Constants.space3),
          Text(
            'Menü Detayı',
            style: GoogleFonts.inter(
              fontSize: Constants.textLg,
              fontWeight: FontWeight.w700,
              color: appBarFg,
            ),
          ),
        ],
      ), 
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: appBarFg.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.arrow_back_ios,
            color: appBarFg,
            size: 18,
          ),
        ),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: appBarFg.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              themeProvider.isDarkMode ? Icons.brightness_7 : Icons.brightness_4,
              color: appBarFg,
              size: 18,
            ),
          ),
          onPressed: () {
            themeProvider.toggleTheme();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  themeProvider.isDarkMode ? 'Karanlık tema aktif' : 'Aydınlık tema aktif',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                backgroundColor: appBarBg,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: appBarFg.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.share,
              color: appBarFg,
              size: 18,
            ),
          ),
          onPressed: () => _shareMenu(),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  Constants.kykGray800,
                  Constants.kykGray900,
                ]
              : [
                  Constants.kykPrimary.withOpacity(0.05),
                  Constants.kykGray50,
                ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(Constants.space6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.restaurant_menu,
                size: 80,
                color: isDark ? Constants.kykGray400 : Constants.kykGray300,
              ),
              const SizedBox(height: Constants.space4),
              Text(
                'Menü Bulunamadı',
                style: GoogleFonts.inter(
                  fontSize: Constants.text2xl,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Constants.white : Constants.kykGray800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Constants.space3),
              Text(
                'Aradığınız menü bulunamadı veya henüz yüklenmedi.',
                style: GoogleFonts.inter(
                  fontSize: Constants.textBase,
                  color: isDark ? Constants.kykGray300 : Constants.kykGray600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroHeader(Menu menu, String mealTypeConstant) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Constants.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.getMealTypePrimaryColor(mealTypeConstant),
            AppTheme.getMealTypeSecondaryColor(mealTypeConstant),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.getMealTypePrimaryColor(mealTypeConstant).withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Tarih ve öğün bilgisi
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Constants.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: Constants.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: Constants.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('dd MMMM yyyy, EEEE').format(menu.date),
                      style: GoogleFonts.inter(
                        fontSize: Constants.textBase,
                        fontWeight: FontWeight.w600,
                        color: Constants.white,
                      ),
                    ),
                    const SizedBox(height: Constants.space1),
                    Text(
                      menu.mealType,
                      style: GoogleFonts.inter(
                        fontSize: Constants.textSm,
                        fontWeight: FontWeight.w500,
                        color: Constants.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Constants.space3),
          
          // İstatistikler
          Wrap(
            spacing: Constants.space4,
            runSpacing: Constants.space4,
            alignment: WrapAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                Icons.restaurant,
                '${menu.items.length}',
                'Yemek Çeşidi',
              ),
              _buildStatItem(
                Icons.category,
                '${menu.items.map((e) => e.category).toSet().length}',
                'Kategori',
              ),
              if (menu.energy.isNotEmpty)
                _buildStatItem(
                  Icons.local_fire_department,
                  menu.energy,
                  'Kalori',
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Constants.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Constants.white,
            size: 18,
          ),
        ),
        const SizedBox(height: Constants.space2),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: Constants.textLg,
            fontWeight: FontWeight.w800,
            color: Constants.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: Constants.textXs,
            fontWeight: FontWeight.w600,
            color: Constants.white.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMealTypeSelector(String mealTypeConstant) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Constants.space4),
      padding: const EdgeInsets.all(Constants.space2),
      decoration: BoxDecoration(
        color: isDark ? Constants.kykGray800 : Constants.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Constants.black : Constants.kykGray200).withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: AppConfig.mealTypes.map((mealType) {
          final isSelected = _selectedMealType == mealType;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedMealType = mealType),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: Constants.space3,
                  horizontal: Constants.space2,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.getMealTypePrimaryColor(mealTypeConstant) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  mealType,
                  style: GoogleFonts.inter(
                    fontSize: Constants.textBase,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Constants.white : (isDark ? Constants.kykGray300 : Constants.kykGray700),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuContent(Menu menu, String mealTypeConstant) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categories = menu.items.fold<Map<String, List<MenuItem>>>(
      {},
      (map, item) {
        map[item.category] = (map[item.category] ?? [])..add(item);
        return map;
      },
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Constants.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.getMealTypePrimaryColor(mealTypeConstant).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.restaurant_menu,
                  color: AppTheme.getMealTypePrimaryColor(mealTypeConstant),
                  size: 16,
                ),
              ),
              const SizedBox(width: Constants.space2),
              Text(
                'Bugünün Menüsü',
                style: GoogleFonts.inter(
                  fontSize: Constants.textLg,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Constants.white : Constants.kykGray800,
                ),
              ),
            ],
          ),
          const SizedBox(height: Constants.space2),
          ...categories.entries.map((entry) => _buildCategoryCard(entry.key, entry.value, mealTypeConstant)),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String category, List<MenuItem> items, String mealTypeConstant) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: Constants.space2),
      decoration: BoxDecoration(
        color: isDark ? Constants.kykGray800 : Constants.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Constants.black : Constants.kykGray200).withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Kategori başlığı
          Container(
            padding: const EdgeInsets.all(Constants.space2),
            decoration: BoxDecoration(
              color: _getCategoryColor(category).withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(category),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    _getCategoryIcon(category),
                    color: Constants.white,
                    size: 14,
                  ),
                ),
                const SizedBox(width: Constants.space3),
                Expanded(
                  child: Text(
                    category,
                    style: GoogleFonts.inter(
                      fontSize: Constants.textSm,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Constants.white : Constants.kykGray800,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Constants.space1,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(category),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${items.length}',
                    style: GoogleFonts.inter(
                      fontSize: Constants.textXs,
                      fontWeight: FontWeight.w600,
                      color: Constants.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Yemek listesi
          Padding(
            padding: const EdgeInsets.all(Constants.space3),
            child: Column(
              children: items.map((item) => _buildMenuItem(item, category, mealTypeConstant)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(MenuItem item, String category, String mealTypeConstant) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: Constants.space1),
      padding: const EdgeInsets.all(Constants.space2),
      decoration: BoxDecoration(
        color: isDark ? Constants.kykGray700 : Constants.kykGray50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: _getCategoryColor(category).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: _getCategoryColor(category),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: Constants.space2),
          Expanded(
            child: Text(
              item.name,
              style: GoogleFonts.inter(
                fontSize: Constants.textSm,
                fontWeight: FontWeight.w500,
                color: isDark ? Constants.white : Constants.kykGray800,
                height: 1.3,
              ),
            ),
          ),
          if (item.gram.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.space1,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                color: _getCategoryColor(category).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${item.gram}g',
                style: GoogleFonts.inter(
                  fontSize: Constants.textXs,
                  fontWeight: FontWeight.w600,
                  color: _getCategoryColor(category),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNoMenuForMealType(String mealTypeConstant) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Constants.space6),
      padding: const EdgeInsets.all(Constants.space6),
      decoration: BoxDecoration(
        color: isDark ? Constants.kykGray800 : Constants.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Constants.black : Constants.kykGray200).withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(Constants.space6),
            decoration: BoxDecoration(
              color: Constants.kykGray100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.restaurant_menu,
              size: Constants.text2xl * 2,
              color: AppTheme.getMealTypePrimaryColor(mealTypeConstant),
            ),
          ),
          const SizedBox(height: Constants.space4),
          Text(
            'Menü Bulunamadı',
            style: GoogleFonts.inter(
              fontSize: Constants.textXl,
              fontWeight: FontWeight.w700,
              color: isDark ? Constants.white : Constants.kykGray800,
            ),
          ),
          const SizedBox(height: Constants.space2),
          Text(
            'Seçilen öğün türü için menü henüz yayınlanmamış.',
            style: GoogleFonts.inter(
              fontSize: Constants.textBase,
              color: isDark ? Constants.kykGray300 : Constants.kykGray600,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Constants.space4),
          
          // Veri katkısı mesajı
          Container(
            padding: const EdgeInsets.all(Constants.space5),
            decoration: BoxDecoration(
              color: AppTheme.getMealTypePrimaryColor(mealTypeConstant).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.getMealTypePrimaryColor(mealTypeConstant).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.getMealTypePrimaryColor(mealTypeConstant),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.volunteer_activism,
                        color: Constants.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: Constants.space4),
                    Expanded(
                      child: Text(
                        'Veri Katkısı',
                        style: GoogleFonts.inter(
                          fontSize: Constants.textLg,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Constants.white : Constants.kykGray800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Constants.space4),
                Text(
                  'Eğer elinizde menüyle ilgili bir bilgi varsa, bize ulaşarak katkıda bulunabilirsiniz!',
                  style: GoogleFonts.inter(
                    fontSize: Constants.textBase,
                    color: isDark ? Constants.kykGray300 : Constants.kykGray600,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Constants.space4),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _launchEmail(),
                    icon: const Icon(Icons.email, size: 20),
                    label: Text(
                      'Bize Ulaşın',
                      style: GoogleFonts.inter(
                        fontSize: Constants.textBase,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.getMealTypePrimaryColor(mealTypeConstant),
                      foregroundColor: Constants.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Constants.space5,
                        vertical: Constants.space3,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionSection(Menu menu, String mealTypeConstant) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (menu.energy.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Constants.space4),
      padding: const EdgeInsets.all(Constants.space4),
      decoration: BoxDecoration(
        color: isDark ? Constants.kykGray800 : Constants.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.getMealTypePrimaryColor(mealTypeConstant).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Constants.black : Constants.kykGray200).withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.getMealTypePrimaryColor(mealTypeConstant).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.local_fire_department,
                  color: AppTheme.getMealTypePrimaryColor(mealTypeConstant),
                  size: 16,
                ),
              ),
              const SizedBox(width: Constants.space3),
              Text(
                'Besin Değerleri',
                style: GoogleFonts.inter(
                  fontSize: Constants.textLg,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Constants.white : Constants.kykGray800,
                ),
              ),
            ],
          ),
          const SizedBox(height: Constants.space4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Constants.space3),
            decoration: BoxDecoration(
              color: AppTheme.getMealTypePrimaryColor(mealTypeConstant).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.getMealTypePrimaryColor(mealTypeConstant).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: AppTheme.getMealTypePrimaryColor(mealTypeConstant),
                  size: 24,
                ),
                const SizedBox(width: Constants.space3),
                Text(
                  menu.energy,
                  style: GoogleFonts.inter(
                    fontSize: Constants.textXl,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.getMealTypePrimaryColor(mealTypeConstant),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealHoursInfo(String mealTypeConstant) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Constants.space4),
      padding: const EdgeInsets.all(Constants.space4),
      decoration: BoxDecoration(
        color: isDark ? Constants.kykGray800 : Constants.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.getMealTypePrimaryColor(mealTypeConstant).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Constants.black : Constants.kykGray200).withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.getMealTypePrimaryColor(mealTypeConstant).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.access_time,
                  color: AppTheme.getMealTypePrimaryColor(mealTypeConstant),
                  size: 16,
                ),
              ),
              const SizedBox(width: Constants.space3),
              Text(
                'Yemek Saatleri',
                style: GoogleFonts.inter(
                  fontSize: Constants.textLg,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Constants.white : Constants.kykGray800,
                ),
              ),
            ],
          ),
          const SizedBox(height: Constants.space3),
          Row(
            children: [
              Expanded(
                child: _buildMealTimeCard(
                  'Sabah Yemeği',
                  '06:30 - 13:00',
                  Icons.wb_sunny,
                  AppTheme.getMealTypePrimaryColor(mealTypeConstant),
                ),
              ),
              const SizedBox(width: Constants.space3),
              Expanded(
                child: _buildMealTimeCard(
                  'Akşam Yemeği',
                  '16:00 - 23:00',
                  Icons.nightlight,
                  AppTheme.getMealTypeSecondaryColor(mealTypeConstant),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMealTimeCard(String title, String time, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(Constants.space2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: color,
              size: 14,
            ),
          ),
          const SizedBox(height: Constants.space2),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: Constants.textSm,
              fontWeight: FontWeight.w700,
              color: isDark ? Constants.white : Constants.kykGray800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Constants.space1),
          Text(
            time,
            style: GoogleFonts.inter(
              fontSize: Constants.textSm,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerInfo(String mealTypeConstant) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Constants.space4),
      padding: const EdgeInsets.all(Constants.space4),
      decoration: BoxDecoration(
        color: isDark ? Constants.kykGray800 : Constants.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Constants.kykWarning.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Constants.black : Constants.kykGray200).withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Constants.kykWarning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.info_outline,
              color: Constants.kykWarning,
              size: 16,
            ),
          ),
          const SizedBox(width: Constants.space3),
          Expanded(
            child: Text(
              'Menüler KYK veya çeşitli sebeplerden dolayı yazılanla uyuşmayabilir. Lütfen yurt yönetimi ile teyit ediniz.',
              style: GoogleFonts.inter(
                fontSize: Constants.textSm,
                fontWeight: FontWeight.w600,
                color: isDark ? Constants.white : Constants.kykGray800,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'çorba':
        return Constants.foodWarm;
      case 'ana yemek':
      case 'et yemeği':
        return Constants.foodSpicy;
      case 'salata':
      case 'yeşillik':
        return Constants.foodFresh;
      case 'tatlı':
      case 'dessert':
        return Constants.foodSweet;
      case 'pilav':
      case 'makarna':
        return Constants.kykAccent;
      case 'ekmek':
      case 'kahvaltılık':
        return Constants.kykSecondary;
      default:
        return AppTheme.getMealTypePrimaryColor(_getMealTypeConstant(_selectedMealType));
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'çorba':
        return Icons.soup_kitchen;
      case 'ana yemek':
      case 'et yemeği':
        return Icons.restaurant;
      case 'salata':
      case 'yeşillik':
        return Icons.eco;
      case 'tatlı':
      case 'dessert':
        return Icons.cake;
      case 'pilav':
      case 'makarna':
        return Icons.rice_bowl;
      case 'ekmek':
      case 'kahvaltılık':
        return Icons.breakfast_dining;
      default:
        return Icons.fastfood;
    }
  }

  void _shareMenu() {
    // Menü paylaşma fonksiyonu
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Menü paylaşma özelliği yakında eklenecek!',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppTheme.getMealTypePrimaryColor(_getMealTypeConstant(_selectedMealType)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<void> _launchEmail() async {
    const String email = 'bulutsoftdev@gmail.com';
    const String subject = 'YurttaYe - Menü Veri Katkısı';
    const String body = '''Merhaba,

YurttaYe uygulaması için menü verisi katkısında bulunmak istiyorum.

Şehir: 
Tarih: 
Öğün Türü: 
Menü Detayları:

Teşekkürler!''';

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );

    try {
      bool canLaunch = await canLaunchUrl(emailUri);
      if (canLaunch) {
        await launchUrl(emailUri);
      } else {
        // Email uygulaması yoksa, email adresini kopyala
        await Clipboard.setData(const ClipboardData(text: email));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Email adresi kopyalandı: $email',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              backgroundColor: AppTheme.getMealTypePrimaryColor(_getMealTypeConstant(_selectedMealType)),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              action: SnackBarAction(
                label: 'Tamam',
                textColor: Constants.white,
                onPressed: () {},
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Email açılamadı: $e',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            backgroundColor: AppTheme.getMealTypePrimaryColor(_getMealTypeConstant(_selectedMealType)),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }
}