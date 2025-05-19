import 'package:flutter/material.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error.contains('Connection refused')
                ? 'Sunucuya bağlanılamadı.'
                : 'Hata: $error',
            style: TextStyle(
              fontSize: Constants.textBase,
              color: Constants.gray600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Constants.space3),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: Constants.kykBlue600,
              foregroundColor: Constants.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }
}