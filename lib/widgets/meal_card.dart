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
                horizontal: Constants.space2,
                vertical: Constants.space1,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Constants.kykPrimary.withOpacity(_isHovered ? 0.15 : 0.08),
                    blurRadius: _isHovered ? 16 : 12,
                    offset: Offset(0, _isHovered ? 6 : 4),
                  ),
                ],
              ),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: _isHovered 
                        ? Constants.kykPrimary.withOpacity(0.3)
                        : Constants.kykGray200,
                    width: _isHovered ? 1.5 : 1,
                  ),
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
                  borderRadius: BorderRadius.circular(16),
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
      padding: EdgeInsets.all(isSmallScreen ? Constants.space3 : Constants.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Constants.kykPrimary,
            Constants.kykSecondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Constants.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getMealTypeIcon(widget.menu.mealType),
                  color: Constants.white,
                  size: isSmallScreen ? 20 : 24,
                ),
              ),
              const SizedBox(width: Constants.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getShortMealType(widget.menu.mealType),
                      style: GoogleFonts.inter(
                        fontSize: isSmallScreen ? Constants.textLg : Constants.textXl,
                        fontWeight: FontWeight.w700,
                        color: Constants.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      DateFormat('dd MMMM yyyy, EEEE').format(widget.menu.date),
                      style: GoogleFonts.inter(
                        fontSize: Constants.textSm,
                        fontWeight: FontWeight.w500,
                        color: Constants.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.menu.energy.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Constants.space2,
                    vertical: Constants.space1,
                  ),
                  decoration: BoxDecoration(
                    color: Constants.kykAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${widget.menu.energy} kcal',
                    style: GoogleFonts.inter(
                      fontSize: Constants.textXs,
                      fontWeight: FontWeight.w600,
                      color: Constants.white,
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
      padding: EdgeInsets.all(isSmallScreen ? Constants.space3 : Constants.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kategori başlığı
          Text(
            'Bugünün Menüsü',
            style: GoogleFonts.inter(
              fontSize: Constants.textLg,
              fontWeight: FontWeight.w600,
              color: Constants.kykPrimary,
            ),
          ),
          const SizedBox(height: Constants.space3),
          
          // Kategoriler
          ...categories.entries.map((entry) {
            final categoryName = entry.key;
            final items = entry.value;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: Constants.space3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori başlığı
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _getCategoryColor(categoryName),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: Constants.space2),
                      Text(
                        categoryName,
                        style: GoogleFonts.inter(
                          fontSize: Constants.textBase,
                          fontWeight: FontWeight.w600,
                          color: Constants.kykGray700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Constants.space2),
                  
                  // Yemek listesi
                  ...items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: Constants.space2),
                    child: Row(
                      children: [
                        Icon(
                          Icons.restaurant,
                          size: 16,
                          color: _getCategoryColor(categoryName),
                        ),
                        const SizedBox(width: Constants.space2),
                        Expanded(
                          child: Text(
                            item.name,
                            style: GoogleFonts.inter(
                              fontSize: Constants.textSm,
                              fontWeight: FontWeight.w500,
                              color: Constants.kykGray600,
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
                                fontSize: Constants.textXs,
                                fontWeight: FontWeight.w500,
                                color: Constants.kykGray500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  )),
                ],
              ),
            );
          }),
          
          const SizedBox(height: Constants.space3),
          
          // Detay butonu
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: Constants.space2),
            decoration: BoxDecoration(
              color: Constants.kykGray50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Constants.kykGray200,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Constants.kykPrimary,
                ),
                const SizedBox(width: Constants.space2),
                Text(
                  'Detayları Görüntüle',
                  style: GoogleFonts.inter(
                    fontSize: Constants.textSm,
                    fontWeight: FontWeight.w600,
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