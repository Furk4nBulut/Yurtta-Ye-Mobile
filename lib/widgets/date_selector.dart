import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class DateSelector extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const DateSelector({
    Key? key,
    required this.selectedDate,
    required this.onDateChanged,
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
    final centerDateLabel = DateFormat('d MMMM yyyy', 'tr').format(selectedDate);
    final dayName = DateFormat('EEEE', 'tr').format(selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 8),
          child: Row(
            children: [
              _miniIconButton(Icons.chevron_left, _goToPreviousDay),
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
                          color: Constants.kykGray500,
                          letterSpacing: -0.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        centerDateLabel,
                        style: GoogleFonts.inter(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: Constants.kykPrimary,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _miniIconButton(Icons.chevron_right, _goToNextDay),
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
                          color: isSelected ? Constants.kykPrimary : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? Constants.kykPrimary : Constants.kykGray200,
                            width: 1.2,
                          ),
                          boxShadow: isSelected
                              ? [BoxShadow(color: Constants.kykPrimary.withOpacity(0.10), blurRadius: 6, offset: Offset(0, 2))]
                              : [],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('E', 'tr').format(day).toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : Constants.kykGray500,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              day.day.toString(),
                              style: GoogleFonts.inter(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Constants.kykGray800,
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
                          Colors.white,
                          Colors.white.withOpacity(0.0),
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
                          Colors.white,
                          Colors.white.withOpacity(0.0),
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

  Widget _miniIconButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white,
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
            color: Constants.kykPrimary,
            size: 18,
          ),
        ),
      ),
    );
  }
} 
