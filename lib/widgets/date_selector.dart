import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/utils/localization.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/language_provider.dart';

class DateSelector extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  final String? mealType;

  const DateSelector({
    Key? key,
    required this.selectedDate,
    required this.onDateChanged,
    this.mealType,
  }) : super(key: key);

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late DateTime _currentMonth;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected(immediate: true));
  }

  @override
  void didUpdateWidget(covariant DateSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate.month != _currentMonth.month || widget.selectedDate.year != _currentMonth.year) {
      _currentMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month);
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected(immediate: true));
    } else if (widget.selectedDate != oldWidget.selectedDate) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected(immediate: false));
    }
  }

  void _goToPreviousDay() {
    final prev = widget.selectedDate.subtract(const Duration(days: 1));
    widget.onDateChanged(prev);
    if (prev.month != _currentMonth.month || prev.year != _currentMonth.year) {
      _currentMonth = DateTime(prev.year, prev.month);
    }
  }

  void _goToNextDay() {
    final next = widget.selectedDate.add(const Duration(days: 1));
    widget.onDateChanged(next);
    if (next.month != _currentMonth.month || next.year != _currentMonth.year) {
      _currentMonth = DateTime(next.year, next.month);
    }
  }

  void _scrollToSelected({bool immediate = false}) {
    final selectedDay = widget.selectedDate.day;
    final boxWidth = 40.0 + 8.0; // width + spacing
    final offset = (selectedDay - 1) * boxWidth - 16.0;
    if (immediate) {
      _scrollController.jumpTo(offset > 0 ? offset : 0);
    } else {
      _scrollController.animateTo(
        offset > 0 ? offset : 0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.ease,
      );
    }
  }

  List<DateTime> _daysInMonth(DateTime month) {
    final days = List<DateTime>.generate(
      DateTime(month.year, month.month + 1, 0).day,
      (i) => DateTime(month.year, month.month, i + 1),
    );
    return days;
  }

  double _fadeOpacity(int index, int total) {
    // Fade first 2 and last 2 boxes
    if (index == 0 || index == total - 1) return 0.3;
    if (index == 1 || index == total - 2) return 0.6;
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = widget.selectedDate;
    final days = _daysInMonth(_currentMonth);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final languageCode = languageProvider.currentLanguageCode;
    
    // Gün ismini Localization'dan al
    final dayName = _getLocalizedDayName(selectedDate, languageCode);
    final centerDateLabel = _getLocalizedDateLabel(selectedDate, languageCode);
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = widget.mealType != null 
        ? AppTheme.getMealTypePrimaryColor(widget.mealType!)
        : Constants.kykPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 8),
          child: Row(
            children: [
              _miniIconButton(Icons.chevron_left, _goToPreviousDay, primaryColor),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        dayName[0].toUpperCase() + dayName.substring(1),
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Constants.white.withOpacity(0.7) : Constants.kykGray500,
                          letterSpacing: -0.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        centerDateLabel,
                        style: GoogleFonts.inter(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _miniIconButton(Icons.chevron_right, _goToNextDay, primaryColor),
            ],
          ),
        ),
        SizedBox(
          height: 44,
          child: Stack(
            children: [
              ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                itemCount: days.length,
                itemBuilder: (context, i) {
                  final day = days[i];
                  final isSelected = day.year == selectedDate.year && day.month == selectedDate.month && day.day == selectedDate.day;
                  final opacity = _fadeOpacity(i, days.length);
                  return Opacity(
                    opacity: opacity,
                    child: GestureDetector(
                      onTap: () => widget.onDateChanged(day),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? primaryColor : (isDark ? Constants.darkCard : Colors.white),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? primaryColor : (isDark ? Constants.darkBorder : Constants.kykGray200),
                            width: 1.2,
                          ),
                          boxShadow: isSelected
                              ? [BoxShadow(color: primaryColor.withOpacity(0.10), blurRadius: 6, offset: Offset(0, 2))]
                              : [],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _getLocalizedShortDayName(day, languageCode).toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : (isDark ? Constants.white.withOpacity(0.6) : Constants.kykGray500),
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              day.day.toString(),
                              style: GoogleFonts.inter(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : (isDark ? Constants.white : Constants.kykGray800),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              // Left fade
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: IgnorePointer(
                  child: Container(
                    width: 18,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          isDark ? Constants.darkBackground : Colors.white,
                          (isDark ? Constants.darkBackground : Colors.white).withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Right fade
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: IgnorePointer(
                  child: Container(
                    width: 18,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          isDark ? Constants.darkBackground : Colors.white,
                          (isDark ? Constants.darkBackground : Colors.white).withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  String _getLocalizedDayName(DateTime date, String languageCode) {
    final weekday = date.weekday;
    switch (weekday) {
      case 1:
        return Localization.getText('monday', languageCode);
      case 2:
        return Localization.getText('tuesday', languageCode);
      case 3:
        return Localization.getText('wednesday', languageCode);
      case 4:
        return Localization.getText('thursday', languageCode);
      case 5:
        return Localization.getText('friday', languageCode);
      case 6:
        return Localization.getText('saturday', languageCode);
      case 7:
        return Localization.getText('sunday', languageCode);
      default:
        return Localization.getText('monday', languageCode);
    }
  }

  String _getLocalizedShortDayName(DateTime date, String languageCode) {
    final dayName = _getLocalizedDayName(date, languageCode);
    return dayName.substring(0, 3);
  }

  String _getLocalizedDateLabel(DateTime date, String languageCode) {
    final day = date.day;
    final month = _getLocalizedMonthName(date.month, languageCode);
    final year = date.year;
    return '$day $month $year';
  }

  String _getLocalizedMonthName(int month, String languageCode) {
    switch (month) {
      case 1:
        return Localization.getText('january', languageCode);
      case 2:
        return Localization.getText('february', languageCode);
      case 3:
        return Localization.getText('march', languageCode);
      case 4:
        return Localization.getText('april', languageCode);
      case 5:
        return Localization.getText('may', languageCode);
      case 6:
        return Localization.getText('june', languageCode);
      case 7:
        return Localization.getText('july', languageCode);
      case 8:
        return Localization.getText('august', languageCode);
      case 9:
        return Localization.getText('september', languageCode);
      case 10:
        return Localization.getText('october', languageCode);
      case 11:
        return Localization.getText('november', languageCode);
      case 12:
        return Localization.getText('december', languageCode);
      default:
        return Localization.getText('january', languageCode);
    }
  }

  Widget _miniIconButton(IconData icon, VoidCallback onTap, Color primaryColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Material(
      color: isDark ? Constants.darkCard : Colors.white,
      borderRadius: BorderRadius.circular(7),
      child: InkWell(
        borderRadius: BorderRadius.circular(7),
        onTap: onTap,
        child: Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: primaryColor,
            size: 18,
          ),
        ),
      ),
    );
  }
} 
