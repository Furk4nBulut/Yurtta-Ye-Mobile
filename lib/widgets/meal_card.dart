import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/models/menu_item.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/widgets/category_section.dart';
import 'package:google_fonts/google_fonts.dart';

/// KYK Yurt Yemekleri için özel tasarlanmış yemek kartı widget'ı
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// KYK yurt yemekleri için özel ikonlar
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

  /// Yemek kategorisine göre renk
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
      default:
        return Constants.kykAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    final categories = widget.menu.items.fold<Map<String, List<MenuItem>>>(
      {},
      (map, item) {
        map[item.category] = (map[item.category] ?? [])..add(item);
        return map;
      },
    );

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
                horizontal: Constants.space4,
                vertical: Constants.space3,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isHovered 
                      ? Constants.kykPrimary
                      : Constants.kykGray300,
                  width: _isHovered ? 2 : 1,
                ),
              ),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
                  borderRadius: BorderRadius.circular(8),
                  splashColor: Constants.kykAccent.withOpacity(0.1),
                  child: Column(
                    children: [
                      _buildHeader(context, isSmallScreen, isDarkMode),
                      _buildBody(context, categories, isSmallScreen, isDarkMode),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// KYK başlık bölümü
  Widget _buildHeader(BuildContext context, bool isSmallScreen, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? Constants.space5 : Constants.space6),
      decoration: BoxDecoration(
        color: Constants.kykPrimary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Constants.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Constants.kykPrimary,
                    width: 1,
                  ),
                ),
                child: Icon(
                  _getMealTypeIcon(widget.menu.mealType),
                  color: Constants.kykPrimary,
                  size: isSmallScreen ? 28 : 32,
                ),
              ),
              const SizedBox(width: Constants.space5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getShortMealType(widget.menu.mealType),
                      style: GoogleFonts.inter(
                        fontSize: isSmallScreen ? Constants.text2xl : Constants.text2xl + 4,
                        fontWeight: FontWeight.w800,
                        color: Constants.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd MMMM yyyy, EEEE').format(widget.menu.date),
                      style: GoogleFonts.inter(
                        fontSize: Constants.textBase,
                        fontWeight: FontWeight.w600,
                        color: Constants.white.withOpacity(0.95),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.menu.energy.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Constants.space4,
                    vertical: Constants.space3,
                  ),
                  decoration: BoxDecoration(
                    color: Constants.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Constants.kykAccent,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${widget.menu.energy} kcal',
                    style: GoogleFonts.inter(
                      fontSize: Constants.textBase,
                      fontWeight: FontWeight.w700,
                      color: Constants.kykAccent,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Yemek içeriği bölümü
  Widget _buildBody(
    BuildContext context,
    Map<String, List<MenuItem>> categories,
    bool isSmallScreen,
    bool isDarkMode,
  ) {
    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? Constants.space5 : Constants.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kategori başlığı
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Constants.kykGray100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Constants.kykPrimary,
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.restaurant_menu,
                  size: 24,
                  color: Constants.kykPrimary,
                ),
              ),
              const SizedBox(width: Constants.space4),
              Text(
                'Menü İçeriği',
                style: GoogleFonts.inter(
                  fontSize: Constants.textXl,
                  fontWeight: FontWeight.w700,
                  color: Constants.kykPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: Constants.space5),
          
          // Kategoriler
          ...categories.entries.map((entry) {
            final categoryName = entry.key;
            final items = entry.value;
            
            return Container(
              margin: const EdgeInsets.only(bottom: Constants.space5),
              decoration: BoxDecoration(
                color: Constants.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Constants.kykGray300,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori başlığı
                  Container(
                    padding: const EdgeInsets.all(Constants.space4),
                    decoration: BoxDecoration(
                      color: Constants.kykGray100,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      border: Border.all(
                        color: _getCategoryColor(categoryName),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 28,
                          decoration: BoxDecoration(
                            color: _getCategoryColor(categoryName),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: Constants.space4),
                        Expanded(
                          child: Text(
                            categoryName,
                            style: GoogleFonts.inter(
                              fontSize: Constants.textLg,
                              fontWeight: FontWeight.w700,
                              color: Constants.kykGray700,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Constants.space3,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Constants.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getCategoryColor(categoryName),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '${items.length} çeşit',
                            style: GoogleFonts.inter(
                              fontSize: Constants.textSm,
                              fontWeight: FontWeight.w600,
                              color: _getCategoryColor(categoryName),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Yemek listesi
                  Padding(
                    padding: const EdgeInsets.all(Constants.space4),
                    child: Column(
                      children: items.map((item) => Container(
                        margin: const EdgeInsets.only(bottom: Constants.space3),
                        padding: const EdgeInsets.all(Constants.space3),
                        decoration: BoxDecoration(
                          color: Constants.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Constants.kykGray200,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Constants.kykGray100,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: _getCategoryColor(categoryName),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.restaurant,
                                size: 18,
                                color: _getCategoryColor(categoryName),
                              ),
                            ),
                            const SizedBox(width: Constants.space4),
                            Expanded(
                              child: Text(
                                item.name,
                                style: GoogleFonts.inter(
                                  fontSize: Constants.textBase,
                                  fontWeight: FontWeight.w600,
                                  color: Constants.kykGray700,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            if (item.gram.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Constants.space3,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Constants.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Constants.kykPrimary,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  '${item.gram}g',
                                  style: GoogleFonts.inter(
                                    fontSize: Constants.textSm,
                                    fontWeight: FontWeight.w700,
                                    color: Constants.kykPrimary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )).toList(),
                    ),
                  ),
                ],
              ),
            );
          }),
          
          const SizedBox(height: Constants.space5),
          
          // Detay butonu
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: Constants.space4),
            decoration: BoxDecoration(
              color: Constants.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Constants.kykPrimary,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Constants.kykGray100,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Constants.kykPrimary,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    size: 20,
                    color: Constants.kykPrimary,
                  ),
                ),
                const SizedBox(width: Constants.space3),
                Text(
                  'Detayları Görüntüle',
                  style: GoogleFonts.inter(
                    fontSize: Constants.textBase,
                    fontWeight: FontWeight.w700,
                    color: Constants.kykPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}