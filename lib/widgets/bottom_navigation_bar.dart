import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/theme_provider.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedMealIndex;
  final Function(int) onMealTypeChanged;
  final AnimationController pulseController;
  final Animation<double> pulseAnimation;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedMealIndex,
    required this.onMealTypeChanged,
    required this.pulseController,
    required this.pulseAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Constants.kykGray800 : Constants.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Constants.kykGray700 : Constants.kykGray300,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: Constants.space2, vertical: Constants.space2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Kahvaltı butonu
              Expanded(
                child: _buildMealTypeButton(
                  context: context,
                  icon: Icons.breakfast_dining_rounded,
                  label: 'Kahvaltı',
                  isSelected: selectedMealIndex == 0,
                  mealType: Constants.breakfastType,
                  onTap: () => onMealTypeChanged(0),
                ),
              ),
              
              // Ortadaki filtre butonu
              Container(
                margin: const EdgeInsets.symmetric(horizontal: Constants.space2),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      // Özel animasyon efekti
                      pulseController.stop();
                      pulseController.forward().then((_) {
                        pulseController.repeat(reverse: true);
                      });
                      
                      context.pushNamed('filter');
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Ink(
                      child: AnimatedBuilder(
                        animation: pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: pulseAnimation.value,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: AppTheme.getMealTypeLinearGradient(Constants.breakfastType),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppTheme.getMealTypePrimaryColor(Constants.breakfastType),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.filter_list_rounded,
                                color: Constants.white,
                                size: 20,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              
              // Akşam yemeği butonu
              Expanded(
                child: _buildMealTypeButton(
                  context: context,
                  icon: Icons.dinner_dining_rounded,
                  label: 'Akşam',
                  isSelected: selectedMealIndex == 1,
                  mealType: Constants.dinnerType,
                  onTap: () => onMealTypeChanged(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealTypeButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required String mealType,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppTheme.getMealTypePrimaryColor(mealType);
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSelected 
              ? (isDark ? primaryColor.withOpacity(0.2) : Constants.kykGray100) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.transparent,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: isSelected 
                    ? primaryColor 
                    : (isDark ? Constants.kykGray700 : Constants.kykGray100),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected 
                      ? primaryColor 
                      : (isDark ? Constants.kykGray600 : Constants.kykGray300),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: isSelected 
                    ? Constants.white 
                    : (isDark ? Constants.kykGray300 : Constants.kykGray600),
                size: 18,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected 
                    ? primaryColor 
                    : (isDark ? Constants.kykGray300 : Constants.kykGray600),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
} 