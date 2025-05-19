import 'package:flutter/material.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';

class AppErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const AppErrorWidget({
    Key? key,
    required this.error,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            error,
            style: AppTheme.theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Yeniden Dene'),
          ),
        ],
      ),
    );
  }
}