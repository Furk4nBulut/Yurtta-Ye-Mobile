import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (context, provider, child) {
        return TextButton(
          onPressed: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (picked != null) {
              provider.setSelectedDate(DateFormat('yyyy-MM-dd').format(picked));
            }
          },
          child: Text(
            provider.selectedDate == null
                ? 'Tarih Seç'
                : DateFormat('dd.MM.yyyy').format(DateTime.parse(provider.selectedDate!)),
          ),
        );
      },
    );
  }
}