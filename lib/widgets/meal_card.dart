import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/models/menu_item.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/widgets/category_section.dart';
import 'package:google_fonts/google_fonts.dart';

/// Kompakt ve toplu yemek kartı
class MealCard extends StatefulWidget {
  final Menu menu;
  final bool isDetailed;
  final VoidCallback? onTap;

  const MealCard({
    super.key,
    required this.menu,
    this.isDetailed = false,
    this.onTap,
  });

  @override
  _MealCardState createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Öğün tipi ikonu
  IconData _getMealTypeIcon(String mealType) {
    switch (mealType) {
      case 'Kahvaltı':
        return Icons.breakfast_dining;
      case 'Öğle Yemeği':
        return Icons.lunch_dining;
      case 'Akşam Yemeği':
        return Icons.dinner_dining;
      default:
        return Icons.restaurant;
    }
  }

  /// Kısa öğün adı
  String _getShortMealType(String mealType) {
    switch (mealType) {
      case 'Kahvaltı':
        return 'Kahvaltı';
      case 'Öğle Yemeği':
        return 'Öğle';
      case 'Akşam Yemeği':
        return 'Akşam';
      default:
        return mealType;
    }
  }

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

  /// Kategori ikonu
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

  /// Kategori rengi
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

  @override
  Widget build(BuildContext context) {
    final categories = widget.menu.items.fold<Map<String, List<MenuItem>>>(
      {},
      (map, item) {
        map[item.category] = (map[item.category] ?? [])..add(item);
        return map;
      },
    );

    final mealTypeConstant = _getMealTypeConstant(widget.menu.mealType);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      label: '${widget.menu.mealType} menüsü - ${DateFormat('dd MMM yyyy').format(widget.menu.date)}',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: Constants.space3,
                vertical: Constants.space2,
              ),
              decoration: BoxDecoration(
                color: isDark ? Constants.kykGray800 : Constants.white,
                border: Border.all(
                  color: _isHovered 
                      ? AppTheme.getMealTypePrimaryColor(mealTypeConstant).withOpacity(0.3)
                      : isDark ? Constants.kykGray700 : Constants.kykGray200,
                  width: _isHovered ? 1.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered 
                        ? AppTheme.getMealTypePrimaryColor(mealTypeConstant).withOpacity(0.15)
                        : (isDark ? Constants.black : Constants.kykGray200).withOpacity(_isHovered ? 0.12 : 0.08),
                    blurRadius: _isHovered ? 12 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: InkWell(
                onTap: widget.onTap ??
                    () => context.pushNamed(
                      'menu_detail',
                      pathParameters: {'id': widget.menu.id.toString()},
                    ),
                onTapDown: (_) => _controller.forward(),
                onTapUp: (_) => _controller.reverse(),
                onTapCancel: () => _controller.reverse(),
                splashColor: AppTheme.getMealTypePrimaryColor(mealTypeConstant).withOpacity(0.1),
                child: Column(
                  children: [
                    _buildCompactHeader(categories, mealTypeConstant),
                    _buildCompactContent(categories, mealTypeConstant),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Kompakt başlık bölümü
  Widget _buildCompactHeader(Map<String, List<MenuItem>> categories, String mealTypeConstant) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Constants.space4),
      decoration: AppTheme.getMealTypeGradient(mealTypeConstant),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Öğün ikonu
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Constants.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getMealTypeIcon(widget.menu.mealType),
              color: Constants.white,
              size: 20,
            ),
          ),
          const SizedBox(width: Constants.space3),
          // Öğün adı ve tarih
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        _getShortMealType(widget.menu.mealType),
                        style: AppTheme.getMealTypeTitleStyle(mealTypeConstant, context),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: Constants.space3),
                    Flexible(
                      child: Text(
                        DateFormat('d MMM yyyy').format(widget.menu.date),
                        style: AppTheme.getMealTypeSubtitleStyle(mealTypeConstant, context),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (widget.menu.energy.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department, color: Constants.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        widget.menu.energy + ' kkal',
                        style: GoogleFonts.inter(
                          fontSize: Constants.textSm,
                          fontWeight: FontWeight.w600,
                          color: Constants.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Kompakt içerik bölümü
  Widget _buildCompactContent(Map<String, List<MenuItem>> categories, String mealTypeConstant) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.all(Constants.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kategoriler
          ...categories.entries.map((entry) => _buildCompactCategory(entry.key, entry.value)),
          
          const SizedBox(height: Constants.space3),
          
          // Detay butonu
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: Constants.space3,
              vertical: Constants.space2,
            ),
            decoration: AppTheme.getMealTypeGradient(mealTypeConstant),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu_book,
                  size: 16,
                  color: Constants.white,
                ),
                const SizedBox(width: Constants.space2),
                Text(
                  'Detayları Görüntüle',
                  style: GoogleFonts.inter(
                    fontSize: Constants.textSm,
                    fontWeight: FontWeight.w600,
                    color: Constants.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Kompakt kategori
  Widget _buildCompactCategory(String category, List<MenuItem> items) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: Constants.space2),
      decoration: BoxDecoration(
        color: isDark ? Constants.kykGray700 : Constants.kykGray50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Constants.kykGray600 : Constants.kykGray200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Kategori başlığı
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Constants.space3,
              vertical: Constants.space2,
            ),
            decoration: BoxDecoration(
              color: _getCategoryColor(category).withOpacity(isDark ? 0.2 : 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                Icon(
                  _getCategoryIcon(category),
                  size: 16,
                  color: _getCategoryColor(category),
                ),
                const SizedBox(width: Constants.space2),
                Expanded(
                  child: Text(
                    category,
                    style: GoogleFonts.inter(
                      fontSize: Constants.textBase,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Constants.white : Constants.kykGray700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(category),
                    borderRadius: BorderRadius.circular(8),
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
            padding: const EdgeInsets.all(Constants.space2),
            child: Column(
              children: items.map((item) => _buildCompactMenuItem(item, category)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// Kompakt yemek öğesi
  Widget _buildCompactMenuItem(MenuItem item, String category) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: _getCategoryColor(category),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: Constants.space2),
          Expanded(
            child: Text(
              item.name,
              style: GoogleFonts.inter(
                fontSize: Constants.textSm,
                fontWeight: FontWeight.w500,
                color: isDark ? Constants.kykGray300 : Constants.kykGray700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (item.gram.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(left: 4),
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: isDark ? Constants.kykGray600 : Constants.kykGray100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                item.gram,
                style: GoogleFonts.inter(
                  fontSize: Constants.textXs,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Constants.kykGray300 : Constants.kykGray600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}