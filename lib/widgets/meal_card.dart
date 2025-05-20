import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/models/menu_item.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/widgets/category_section.dart';
import 'package:google_fonts/google_fonts.dart';

/// A card widget displaying a meal menu with food-themed styling for a food app.
class MealCard extends StatefulWidget {
  final Menu menu; // The menu data to display
  final bool isDetailed; // Whether to show detailed menu items
  final VoidCallback? onTap; // Optional tap callback

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
    // Initialize animation controller for tap feedback
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    // Scale animation for a bouncy tap effect
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
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
        return Icons.coffee; // Coffee icon for breakfast
      case 'Akşam Yemeği':
        return Icons.dinner_dining; // Dinner icon for evening meals
      default:
        return Icons.restaurant; // General restaurant icon
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final isVerySmallScreen = screenWidth < 350;

    // Group menu items by category
    final categories = widget.menu.items.fold<Map<String, List<MenuItem>>>(
      {},
          (map, item) {
        map[item.category] = (map[item.category] ?? [])..add(item);
        return map;
      },
    );

    return Semantics(
      label: 'Meal card for ${widget.menu.mealType} on ${DateFormat('dd MMM yyyy').format(widget.menu.date)}',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              elevation: _isHovered ? 10 : 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isDarkMode ? Constants.gray700 : Constants.gray200,
                  width: 0.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: isDarkMode ? Constants.gray800 : Constants.white,
                    boxShadow: [
                      BoxShadow(
                        color: Constants.kykBlue600.withOpacity(_isHovered ? 0.3 : 0.2),
                        blurRadius: 12,
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
                    splashColor: Constants.kykYellow400.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Header section with centered meal type and date
                        _buildHeader(context, isSmallScreen, isVerySmallScreen, isDarkMode),
                        // Body section with centered menu items and calorie info
                        _buildBody(context, categories, isSmallScreen, isVerySmallScreen, isDarkMode),
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

  /// Builds the header with a centered uppercase meal type and date.
  Widget _buildHeader(
      BuildContext context,
      bool isSmallScreen,
      bool isVerySmallScreen,
      bool isDarkMode,
      ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        isVerySmallScreen ? Constants.space1 : isSmallScreen ? Constants.space2 : Constants.space3,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Constants.kykBlue600,
            Constants.kykYellow400.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                size: isVerySmallScreen
                    ? Constants.textSm - 2
                    : isSmallScreen
                    ? Constants.textSm
                    : Constants.textBase,
              ),
              const SizedBox(width: Constants.space1),
              Text(
                _getShortMealType(widget.menu.mealType).toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: isVerySmallScreen
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
          // Date
          Text(
            DateFormat('dd MMM yyyy').format(widget.menu.date),
            style: AppTheme.mealSubtitleStyle(context).copyWith(
              fontSize: isVerySmallScreen
                  ? Constants.textXs - 1
                  : isSmallScreen
                  ? Constants.textXs
                  : Constants.textSm,
              color: Constants.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Builds the body with centered menu items and calorie badge.
  Widget _buildBody(
      BuildContext context,
      Map<String, List<MenuItem>> categories,
      bool isSmallScreen,
      bool isVerySmallScreen,
      bool isDarkMode,
      ) {
    return Padding(
      padding: EdgeInsets.all(
        isVerySmallScreen ? Constants.space2 : isSmallScreen ? Constants.space3 : Constants.space4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: Constants.space3),
          // Empty state
          if (widget.menu.items.isEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: isVerySmallScreen
                      ? Constants.textXs - 1
                      : isSmallScreen
                      ? Constants.textXs
                      : Constants.textBase,
                  color: isDarkMode ? Constants.gray300 : Constants.gray700,
                ),
                const SizedBox(width: Constants.space2),
                Text(
                  'Bu öğün için yemek bulunamadı',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: isVerySmallScreen
                        ? Constants.textSm - 1
                        : isSmallScreen
                        ? Constants.textSm
                        : Constants.textBase,
                    color: isDarkMode ? Constants.gray100 : Constants.gray700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            )
          // Menu items
          else
            Center(
              child: Column(
                children: categories.entries.map((entry) {
                  return CategorySection(
                    category: entry.key,
                    items: entry.value,
                    isExpanded: widget.isDetailed,
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: Constants.space3),
          // Calorie badge with hover animation
          Center(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  // Optional: Add action for calorie badge tap (e.g., show details)
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: Constants.space2,
                    vertical: Constants.space1,
                  ),
                  decoration: BoxDecoration(
                    color: Constants.kykYellow400.withOpacity(_isHovered ? 0.3 : 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Constants.kykYellow400, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        size: isVerySmallScreen
                            ? Constants.textXs - 1
                            : isSmallScreen
                            ? Constants.textXs
                            : Constants.textSm,
                        color: Constants.kykYellow400,
                      ),
                      const SizedBox(width: Constants.space1),
                      Text(
                        widget.menu.energy.isEmpty ? 'Kalori bilgisi yok' : widget.menu.energy,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDarkMode ? Constants.gray100 : Constants.gray800,
                          fontWeight: FontWeight.w600,
                          fontSize: isVerySmallScreen
                              ? Constants.textSm - 1
                              : isSmallScreen
                              ? Constants.textSm
                              : Constants.textBase,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}