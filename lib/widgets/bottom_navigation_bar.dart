import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedMealIndex;
  final Function(int) onMealTypeChanged;
  final AnimationController pulseController;
  final Animation<double> pulseAnimation;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedMealIndex,
    required this.onMealTypeChanged,
    required this.pulseController,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Constants.kykGray900 : Constants.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Constants.kykGray700 : Constants.kykGray200,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _MinimalNavItem(
                icon: Icons.breakfast_dining_rounded,
                label: 'Kahvaltı',
                selected: selectedMealIndex == 0,
                color: AppTheme.getMealTypePrimaryColor(Constants.breakfastType),
                onTap: () => onMealTypeChanged(0),
              ),
              _SimpleSettingsButton(
                pulseController: pulseController,
                pulseAnimation: pulseAnimation,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  pulseController.stop();
                  pulseController.forward().then((_) {
                    pulseController.repeat(reverse: true);
                  });
                  context.pushNamed('settings');
                },
              ),
              _MinimalNavItem(
                icon: Icons.dinner_dining_rounded,
                label: 'Akşam',
                selected: selectedMealIndex == 1,
                color: AppTheme.getMealTypePrimaryColor(Constants.dinnerType),
                onTap: () => onMealTypeChanged(1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MinimalNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _MinimalNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: selected ? color : (isDark ? Constants.kykGray400 : Constants.kykGray500),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? color : (isDark ? Constants.kykGray400 : Constants.kykGray500),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              height: 3,
              width: selected ? 24 : 0,
              decoration: BoxDecoration(
                color: selected ? color : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SimpleSettingsButton extends StatelessWidget {
  final AnimationController pulseController;
  final Animation<double> pulseAnimation;
  final VoidCallback onTap;

  const _SimpleSettingsButton({
    required this.pulseController,
    required this.pulseAnimation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: AnimatedBuilder(
        animation: pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: pulseAnimation.value,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.settings_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 