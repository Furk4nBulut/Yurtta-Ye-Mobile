import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/theme_provider.dart';
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
    
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode ? Constants.kykGray800 : Constants.white,
        boxShadow: [
          BoxShadow(
            color: Constants.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
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
                  icon: Icons.breakfast_dining_rounded,
                  label: 'Kahvaltı',
                  isSelected: selectedMealIndex == 0,
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
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Constants.kykPrimary, Constants.kykPrimary.withOpacity(0.8)],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Constants.kykPrimary.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
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
              
              // Akşam butonu
              Expanded(
                child: _buildMealTypeButton(
                  icon: Icons.dinner_dining_rounded,
                  label: 'Akşam',
                  isSelected: selectedMealIndex == 1,
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
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Constants.kykPrimary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: isSelected ? Constants.kykPrimary : Constants.kykGray200,
                borderRadius: BorderRadius.circular(6),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: Constants.kykPrimary.withOpacity(0.3),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ] : null,
              ),
              child: Icon(
                icon,
                color: isSelected ? Constants.white : Constants.kykGray600,
                size: 18,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Constants.kykPrimary : Constants.kykGray600,
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