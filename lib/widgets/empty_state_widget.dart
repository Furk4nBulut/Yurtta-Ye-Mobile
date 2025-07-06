import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/utils/localization.dart';
import 'package:yurttaye_mobile/providers/language_provider.dart';
import 'package:provider/provider.dart';

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
    final languageProvider = Provider.of<LanguageProvider>(context);
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
                _buildSimpleMainSection(isToday, isDark, languageProvider),
                const SizedBox(height: Constants.space6),

                // Ayırıcı çizgi
                _buildDivider(isDark),
                const SizedBox(height: Constants.space5),

                // Veri katkısı bölümü
                _buildDataContribution(isDark, languageProvider),
                const SizedBox(height: Constants.space5),

                _buildDivider(isDark),

                const SizedBox(height: Constants.space3),

                // Yenile butonu
                _buildRefreshButton(isDark, languageProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Sade ana bölüm
  Widget _buildSimpleMainSection(bool isToday, bool isDark, LanguageProvider languageProvider) {
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
          isToday 
            ? Localization.getCurrentText('empty_today_title', languageProvider.currentLanguageCode)
            : Localization.getCurrentText('empty_not_found_title', languageProvider.currentLanguageCode),
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
            ? Localization.getCurrentText('empty_today_desc', languageProvider.currentLanguageCode)
            : '${_getLocalizedDate(widget.selectedDate, languageProvider)} ${Localization.getCurrentText('empty_date_desc', languageProvider.currentLanguageCode)}',
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
  Widget _buildDataContribution(bool isDark, LanguageProvider languageProvider) {
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
                Localization.getCurrentText('data_contribution', languageProvider.currentLanguageCode),
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
          Localization.getCurrentText('data_contribution_desc', languageProvider.currentLanguageCode),
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
              Localization.getCurrentText('contact_us', languageProvider.currentLanguageCode),
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
  Widget _buildRefreshButton(bool isDark, LanguageProvider languageProvider) {
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
          _isRefreshing 
            ? Localization.getCurrentText('refreshing', languageProvider.currentLanguageCode)
            : Localization.getCurrentText('refresh', languageProvider.currentLanguageCode),
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

  /// Tarihi lokalize et
  String _getLocalizedDate(DateTime date, LanguageProvider languageProvider) {
    final locale = languageProvider.currentLanguageCode == 'tr' ? 'tr_TR' : 'en_US';
    return DateFormat('dd MMMM yyyy', locale).format(date);
  }
} 