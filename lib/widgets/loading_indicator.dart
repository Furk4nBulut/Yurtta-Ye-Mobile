import 'package:flutter/material.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Constants.kykBlue600),
      ),
    );
  }
}