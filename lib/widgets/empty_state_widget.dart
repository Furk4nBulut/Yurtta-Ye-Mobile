import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class EmptyStateWidget extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onEmailPressed;

  const EmptyStateWidget({
    Key? key,
    required this.selectedDate,
    required this.onEmailPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final selectedDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final isToday = selectedDay.isAtSameMomentAs(todayOnly);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Constants.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Constants.space4),
          Container(
            padding: const EdgeInsets.all(Constants.space6),
            decoration: BoxDecoration(
              color: Constants.white,
              borderRadius: BorderRadius.circular(16),
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
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(Constants.space4),
                  decoration: BoxDecoration(
                    color: Constants.kykGray100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isToday ? Icons.schedule : Icons.restaurant_menu,
                    size: Constants.textXl * 2,
                    color: Constants.kykPrimary,
                  ),
                ),
                const SizedBox(height: Constants.space4),
                Text(
                  isToday ? 'Bugün için menü henüz yayınlanmadı' : 'Menü bulunamadı',
                  style: GoogleFonts.inter(
                    fontSize: Constants.textLg,
                    fontWeight: FontWeight.w600,
                    color: Constants.kykGray700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Constants.space2),
                Text(
                  isToday 
                    ? 'Bugünün menüsü henüz sisteme girilmemiş. Lütfen daha sonra tekrar kontrol edin.'
                    : '${DateFormat('dd MMMM yyyy').format(selectedDate)} tarihi için henüz veri girişi yapılmadı.',
                  style: GoogleFonts.inter(
                    fontSize: Constants.textBase,
                    color: Constants.kykGray500,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Constants.space2),
                Text(
                  'Eğer elinizde menüyle ilgili bir bilgi varsa bulutsoftdev@gmail.com adresine ulaştırarak katkıda bulunabilirsiniz.',
                  style: GoogleFonts.inter(
                    fontSize: Constants.textSm,
                    color: Constants.kykGray500,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                // Veri katkısı mesajı
                Container(
                  margin: const EdgeInsets.only(top: Constants.space4),
                  padding: const EdgeInsets.all(Constants.space4),
                  decoration: BoxDecoration(
                    color: Constants.kykAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Constants.kykAccent.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Constants.kykAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.volunteer_activism,
                              color: Constants.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: Constants.space3),
                          Expanded(
                            child: Text(
                              'Veri Katkısı',
                              style: GoogleFonts.inter(
                                fontSize: Constants.textLg,
                                fontWeight: FontWeight.w600,
                                color: Constants.kykGray700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Constants.space3),
                      Text(
                        'Eğer elinizde menüyle ilgili bir bilgi varsa, bize ulaşarak katkıda bulunabilirsiniz!',
                        style: GoogleFonts.inter(
                          fontSize: Constants.textBase,
                          color: Constants.kykGray600,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Constants.space3),
                      ElevatedButton.icon(
                        onPressed: onEmailPressed,
                        icon: const Icon(Icons.email),
                        label: Text(
                          'Bize Ulaşın',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.kykAccent,
                          foregroundColor: Constants.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: Constants.space4,
                            vertical: Constants.space2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 