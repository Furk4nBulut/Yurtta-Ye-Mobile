import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/services/ad_service.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/utils/localization.dart';
import 'package:yurttaye_mobile/providers/language_provider.dart';
import 'package:yurttaye_mobile/widgets/banner_ad_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class AdsScreen extends StatefulWidget {
  const AdsScreen({Key? key}) : super(key: key);

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  int _coins = 0;
  int _totalCoins = 0;
  DateTime? _adFreeUntil;
  bool _isLoadingCoin = true;
  DateTime? _bannerBlockUntil;
  DateTime? _interstitialBlockUntil;
  int _adsWatched = 0;

  static const int coinsRequired = 4; // 4 coin = 1 gün reklamsız
  static const int bannerBlockCost = 1;
  static const int interstitialBlockCost = 1;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadCoinState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {}); // Süreleri güncelle
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadCoinState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coins = prefs.getInt('coins') ?? 0;
      _totalCoins = prefs.getInt('totalCoins') ?? 0;
      final adFreeMillis = prefs.getInt('adFreeUntil');
      _adFreeUntil = adFreeMillis != null ? DateTime.fromMillisecondsSinceEpoch(adFreeMillis) : null;
      final bannerMillis = prefs.getInt('bannerAdBlockUntil');
      _bannerBlockUntil = bannerMillis != null ? DateTime.fromMillisecondsSinceEpoch(bannerMillis) : null;
      final interstitialMillis = prefs.getInt('interstitialAdBlockUntil');
      _interstitialBlockUntil = interstitialMillis != null ? DateTime.fromMillisecondsSinceEpoch(interstitialMillis) : null;
      _adsWatched = prefs.getInt('adsWatched') ?? 0;
      _isLoadingCoin = false;
    });
  }

  Future<void> _addCoin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coins++;
      _totalCoins++;
      _adsWatched++;
    });
    await prefs.setInt('coins', _coins);
    await prefs.setInt('totalCoins', _totalCoins);
    await prefs.setInt('adsWatched', _adsWatched);
  }

  Future<void> _blockBannerAds() async {
    if (_coins < bannerBlockCost) return;
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final current = _bannerBlockUntil != null && _bannerBlockUntil!.isAfter(now) ? _bannerBlockUntil! : now;
    final newUntil = current.add(const Duration(days: 1));
    setState(() {
      _coins -= bannerBlockCost;
      _bannerBlockUntil = newUntil;
    });
    await prefs.setInt('coins', _coins);
    await prefs.setInt('bannerAdBlockUntil', newUntil.millisecondsSinceEpoch);
  }

  Future<void> _blockInterstitialAds() async {
    if (_coins < interstitialBlockCost) return;
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final current = _interstitialBlockUntil != null && _interstitialBlockUntil!.isAfter(now) ? _interstitialBlockUntil! : now;
    final newUntil = current.add(const Duration(days: 1));
    setState(() {
      _coins -= interstitialBlockCost;
      _interstitialBlockUntil = newUntil;
    });
    await prefs.setInt('coins', _coins);
    await prefs.setInt('interstitialAdBlockUntil', newUntil.millisecondsSinceEpoch);
  }

  Future<void> _resetAdBlocks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _adFreeUntil = null;
      _bannerBlockUntil = null;
      _interstitialBlockUntil = null;
    });
    await prefs.remove('adFreeUntil');
    await prefs.remove('bannerAdBlockUntil');
    await prefs.remove('interstitialAdBlockUntil');
  }

  bool get _isBannerBlocked => _bannerBlockUntil != null && _bannerBlockUntil!.isAfter(DateTime.now());
  bool get _isInterstitialBlocked => _interstitialBlockUntil != null && _interstitialBlockUntil!.isAfter(DateTime.now());

  String get _bannerBlockTimeLeft {
    if (!_isBannerBlocked) return '';
    final diff = _bannerBlockUntil!.difference(DateTime.now());
    return _formatDuration(diff);
  }

  String get _interstitialBlockTimeLeft {
    if (!_isInterstitialBlocked) return '';
    final diff = _interstitialBlockUntil!.difference(DateTime.now());
    return _formatDuration(diff);
  }

  String _formatDuration(Duration diff) {
    if (diff.isNegative) return '0 saniye';
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;
    final seconds = diff.inSeconds % 60;
    final parts = <String>[];
    if (days > 0) parts.add('$days gün');
    if (hours > 0) parts.add('$hours saat');
    if (minutes > 0) parts.add('$minutes dakika');
    if (seconds > 0 || parts.isEmpty) parts.add('$seconds saniye');
    return parts.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final languageCode = languageProvider.currentLanguageCode;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Constants.kykGray800 : Constants.kykPrimary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          Localization.getText('ad_info_title', languageCode),
          style: GoogleFonts.inter(
            fontSize: Constants.textLg,
            fontWeight: FontWeight.w600,
            color: Constants.white,
          ),
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Constants.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Constants.white,
              size: 18,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Constants.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- EN BAŞTA TANITIM ---
            Text(
              Localization.getText('ad_info_about', languageCode),
              style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20, color: isDark ? Constants.kykGray100 : Constants.kykGray900),
            ),
            const SizedBox(height: 8),
            Text(
              Localization.getText('ad_info_about_desc', languageCode),
              style: GoogleFonts.inter(fontSize: 15, color: isDark ? Constants.kykGray300 : Constants.kykGray700),
            ),
            const SizedBox(height: 16),
            _infoRow(Icons.view_stream_rounded, Localization.getText('ad_info_banner', languageCode), Localization.getText('ad_info_banner_desc', languageCode)),
            const SizedBox(height: 8),
            _infoRow(Icons.flip_to_front_rounded, Localization.getText('ad_info_interstitial', languageCode), Localization.getText('ad_info_interstitial_desc', languageCode)),
            const SizedBox(height: 8),
            _infoRow(Icons.monetization_on_rounded, Localization.getText('ad_info_coin', languageCode), Localization.getText('ad_info_coin_desc', languageCode)),
            const SizedBox(height: 20),
            // 1. Reklamlar ve Coin Yönetimi başlığı
            _buildSectionTitle(context, Localization.getText('ads_section', languageCode), isDark),
            const SizedBox(height: Constants.space3),
            _buildSettingsCard(
              context: context,
              isDark: isDark,
              child: Column(
                children: [
                  // --- Reklam İzle, Coin Kazan ---
                  _buildSettingsItem(
                    context: context,
                    isDark: isDark,
                    icon: Icons.play_circle_fill_rounded,
                    title: Localization.getText('ad_info_watch_ad', languageCode),
                    subtitle: Localization.getText('ad_info_watch_ad_desc', languageCode),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.monetization_on_rounded, color: Constants.kykPrimary, size: 18),
                        const SizedBox(width: 4),
                        Text('$_coins', style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Constants.kykPrimary)),
                      ],
                    ),
                    onTap: _isLoadingCoin ? null : () async {
                      await AdService.showRewardedAd(
                        onRewarded: () async {
                          await _addCoin();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(Localization.getText('ad_info_thanks', languageCode)),
                                backgroundColor: Constants.kykSuccess,
                              ),
                            );
                          }
                        },
                        onClosed: () {},
                      );
                    },
                  ),
                  const Divider(height: 1),
                  // --- Banner Reklam Engelle ---
                  _buildSettingsItem(
                    context: context,
                    isDark: isDark,
                    icon: Icons.visibility_off_rounded,
                    title: Localization.getText('ad_info_block_banner', languageCode),
                    subtitle: Localization.getText('ad_info_block_banner_desc', languageCode) + ' ' + (_bannerBlockTimeLeft.isNotEmpty ? _bannerBlockTimeLeft : Localization.getText('ad_info_none', languageCode)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.monetization_on_rounded, color: _coins >= bannerBlockCost ? Constants.kykPrimary : Constants.kykGray400, size: 18),
                        const SizedBox(width: 4),
                        Text('$bannerBlockCost', style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: _coins >= bannerBlockCost ? Constants.kykPrimary : Constants.kykGray400)),
                      ],
                    ),
                    onTap: _isLoadingCoin || _coins < bannerBlockCost || _isBannerBlocked ? null : () async {
                      await _blockBannerAds();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(Localization.getText('ad_info_block_banner_success', languageCode)),
                            backgroundColor: Constants.kykSuccess,
                          ),
                        );
                      }
                    },
                  ),
                  const Divider(height: 1),
                  // --- Geçiş Reklam Engelle ---
                  _buildSettingsItem(
                    context: context,
                    isDark: isDark,
                    icon: Icons.block,
                    title: Localization.getText('ad_info_block_interstitial', languageCode),
                    subtitle: Localization.getText('ad_info_block_interstitial_desc', languageCode) + ' ' + (_interstitialBlockTimeLeft.isNotEmpty ? _interstitialBlockTimeLeft : Localization.getText('ad_info_none', languageCode)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.monetization_on_rounded, color: _coins >= interstitialBlockCost ? Constants.kykPrimary : Constants.kykGray400, size: 18),
                        const SizedBox(width: 4),
                        Text('$interstitialBlockCost', style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: _coins >= interstitialBlockCost ? Constants.kykPrimary : Constants.kykGray400)),
                      ],
                    ),
                    onTap: _isLoadingCoin || _coins < interstitialBlockCost || _isInterstitialBlocked ? null : () async {
                      await _blockInterstitialAds();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(Localization.getText('ad_info_block_interstitial_success', languageCode)),
                            backgroundColor: Constants.kykSuccess,
                          ),
                        );
                      }
                    },
                  ),
                  const Divider(height: 1),
                  // --- SÜRELERİ SIFIRLA BUTONU ---
                  _buildSettingsItem(
                    context: context,
                    isDark: isDark,
                    icon: Icons.refresh_rounded,
                    title: Localization.getText('ad_info_reset', languageCode),
                    subtitle: Localization.getText('ad_info_reset_confirm', languageCode),
                    onTap: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(Localization.getText('ad_info_reset', languageCode)),
                          content: Text(Localization.getText('ad_info_reset_confirm', languageCode)),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(Localization.getText('cancel', languageCode)),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text(Localization.getText('ad_info_reset', languageCode)),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        await _resetAdBlocks();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(Localization.getText('ad_info_reset_success', languageCode))),
                          );
                        }
                      }
                    },
                  ),
                  const Divider(height: 1),
                  // --- GELİŞTİRİCİYE DESTEK OL (Buy Me a Coffee) ---
                  _buildSettingsItem(
                    context: context,
                    isDark: isDark,
                    icon: Icons.coffee_rounded,
                    title: Localization.getText('ad_info_support', languageCode),
                    subtitle: Localization.getText('ad_info_support_desc', languageCode) + '\n' + '(Buy Me a Coffee: ' + Localization.getText('soon', languageCode) + ')',
                    onTap: null,
                  ),
                  const Divider(height: 1),
                  // --- HATA BİLDİRİMİ ---
                  _buildSettingsItem(
                    context: context,
                    isDark: isDark,
                    icon: Icons.bug_report_rounded,
                    title: Localization.getText('ad_info_bug', languageCode),
                    subtitle: Localization.getText('ad_info_bug_desc', languageCode),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('github.com/bulutsoft-dev | bulutsoftdev@gmail.com')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: Constants.space4),
            // --- UYARI ---
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border:Border.all(color: Colors.orange, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      Localization.getText('ad_info_warning_text', languageCode),
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.orange.shade900, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Constants.space4),
            // --- Açıklama ve banner reklam ---
            Text(
              Localization.getText('ads_section_explanation', languageCode),
              style: GoogleFonts.inter(fontSize: Constants.textXs, color: isDark ? Constants.kykGray400 : Constants.kykGray600),
            ),
            const SizedBox(height: Constants.space4),
            const Center(child: BannerAdWidget()),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Constants.kykPrimary, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15)),
              Text(desc, style: GoogleFonts.inter(fontSize: 13, color: Constants.kykGray500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, bool isDark) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: Constants.textLg,
        fontWeight: FontWeight.bold,
        color: isDark ? Constants.kykGray100 : Constants.kykGray900,
      ),
    );
  }

  Widget _buildSettingsCard({
    required BuildContext context,
    required bool isDark,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? Constants.kykGray800 : Constants.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.15) : Constants.kykGray400.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: isDark ? Constants.kykGray700 : Constants.kykGray200, width: 1),
      ),
      child: child,
    );
  }

  Widget _buildSettingsItem({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(Constants.space4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Constants.kykPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Constants.kykPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: Constants.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: Constants.textBase,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Constants.kykGray200 : Constants.kykGray800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: Constants.textSm,
                        color: isDark ? Constants.kykGray400 : Constants.kykGray600,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing,
              if (onTap != null && trailing == null)
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? Constants.kykGray400 : Constants.kykGray500,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
} 