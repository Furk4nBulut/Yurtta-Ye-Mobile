import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/models/menu_item.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';

/// KYK Yurt Yemekleri için özel tasarlanmış gelecek öğün kartı
class UpcomingMealCard extends StatefulWidget {
  final Menu menu;
  final VoidCallback? onTap;

  const UpcomingMealCard({
    super.key,
    required this.menu,
    this.onTap,
  });

  @override
  _UpcomingMealCardState createState() => _UpcomingMealCardState();
}

class _UpcomingMealCardState extends State<UpcomingMealCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
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

  /// Tarih farkını hesapla
  int _getDaysDifference() {
    final today = DateTime.now();
    final menuDate = widget.menu.date;
    return menuDate.difference(today).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final daysDifference = _getDaysDifference();

    return Semantics(
      label: 'Gelecek ${widget.menu.mealType} menüsü - ${DateFormat('dd MMM yyyy').format(widget.menu.date)}',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
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
                  onTap: widget.onTap,
                  onTapDown: (_) => _controller.forward(),
                  onTapUp: (_) => _controller.reverse(),
                  onTapCancel: () => _controller.reverse(),
                  borderRadius: BorderRadius.circular(8),
                  splashColor: Constants.kykAccent.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(Constants.space3),
                    child: Row(
                      children: [
                        // İkon bölümü
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Constants.kykGray100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Constants.kykPrimary,
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            _getMealTypeIcon(widget.menu.mealType),
                            color: Constants.kykPrimary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: Constants.space3),
                        
                        // İçerik bölümü
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Öğün adı
                              Text(
                                _getShortMealType(widget.menu.mealType),
                                style: GoogleFonts.inter(
                                  fontSize: Constants.textBase,
                                  fontWeight: FontWeight.w600,
                                  color: Constants.kykGray700,
                                ),
                              ),
                              const SizedBox(height: Constants.space1),
                              
                              // Tarih
                              Text(
                                DateFormat('dd MMM yyyy, EEEE').format(widget.menu.date),
                                style: GoogleFonts.inter(
                                  fontSize: Constants.textSm,
                                  fontWeight: FontWeight.w500,
                                  color: Constants.kykGray500,
                                ),
                              ),
                              if (widget.menu.items.isNotEmpty) ...[
                                const SizedBox(height: Constants.space1),
                                Text(
                                  '${widget.menu.items.length} yemek çeşidi',
                                  style: GoogleFonts.inter(
                                    fontSize: Constants.textXs,
                                    fontWeight: FontWeight.w500,
                                    color: Constants.kykGray400,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        
                        // Tarih farkı badge'i
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Constants.space2,
                            vertical: Constants.space1,
                          ),
                          decoration: BoxDecoration(
                            color: daysDifference <= 1 
                                ? Constants.kykAccent 
                                : Constants.kykGray100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: daysDifference <= 1 
                                  ? Constants.kykAccent 
                                  : Constants.kykGray300,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            daysDifference == 0 
                                ? 'Bugün'
                                : daysDifference == 1 
                                    ? 'Yarın'
                                    : '$daysDifference gün',
                            style: GoogleFonts.inter(
                              fontSize: Constants.textXs,
                              fontWeight: FontWeight.w600,
                              color: daysDifference <= 1 
                                  ? Constants.white 
                                  : Constants.kykGray600,
                            ),
                          ),
                        ),
                        
                        // Ok ikonu
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Constants.kykGray400,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}