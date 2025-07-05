import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/models/menu_item.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/providers/theme_provider.dart';
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

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final menuDay = DateTime(menu.date.year, menu.date.month, menu.date.day);
    final isPast = menuDay.isBefore(today);

    if (menu.id == 0 || isPast) {
      return Scaffold(
        appBar: _buildAppBar(themeProvider),
        body: _buildPastDateWarning(menu.date),
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

    return Scaffold(
      appBar: _buildAppBar(themeProvider),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroHeader(filteredMenu.id != 0 ? filteredMenu : menu),
            _buildMealTypeSelector(),
            const SizedBox(height: Constants.space4),
            filteredMenu.id != 0
                ? _buildMenuContent(filteredMenu)
                : _buildNoMenuForMealType(),
            const SizedBox(height: Constants.space4),
            _buildNutritionSection(filteredMenu.id != 0 ? filteredMenu : menu),
            const SizedBox(height: Constants.space6),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeProvider themeProvider) {
    return AppBar(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Constants.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.restaurant_menu,
              color: Constants.white,
              size: 18,
            ),
          ),
          const SizedBox(width: Constants.space2),
          Text(
            'Menü Detayı',
            style: GoogleFonts.inter(
              fontSize: Constants.textLg,
              fontWeight: FontWeight.w600,
              color: Constants.white,
            ),
          ),
        ],
      ),
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Constants.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.arrow_back_ios,
            color: Constants.white,
            size: 18,
          ),
        ),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Constants.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              themeProvider.isDarkMode ? Icons.brightness_7 : Icons.brightness_4,
              color: Constants.white,
              size: 18,
            ),
          ),
          onPressed: () => themeProvider.toggleTheme(),
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Constants.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.share,
              color: Constants.white,
              size: 18,
            ),
          ),
          onPressed: () => _shareMenu(),
        ),
      ],
    );
  }

  Widget _buildPastDateWarning(DateTime date) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Constants.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_amber_rounded, color: Constants.kykAccent, size: 64),
            const SizedBox(height: Constants.space4),
            Text(
              '${DateFormat('dd MMMM yyyy').format(date)} geçmiş bir tarih. Geçmiş günlere ait menüler görüntülenemez.',
              style: GoogleFonts.inter(
                fontSize: Constants.textBase,
                color: Constants.kykGray700,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Constants.space2),
            Text(
              'Lütfen bugünün veya gelecekteki bir tarihi seçin.',
              style: GoogleFonts.inter(
                fontSize: Constants.textSm,
                color: Constants.kykGray500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader(Menu menu) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Constants.space6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Constants.kykPrimary,
            Constants.kykSecondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Tarih ve öğün bilgisi
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Constants.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: Constants.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: Constants.space4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('dd MMMM yyyy, EEEE').format(menu.date),
                      style: GoogleFonts.inter(
                        fontSize: Constants.textLg,
                        fontWeight: FontWeight.w600,
                        color: Constants.white,
                      ),
                    ),
                    Text(
                      menu.mealType,
                      style: GoogleFonts.inter(
                        fontSize: Constants.textBase,
                        fontWeight: FontWeight.w500,
                        color: Constants.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Constants.space4),
          
          // İstatistikler
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            size: 20,
          ),
        ),
        const SizedBox(height: Constants.space2),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: Constants.textLg,
            fontWeight: FontWeight.w700,
            color: Constants.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: Constants.textXs,
            fontWeight: FontWeight.w500,
            color: Constants.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildMealTypeSelector() {
    return Container(
      margin: const EdgeInsets.all(Constants.space4),
      padding: const EdgeInsets.all(Constants.space2),
      decoration: BoxDecoration(
        color: Constants.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Constants.kykGray200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Constants.kykGray200.withOpacity(0.1),
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
                  color: isSelected ? Constants.kykPrimary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  mealType,
                  style: GoogleFonts.inter(
                    fontSize: Constants.textSm,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Constants.white : Constants.kykGray600,
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

  Widget _buildMenuContent(Menu menu) {
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
          Text(
            'Bugünün Menüsü',
            style: GoogleFonts.inter(
              fontSize: Constants.textXl,
              fontWeight: FontWeight.w600,
              color: Constants.kykPrimary,
            ),
          ),
          const SizedBox(height: Constants.space4),
          ...categories.entries.map((entry) => _buildCategoryCard(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String category, List<MenuItem> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: Constants.space3),
      decoration: BoxDecoration(
        color: Constants.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Constants.kykGray200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Constants.kykGray200.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Kategori başlığı
          Container(
            padding: const EdgeInsets.all(Constants.space3),
            decoration: BoxDecoration(
              color: _getCategoryColor(category).withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(category),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(category),
                    color: Constants.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: Constants.space3),
                Expanded(
                  child: Text(
                    category,
                    style: GoogleFonts.inter(
                      fontSize: Constants.textLg,
                      fontWeight: FontWeight.w600,
                      color: Constants.kykGray700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Constants.space2,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(category),
                    borderRadius: BorderRadius.circular(12),
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
              children: items.map((item) => _buildMenuItem(item, category)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(MenuItem item, String category) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Constants.space2),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getCategoryColor(category),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: Constants.space3),
          Expanded(
            child: Text(
              item.name,
              style: GoogleFonts.inter(
                fontSize: Constants.textBase,
                fontWeight: FontWeight.w500,
                color: Constants.kykGray700,
              ),
            ),
          ),
          if (item.gram.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.space2,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Constants.kykGray100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${item.gram}g',
                style: GoogleFonts.inter(
                  fontSize: Constants.textSm,
                  fontWeight: FontWeight.w600,
                  color: Constants.kykGray600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNoMenuForMealType() {
    return Container(
      margin: const EdgeInsets.all(Constants.space4),
      padding: const EdgeInsets.all(Constants.space6),
      decoration: BoxDecoration(
        color: Constants.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Constants.kykGray200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(Constants.space4),
            decoration: BoxDecoration(
              color: Constants.kykGray100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.restaurant_menu,
              size: Constants.textXl * 2,
              color: Constants.kykPrimary,
            ),
          ),
          const SizedBox(height: Constants.space3),
          Text(
            'Menü Bulunamadı',
            style: GoogleFonts.inter(
              fontSize: Constants.textLg,
              fontWeight: FontWeight.w600,
              color: Constants.kykGray700,
            ),
          ),
          const SizedBox(height: Constants.space2),
          Text(
            'Seçilen öğün türü için menü henüz yayınlanmamış.',
            style: GoogleFonts.inter(
              fontSize: Constants.textBase,
              color: Constants.kykGray500,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Constants.space4),
          
          // Veri katkısı mesajı
          Container(
            padding: const EdgeInsets.all(Constants.space4),
            decoration: BoxDecoration(
              color: Constants.kykAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Constants.kykAccent.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Constants.kykAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.volunteer_activism,
                        color: Constants.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: Constants.space3),
                    Expanded(
                      child: Text(
                        'Veri Katkısı',
                        style: GoogleFonts.inter(
                          fontSize: Constants.textLg,
                          fontWeight: FontWeight.w600,
                          color: Constants.kykGray700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Constants.space3),
                Text(
                  'Eğer elinizde menüyle ilgili bir bilgi varsa, bize ulaşarak katkıda bulunabilirsiniz!',
                  style: GoogleFonts.inter(
                    fontSize: Constants.textBase,
                    color: Constants.kykGray600,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Constants.space3),
                ElevatedButton.icon(
                  onPressed: () => _launchEmail(),
                  icon: const Icon(Icons.email),
                  label: Text(
                    'Bize Ulaşın',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.kykAccent,
                    foregroundColor: Constants.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Constants.space4,
                      vertical: Constants.space2,
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

  Widget _buildNutritionSection(Menu menu) {
    if (menu.energy.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Constants.space4),
      padding: const EdgeInsets.all(Constants.space4),
      decoration: BoxDecoration(
        color: Constants.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Constants.kykGray200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Constants.kykGray200.withOpacity(0.1),
            blurRadius: 4,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Constants.kykAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.local_fire_department,
                  color: Constants.kykAccent,
                  size: 20,
                ),
              ),
              const SizedBox(width: Constants.space3),
              Text(
                'Besin Değerleri',
                style: GoogleFonts.inter(
                  fontSize: Constants.textLg,
                  fontWeight: FontWeight.w600,
                  color: Constants.kykGray700,
                ),
              ),
            ],
          ),
          const SizedBox(height: Constants.space3),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Constants.space3),
            decoration: BoxDecoration(
              color: Constants.kykAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: Constants.kykAccent,
                  size: 24,
                ),
                const SizedBox(width: Constants.space2),
                Text(
                  menu.energy,
                  style: GoogleFonts.inter(
                    fontSize: Constants.textXl,
                    fontWeight: FontWeight.w700,
                    color: Constants.kykAccent,
                  ),
                ),
              ],
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
        return Constants.kykPrimary;
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
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        backgroundColor: Constants.kykPrimary,
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
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
              backgroundColor: Constants.kykPrimary,
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
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
            backgroundColor: Constants.kykPrimary,
          ),
        );
      }
    }
  }
}