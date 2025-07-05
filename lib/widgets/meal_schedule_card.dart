import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class MealScheduleCard extends StatelessWidget {
  const MealScheduleCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Constants.kykPrimary.withOpacity(0.1),
            Constants.kykAccent.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Constants.kykPrimary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Constants.kykPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.schedule,
                    color: Constants.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Yurt Yemek Saatleri',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Constants.kykGray800,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Yemek saatleri
            Row(
              children: [
                // Kahvaltı
                Expanded(
                  child: _buildMealTimeCard(
                    icon: Icons.breakfast_dining,
                    title: 'Kahvaltı',
                    startTime: '06:30',
                    endTime: '12:00',
                    color: Constants.kykBlue400,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Akşam Yemeği
                Expanded(
                  child: _buildMealTimeCard(
                    icon: Icons.dinner_dining,
                    title: 'Akşam Yemeği',
                    startTime: '16:00',
                    endTime: '23:00',
                    color: Constants.kykRed400,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Bilgi notu
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Constants.kykGray50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Constants.kykGray200,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Constants.kykGray600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Yemek saatleri dışında yemekhane kapalıdır. Lütfen saatlere dikkat ediniz.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Constants.kykGray600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTimeCard({
    required IconData icon,
    required String title,
    required String startTime,
    required String endTime,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Constants.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // İkon ve başlık
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: color,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Constants.kykGray700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Saat bilgileri
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeInfo('Başlangıç', startTime, color),
              Container(
                height: 20,
                width: 1,
                color: Constants.kykGray300,
              ),
              _buildTimeInfo('Bitiş', endTime, color),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo(String label, String time, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Constants.kykGray500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          time,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}