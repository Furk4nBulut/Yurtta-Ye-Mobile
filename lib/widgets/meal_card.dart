import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/models/menu_item.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/widgets/category_section.dart';

class MealCard extends StatefulWidget {
  final Menu menu;
  final bool isDetailed;
  final VoidCallback? onTap;

  const MealCard({
    Key? key,
    required this.menu,
    this.isDetailed = false,
    this.onTap,
  }) : super(key: key);

  @override
  _MealCardState createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
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

  IconData _getMealTypeIcon(String mealType) {
    switch (mealType) {
      case 'Kahvaltı':
        return Icons.breakfast_dining;
      case 'Akşam Yemeği':
        return Icons.dinner_dining;
      default:
        return Icons.restaurant_menu;
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

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap ??
              () => context.pushNamed(
            'menu_detail',
            pathParameters: {'id': widget.menu.id.toString()},
          ),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Card(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Constants.gray200, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(Constants.space4),
                    decoration: AppTheme.gradientDecoration(context),
                    child: Row(
                      children: [
                        Icon(
                          _getMealTypeIcon(widget.menu.mealType),
                          color: Constants.white,
                          size: Constants.textXl,
                        ),
                        const SizedBox(width: Constants.space2),
                        Expanded(
                          child: Text(
                            widget.isDetailed
                                ? widget.menu.mealType
                                : 'Bugünün ${widget.menu.mealType}',
                            style: AppTheme.mealTitleStyle(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(Constants.space4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('dd MMMM yyyy').format(widget.menu.date),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Constants.gray600,
                          ),
                        ),
                        const SizedBox(height: Constants.space3),
                        if (widget.menu.items.isEmpty)
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: Constants.textBase,
                                color: Constants.gray600,
                              ),
                              const SizedBox(width: Constants.space2),
                              Text(
                                'Bu öğün için yemek bulunamadı',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          )
                        else
                          ...categories.entries.map(
                                (entry) => CategorySection(
                              category: entry.key,
                              items: entry.value,
                              isExpanded: widget.isDetailed,
                            ),
                          ),
                        const SizedBox(height: Constants.space3),
                        Row(
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              size: Constants.textBase,
                              color: Constants.kykYellow400,
                            ),
                            const SizedBox(width: Constants.space2),
                            Text(
                              widget.menu.energy.isEmpty ? 'Kalori bilgisi yok' : widget.menu.energy,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Constants.gray800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
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
    );
  }
}