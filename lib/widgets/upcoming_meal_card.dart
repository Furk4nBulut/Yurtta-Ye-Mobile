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

  /// Tarih farkını hesapla ve metin olarak döndür
  String _getDaysDifferenceText() {
    final today = DateTime.now();
    final menuDate = widget.menu.date;
    final difference = menuDate.difference(today).inDays;
    
    if (difference == 0) {
      return 'Bugün';
    } else if (difference == 1) {
      return 'Yarın';
    } else if (difference == -1) {
      return 'Dün';
    } else if (difference > 1) {
      return '$difference gün sonra';
    } else {
      return '${difference.abs()} gün önce';
    }
  }

  /// Tarih farkını hesapla (sayısal değer)
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
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _isHovered
                      ? [
                          Constants.kykPrimary.withOpacity(0.05),
                          Constants.kykAccent.withOpacity(0.02),
                        ]
                      : [
                          Constants.white,
                          Constants.kykGray50,
                        ],
                ),
                border: Border.all(
                  color: _isHovered
                      ? Constants.kykPrimary.withOpacity(0.3)
                      : Constants.kykGray200,
                  width: _isHovered ? 1.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? Constants.kykPrimary.withOpacity(0.15)
                        : Constants.kykGray300.withOpacity(0.1),
                    blurRadius: _isHovered ? 12 : 8,
                    offset: Offset(0, _isHovered ? 4 : 2),
                    spreadRadius: _isHovered ? 1 : 0,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  onTapDown: (_) => _controller.forward(),
                  onTapUp: (_) => _controller.reverse(),
                  onTapCancel: () => _controller.reverse(),
                  borderRadius: BorderRadius.circular(12),
                  splashColor: Constants.kykPrimary.withOpacity(0.1),
                  highlightColor: Constants.kykPrimary.withOpacity(0.05),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Üst kısım - Başlık ve tarih
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Constants.kykPrimary,
                                    Constants.kykPrimary.withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Constants.kykPrimary.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _getMealTypeIcon(widget.menu.mealType),
                                color: Constants.white,
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _getShortMealType(widget.menu.mealType),
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Constants.kykGray800,
                                      letterSpacing: -0.2,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    DateFormat('dd MMM, EEEE').format(widget.menu.date),
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Constants.kykGray600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: daysDifference == 0
                                      ? [
                                          Constants.kykAccent,
                                          Constants.kykAccent.withOpacity(0.8),
                                        ]
                                      : daysDifference > 0
                                          ? [
                                              Constants.kykBlue400,
                                              Constants.kykBlue400.withOpacity(0.8),
                                            ]
                                          : [
                                              Constants.kykGray100,
                                              Constants.kykGray50,
                                            ],
                                ),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: daysDifference == 0
                                      ? Constants.kykAccent.withOpacity(0.3)
                                      : daysDifference > 0
                                          ? Constants.kykBlue400.withOpacity(0.3)
                                          : Constants.kykGray300,
                                  width: 1,
                                ),
                                boxShadow: (daysDifference == 0 || daysDifference > 0)
                                    ? [
                                        BoxShadow(
                                          color: daysDifference == 0
                                              ? Constants.kykAccent.withOpacity(0.2)
                                              : Constants.kykBlue400.withOpacity(0.2),
                                          blurRadius: 2,
                                          offset: const Offset(0, 1),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                _getDaysDifferenceText(),
                                style: GoogleFonts.inter(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                  color: daysDifference >= 0
                                      ? Constants.white
                                      : Constants.kykGray600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (widget.menu.items.isNotEmpty) ...[
                          Row(
                            children: [
                              Icon(
                                Icons.restaurant_menu,
                                size: 11,
                                color: Constants.kykPrimary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.menu.items.length} çeşit',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Constants.kykGray700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              if (widget.menu.energy.isNotEmpty)
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: Constants.kykRed400.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: Constants.kykRed400.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.local_fire_department,
                                          size: 9,
                                          color: Constants.kykRed400,
                                        ),
                                        const SizedBox(width: 2),
                                        Flexible(
                                          child: Text(
                                            widget.menu.energy,
                                            style: GoogleFonts.inter(
                                              fontSize: 8,
                                              fontWeight: FontWeight.w600,
                                              color: Constants.kykRed400,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Constants.kykGray50,
                                  Constants.white,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Constants.kykGray200,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.menu_book,
                                      size: 11,
                                      color: Constants.kykPrimary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Menü:',
                                      style: GoogleFonts.inter(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        color: Constants.kykGray700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  height: 54,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ...widget.menu.items.take(5).map((item) => Padding(
                                              padding: const EdgeInsets.only(bottom: 2),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 3,
                                                    height: 3,
                                                    decoration: BoxDecoration(
                                                      color: Constants.kykPrimary,
                                                      borderRadius: BorderRadius.circular(1.5),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      item.name,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 8,
                                                        fontWeight: FontWeight.w500,
                                                        color: Constants.kykGray700,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                        if (widget.menu.items.length > 5) ...[
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Container(
                                                width: 3,
                                                height: 3,
                                                decoration: BoxDecoration(
                                                  color: Constants.kykGray400,
                                                  borderRadius: BorderRadius.circular(1.5),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                '+${widget.menu.items.length - 5} daha',
                                                style: GoogleFonts.inter(
                                                  fontSize: 7,
                                                  fontWeight: FontWeight.w500,
                                                  color: Constants.kykGray500,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Constants.kykPrimary.withOpacity(0.1),
                                Constants.kykPrimary.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Constants.kykPrimary.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Detaylar',
                                style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: Constants.kykPrimary,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 9,
                                color: Constants.kykPrimary,
                              ),
                            ],
                          ),
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