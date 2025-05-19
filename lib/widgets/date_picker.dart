import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/utils/config.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: provider.isLoading
              ? null
              : () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Constants.kykBlue600,
                      onPrimary: Constants.white,
                      surface: Constants.white,
                      onSurface: Constants.gray800,
                    ),
                    dialogBackgroundColor: Constants.white,
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              provider.setSelectedDate(AppConfig.apiDateFormat.format(picked));
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Constants.space4,
              vertical: Constants.space3,
            ),
            decoration: BoxDecoration(
              color: Constants.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Constants.gray200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  provider.selectedDate == null
                      ? 'Tarih Seç'
                      : AppConfig.displayDateFormat.format(DateTime.parse(provider.selectedDate!)),
                  style: TextStyle(
                    fontSize: Constants.textBase,
                    color: Constants.gray600,
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: Constants.gray600,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}