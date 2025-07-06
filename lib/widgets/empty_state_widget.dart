import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class EmptyStateWidget extends StatefulWidget {
  final DateTime selectedDate;
  final VoidCallback onEmailPressed;
  final VoidCallback? onRefreshPressed;
  final VoidCallback? onWebsitePressed;

  const EmptyStateWidget({
    Key? key,
    required this.selectedDate,
    required this.onEmailPressed,
    this.onRefreshPressed,
    this.onWebsitePressed,
  }) : super(key: key);

  @override
  State<EmptyStateWidget> createState() => _EmptyStateWidgetState();
}

class _EmptyStateWidgetState extends State<EmptyStateWidget> {
  bool _isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final selectedDay = DateTime(widget.selectedDate.year, widget.selectedDate.month, widget.selectedDate.day);
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
              color: isDark ? Constants.darkCard : Constants.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Constants.darkBorder : Constants.kykGray200,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Sade ana bölüm
                _buildSimpleMainSection(isToday, isDark),
                const SizedBox(height: Constants.space6),

                // Ayırıcı çizgi
                _buildDivider(isDark),
                const SizedBox(height: Constants.space5),

                // Veri katkısı bölümü
                _buildDataContribution(isDark),
                const SizedBox(height: Constants.space5),

                _buildDivider(isDark),

                const SizedBox(height: Constants.space3),

                // Yenile butonu
                _buildRefreshButton(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Sade ana bölüm
  Widget _buildSimpleMainSection(bool isToday, bool isDark) {
    return Column(
      children: [
        // Sade ikon
        Icon(
          isToday ? Icons.schedule : Icons.restaurant_menu,
          size: Constants.text2xl * 2,
          color: isDark ? Constants.white.withOpacity(0.8) : Constants.kykPrimary,
        ),
        const SizedBox(height: Constants.space5),

        // Sade başlık
        Text(
          isToday ? 'Bugün için menü henüz yayınlanmadı' : 'Menü bulunamadı',
          style: GoogleFonts.inter(
            fontSize: Constants.textXl,
            fontWeight: FontWeight.w600,
            color: isDark ? Constants.darkTextPrimary : Constants.kykGray800,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: Constants.space4),

        // Sade açıklama
        Text(
          isToday
              ? 'Bugünün menüsü henüz sisteme girilmemiş. Lütfen daha sonra tekrar kontrol edin.'
              : '${DateFormat('dd MMMM yyyy').format(widget.selectedDate)} tarihi için henüz veri girişi yapılmadı.',
          style: GoogleFonts.inter(
            fontSize: Constants.textBase,
            color: isDark ? Constants.white.withOpacity(0.7) : Constants.kykGray600,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // Ayırıcı çizgi
  Widget _buildDivider(bool isDark) {
    return Container(
      height: 1,
      color: isDark ? Constants.darkDivider : Constants.kykGray200,
    );
  }

  // Veri katkısı bölümü
  Widget _buildDataContribution(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(Constants.space3),
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
                  color: isDark ? Constants.darkTextPrimary : Constants.kykGray800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: Constants.space3),
        Text(
          'Eğer elinizde menüyle ilgili bir bilgi varsa, bize ulaşarak katkıda bulunabilirsiniz.',
          style: GoogleFonts.inter(
            fontSize: Constants.textSm,
            color: isDark ? Constants.white.withOpacity(0.7) : Constants.kykGray600,
            height: 1.4,
          ),
          textAlign: TextAlign.left,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: Constants.space4),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: widget.onEmailPressed,
            icon: const Icon(Icons.email, size: 20),
            label: Text(
              'Bize Ulaşın',
              style: GoogleFonts.inter(
                fontSize: Constants.textBase,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Constants.kykAccent,
              foregroundColor: Constants.white,
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.space5,
                vertical: Constants.space3,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  // Yenile butonu - Loading state ile
  Widget _buildRefreshButton(bool isDark) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isRefreshing ? null : () async {
          setState(() {
            _isRefreshing = true;
          });
          
          HapticFeedback.lightImpact();
          
          if (widget.onRefreshPressed != null) {
            widget.onRefreshPressed!();
          }
          
          // Kısa bir gecikme ekleyerek loading animasyonunu göster
          await Future.delayed(const Duration(milliseconds: 500));
          
          if (mounted) {
            setState(() {
              _isRefreshing = false;
            });
          }
        },
        icon: _isRefreshing 
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Constants.white),
              ),
            )
          : const Icon(Icons.refresh, size: 20),
        label: Text(
          _isRefreshing ? 'Yenileniyor...' : 'Yenile',
          style: GoogleFonts.inter(
            fontSize: Constants.textBase,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _isRefreshing ? Constants.kykGray400 : Constants.kykPrimary,
          foregroundColor: Constants.white,
          padding: const EdgeInsets.symmetric(
            horizontal: Constants.space5,
            vertical: Constants.space3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
      ),
    );
  }
} 