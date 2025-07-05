import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class DateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final Function(bool) onDateChanged;
  final bool hasPreviousMenu;
  final bool hasNextMenu;
  final double opacity;

  const DateSelector({
    Key? key,
    required this.selectedDate,
    required this.onDateChanged,
    required this.hasPreviousMenu,
    required this.hasNextMenu,
    required this.opacity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.space4,
        vertical: Constants.space2,
      ),
      child: Container(
        padding: const EdgeInsets.all(Constants.space3),
        decoration: BoxDecoration(
          color: Constants.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Constants.kykGray200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Constants.kykGray200.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: hasPreviousMenu
                    ? Constants.kykPrimary
                    : Constants.kykGray400,
                size: 20,
              ),
              onPressed: hasPreviousMenu
                  ? () {
                      HapticFeedback.lightImpact();
                      onDateChanged(false);
                    }
                  : null,
              tooltip: 'Önceki Gün',
            ),
            Column(
              children: [
                Text(
                  DateFormat('dd MMM yyyy').format(selectedDate),
                  style: GoogleFonts.inter(
                    fontSize: Constants.textLg,
                    fontWeight: FontWeight.w600,
                    color: Constants.kykPrimary,
                  ),
                ),
                Text(
                  DateFormat('EEEE').format(selectedDate),
                  style: GoogleFonts.inter(
                    fontSize: Constants.textSm,
                    fontWeight: FontWeight.w500,
                    color: Constants.kykGray500,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                color: hasNextMenu
                    ? Constants.kykPrimary
                    : Constants.kykGray400,
                size: 20,
              ),
              onPressed: hasNextMenu
                  ? () {
                      HapticFeedback.lightImpact();
                      onDateChanged(true);
                    }
                  : null,
              tooltip: 'Sonraki Gün',
            ),
          ],
        ),
      ),
    );
  }
} 