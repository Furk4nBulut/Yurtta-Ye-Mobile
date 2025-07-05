import 'package:flutter/material.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';

/// KYK Yurt Yemekleri için özel tasarlanmış hata widget'ı
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
      child: Padding(
        padding: const EdgeInsets.all(Constants.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hata ikonu
            Container(
              padding: const EdgeInsets.all(Constants.space6),
              decoration: BoxDecoration(
                color: Constants.kykError.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.error_outline,
                size: Constants.text2xl * 2,
                color: Constants.kykError,
              ),
            ),
            const SizedBox(height: Constants.space4),
            
            // Hata başlığı
            Text(
              'Bir Hata Oluştu',
              style: GoogleFonts.inter(
                fontSize: Constants.textXl,
                fontWeight: FontWeight.w600,
                color: Constants.kykGray700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Constants.space2),
            
            // Hata mesajı
            Text(
              error,
              style: GoogleFonts.inter(
                fontSize: Constants.textBase,
                color: Constants.kykGray500,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Constants.space4),
            
            // Tekrar dene butonu
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(
                'Tekrar Dene',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.kykPrimary,
                foregroundColor: Constants.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: Constants.space6,
                  vertical: Constants.space3,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: Constants.space3),
            
            // Alternatif çözüm
            OutlinedButton.icon(
              onPressed: () {
                // Ana sayfaya dön
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: const Icon(Icons.home),
              label: Text(
                'Ana Sayfaya Dön',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Constants.kykPrimary,
                side: BorderSide(color: Constants.kykPrimary, width: 1.5),
                padding: const EdgeInsets.symmetric(
                  horizontal: Constants.space6,
                  vertical: Constants.space3,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}