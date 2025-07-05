import 'package:flutter/material.dart';
import 'package:yurttaye_mobile/models/menu_item.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';

/// KYK Yurt Yemekleri için özel tasarlanmış kategori bölümü widget'ı
class CategorySection extends StatefulWidget {
  final String category;
  final List<MenuItem> items;
  final bool isExpanded;
  final String? mealType;

  const CategorySection({
    Key? key,
    required this.category,
    required this.items,
    this.isExpanded = false,
    this.mealType,
  }) : super(key: key);

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
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
      case 'pilav':
      case 'makarna':
        return Constants.kykAccent;
      case 'ekmek':
      case 'kahvaltılık':
        return Constants.kykSecondary;
      default:
        return widget.mealType != null 
            ? AppTheme.getMealTypePrimaryColor(widget.mealType!)
            : Constants.kykPrimary;
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: Constants.space3),
      decoration: BoxDecoration(
        color: isDark ? Constants.kykGray800 : Constants.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Constants.kykGray700 : Constants.kykGray200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Constants.black : Constants.kykGray200).withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Kategori başlığı
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.all(Constants.space3),
              decoration: BoxDecoration(
                color: _getCategoryColor(widget.category).withOpacity(isDark ? 0.2 : 0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  // Kategori ikonu
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(widget.category),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(widget.category),
                      color: Constants.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: Constants.space3),
                  
                  // Kategori adı
                  Expanded(
                    child: Text(
                      widget.category,
                      style: GoogleFonts.inter(
                        fontSize: Constants.textBase,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Constants.white : Constants.kykGray700,
                      ),
                    ),
                  ),
                  
                  // Yemek sayısı
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Constants.space2,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(widget.category),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${widget.items.length}',
                      style: GoogleFonts.inter(
                        fontSize: Constants.textXs,
                        fontWeight: FontWeight.w600,
                        color: Constants.white,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: Constants.space2),
                  
                  // Genişletme/daraltma ikonu
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: isDark ? Constants.kykGray400 : Constants.kykGray500,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Yemek listesi
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              padding: const EdgeInsets.all(Constants.space3),
              child: Column(
                children: widget.items.map((item) => _buildMenuItem(item)).toList(),
              ),
            ),
            crossFadeState: _isExpanded 
                ? CrossFadeState.showSecond 
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: Constants.space2),
      child: Row(
        children: [
          // Yemek ikonu
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getCategoryColor(widget.category),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: Constants.space3),
          
          // Yemek adı
          Expanded(
            child: Text(
              item.name,
              style: GoogleFonts.inter(
                fontSize: Constants.textSm,
                fontWeight: FontWeight.w500,
                color: isDark ? Constants.kykGray300 : Constants.kykGray600,
              ),
            ),
          ),
          
          // Gram bilgisi
          if (item.gram.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.space2,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isDark ? Constants.kykGray700 : Constants.kykGray100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${item.gram}g',
                style: GoogleFonts.inter(
                  fontSize: Constants.textXs,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Constants.kykGray400 : Constants.kykGray500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}