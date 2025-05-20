import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/models/menu_item.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';

/// A compact, information-rich card displaying an upcoming meal menu with a glowing date tag.
class UpcomingMealCard extends StatefulWidget {
  final Menu menu; // The menu data to display
  final VoidCallback? onTap; // Optional tap callback

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
    // Initialize animation controller for tap feedback
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    // Scale animation for a subtle tap effect
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Returns a food-themed Material Icon based on meal type.
  IconData _getMealTypeIcon(String mealType) {
    switch (mealType) {
      case 'Kahvaltı':
        return Icons.coffee;
      case 'Akşam Yemeği':
        return Icons.dinner_dining;
      default:
        return Icons.restaurant;
    }
  }

  /// Shortens meal type for concise display in header.
  String _getShortMealType(String mealType) {
    switch (mealType) {
      case 'Kahvaltı':
        return 'Sabah';
      case 'Akşam Yemeği':
        return 'Akşam';
      default:
        return mealType;
    }
  }

  /// Formats a calorie-based label from energy field.
  String _getCalorieLabel(Menu menu) {
    if (menu.energy.isEmpty) return 'No Calorie Info';
    try {
      final calories = double.parse(menu.energy.replaceAll(' kcal', ''));
      if (calories > 800) return 'High Calorie';
      if (calories < 400) return 'Low Calorie';
      return ''; // Removed "Balanced"
    } catch (e) {
      return ''; // Return empty string instead of "Balanced"
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final isVerySmallScreen = screenWidth < 350;
    final isTinyScreen = screenWidth < 320;

    return Semantics(
      label: 'Upcoming meal card for ${widget.menu.mealType} on ${DateFormat('dd MMM yyyy').format(widget.menu.date)}, '
          '${widget.menu.items.isEmpty ? 'no items' : '${widget.menu.items.length} items'}, '
          '${widget.menu.energy.isNotEmpty ? widget.menu.energy : 'no calorie info'}, '
          '${_getCalorieLabel(widget.menu)} calorie level',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              elevation: _isHovered ? 8 : 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(
                  color: isDarkMode ? Constants.gray700 : Constants.gray200,
                  width: 0.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: isDarkMode ? Constants.gray600 : Constants.gray100,
                    boxShadow: [
                      BoxShadow(
                        color: Constants.kykBlue600.withOpacity(_isHovered ? 0.25 : 0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: widget.onTap,
                    onTapDown: (_) => _controller.forward(),
                    onTapUp: (_) => _controller.reverse(),
                    onTapCancel: () => _controller.reverse(),
                    splashColor: Constants.kykYellow400.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(6),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Header with centered meal type and glowing date tag
                            _buildHeader(context, isSmallScreen, isVerySmallScreen, isTinyScreen, isDarkMode),
                            // Yellow accent divider
                            Container(
                              height: 1,
                              color: Constants.kykYellow400,
                            ),
                            // Body with centered menu items and calorie info
                            _buildBody(context, widget.menu.items, isSmallScreen, isVerySmallScreen, isTinyScreen, isDarkMode),
                          ],
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

  /// Builds the header with a centered uppercase meal type and glowing date tag.
  Widget _buildHeader(
      BuildContext context,
      bool isSmallScreen,
      bool isVerySmallScreen,
      bool isTinyScreen,
      bool isDarkMode,
      ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        isTinyScreen ? Constants.space1 / 2 : isVerySmallScreen ? Constants.space1 : Constants.space2,
      ),
      decoration: AppTheme.gradientDecoration(context).copyWith(
        gradient: LinearGradient(
          colors: [
            Constants.kykBlue600,
            Constants.kykYellow400.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Centered uppercase meal type with icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getMealTypeIcon(widget.menu.mealType),
                color: Constants.white,
                size: isTinyScreen
                    ? Constants.textXs - 2
                    : isVerySmallScreen
                    ? Constants.textXs - 1
                    : isSmallScreen
                    ? Constants.textXs
                    : Constants.textSm,
              ),
              const SizedBox(width: Constants.space1),
              Text(
                _getShortMealType(widget.menu.mealType).toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: isTinyScreen
                      ? Constants.textXs
                      : isVerySmallScreen
                      ? Constants.textSm - 1
                      : isSmallScreen
                      ? Constants.textSm
                      : Constants.textBase,
                  fontWeight: FontWeight.w700,
                  color: Constants.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: Constants.space1),
          // Glowing date tag
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTinyScreen ? Constants.space1 / 2 : isVerySmallScreen ? Constants.space1 : Constants.space2,
              vertical: isTinyScreen ? Constants.space1 / 2 : Constants.space1,
            ),
            decoration: BoxDecoration(
              color: Constants.kykYellow400,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: Constants.kykYellow400.withOpacity(_isHovered ? 0.8 : 0.6),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Constants.kykYellow400.withOpacity(_isHovered ? 0.5 : 0.3),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Text(
              DateFormat('dd MMM yyyy').format(widget.menu.date),
              style: GoogleFonts.poppins(
                fontSize: isTinyScreen
                    ? Constants.textXs - 1
                    : isVerySmallScreen
                    ? Constants.textXs
                    : isSmallScreen
                    ? Constants.textXs + 1
                    : Constants.textSm,
                fontWeight: FontWeight.w600,
                color: Constants.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the body with a centered list of menu items and calorie info with pulse animation.
  Widget _buildBody(
      BuildContext context,
      List<MenuItem> items,
      bool isSmallScreen,
      bool isVerySmallScreen,
      bool isTinyScreen,
      bool isDarkMode,
      ) {
    return Padding(
      padding: EdgeInsets.all(
        isTinyScreen ? Constants.space1 / 2 : isVerySmallScreen ? Constants.space1 : Constants.space2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: Constants.space1),
          // Empty state or menu items list
          if (items.isEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info,
                  size: isTinyScreen
                      ? Constants.textXs - 2
                      : isVerySmallScreen
                      ? Constants.textXs - 1
                      : isSmallScreen
                      ? Constants.textXs
                      : Constants.textSm,
                  color: isDarkMode ? Constants.gray300 : Constants.gray600,
                ),
                const SizedBox(width: Constants.space1),
                Text(
                  'Yemek yok',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: isTinyScreen
                        ? Constants.textXs - 2
                        : isVerySmallScreen
                        ? Constants.textXs - 1
                        : isSmallScreen
                        ? Constants.textXs
                        : Constants.textSm,
                    color: isDarkMode ? Constants.gray300 : Constants.gray600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            )
          else
            Column(
              children: items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: Constants.space1 / 2),
                child: Text(
                  item.name,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: isTinyScreen
                        ? Constants.textXs - 2
                        : isVerySmallScreen
                        ? Constants.textXs - 1
                        : isSmallScreen
                        ? Constants.textXs
                        : Constants.textSm,
                    color: isDarkMode ? Constants.gray300 : Constants.gray600,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              )).toList(),
            ),
          const SizedBox(height: Constants.space1),
          // Calorie info with pulse animation
          if (widget.menu.energy.isNotEmpty)
            AnimatedScale(
              scale: _isHovered ? 1.03 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isTinyScreen ? Constants.space1 / 2 : isVerySmallScreen ? Constants.space1 : Constants.space2,
                  vertical: isTinyScreen ? Constants.space1 / 2 : Constants.space1,
                ),
                decoration: BoxDecoration(
                  color: Constants.kykYellow400.withOpacity(_isHovered ? 0.25 : 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Constants.kykYellow400, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      size: isTinyScreen
                          ? Constants.textXs - 2
                          : isVerySmallScreen
                          ? Constants.textXs - 1
                          : isSmallScreen
                          ? Constants.textXs
                          : Constants.textSm,
                      color: Constants.kykYellow400,
                    ),
                    const SizedBox(width: Constants.space1),
                    Text(
                      widget.menu.energy,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: isTinyScreen
                            ? Constants.textXs - 2
                            : isVerySmallScreen
                            ? Constants.textXs - 1
                            : isSmallScreen
                            ? Constants.textXs
                            : Constants.textSm,
                        color: isDarkMode ? Constants.gray100 : Constants.gray800,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: Constants.space1),
          // Calorie label
          Text(
            _getCalorieLabel(widget.menu),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: isTinyScreen
                  ? Constants.textXs - 2
                  : isVerySmallScreen
                  ? Constants.textXs - 1
                  : isSmallScreen
                  ? Constants.textXs
                  : Constants.textSm,
              color: isDarkMode ? Constants.gray300 : Constants.gray600,
              fontStyle: FontStyle.italic,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}