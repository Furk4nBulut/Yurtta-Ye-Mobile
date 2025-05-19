import 'package:flutter/material.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class ExitDialog {
  static Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Constants.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'Uygulamadan Çık',
          semanticsLabel: 'Uygulamadan çıkış onayı',
          style: TextStyle(
            fontSize: Constants.textXl,
            fontWeight: FontWeight.w600,
            color: Constants.gray800,
          ),
        ),
        content: const Text(
          'Uygulamadan çıkmak istediğinizden emin misiniz?',
          style: TextStyle(
            fontSize: Constants.textBase,
            color: Constants.gray600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'İptal',
              style: TextStyle(
                fontSize: Constants.textBase,
                color: Constants.gray600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Çık',
              style: TextStyle(
                fontSize: Constants.textBase,
                color: Constants.kykBlue600,
              ),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }
}