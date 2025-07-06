import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yurttaye_mobile/providers/theme_provider.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? Constants.kykGray900 : Constants.kykGray50,
      appBar: _buildAppBar(context, isDark),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Constants.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, 'Uygulama Ayarları'),
            const SizedBox(height: Constants.space3),
            
            // Tema Ayarları
            _buildSettingsCard(
              context: context,
              isDark: isDark,
              child: Column(
                children: [
                  _buildSettingsItem(
                    context: context,
                    isDark: isDark,
                    icon: Icons.palette_rounded,
                    title: 'Tema',
                    subtitle: themeProvider.isDarkMode ? 'Koyu Tema' : 'Açık Tema',
                    trailing: Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        HapticFeedback.lightImpact();
                        themeProvider.toggleTheme();
                      },
                      activeThumbColor: Constants.kykPrimary,
                      activeTrackColor: Constants.kykPrimary.withValues(alpha: 0.5),
                    ),
                  ),
                  const Divider(height: 1),
                  _buildSettingsItem(
                    context: context,
                    isDark: isDark,
                    icon: Icons.notifications_rounded,
                    title: 'Bildirimler',
                    subtitle: 'Yemek hatırlatıcıları',
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {
                        HapticFeedback.lightImpact();
                        // TODO: Implement notification settings
                      },
                      activeThumbColor: Constants.kykPrimary,
                      activeTrackColor: Constants.kykPrimary.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: Constants.space4),
            _buildSectionTitle(context, 'Hakkında'),
            const SizedBox(height: Constants.space3),
            
            // Hakkında Kartı
            _buildSettingsCard(
              context: context,
              isDark: isDark,
              child: Column(
                children: [
                  _buildSettingsItem(
                    context: context,
                    isDark: isDark,
                    icon: Icons.info_rounded,
                    title: 'Uygulama Versiyonu',
                    subtitle: '1.0.0',
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _showVersionInfo(context);
                    },
                  ),
                  const Divider(height: 1),
                  _buildSettingsItem(
                    context: context,
                    isDark: isDark,
                    icon: Icons.privacy_tip_rounded,
                    title: 'Gizlilik Politikası',
                    subtitle: 'Kullanım şartları',
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _showPrivacyPolicy(context);
                    },
                  ),
                  const Divider(height: 1),
                  _buildSettingsItem(
                    context: context,
                    isDark: isDark,
                    icon: Icons.language_rounded,
                    title: 'Website',
                    subtitle: 'yurttaye.com',
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _launchWebsite();
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: Constants.space4),
            _buildSectionTitle(context, 'Geliştirici'),
            const SizedBox(height: Constants.space3),
            
            // Geliştirici Kartı
            _buildSettingsCard(
              context: context,
              isDark: isDark,
              child: Column(
                children: [
                  _buildSettingsItem(
                    context: context,
                    isDark: isDark,
                    icon: Icons.code_rounded,
                    title: 'GitHub',
                    subtitle: 'Kaynak kod',
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _launchGitHub();
                    },
                  ),
                  const Divider(height: 1),
                  _buildSettingsItem(
                    context: context,
                    isDark: isDark,
                    icon: Icons.bug_report_rounded,
                    title: 'Hata Bildir',
                    subtitle: 'Sorun bildir',
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _reportBug(context);
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: Constants.space6),
            
            // Alt bilgi
            Center(
              child: Text(
                'YurttaYe v1.0.0',
                style: GoogleFonts.inter(
                  fontSize: Constants.textSm,
                  color: isDark ? Constants.kykGray400 : Constants.kykGray500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      backgroundColor: isDark ? Constants.kykGray800 : Constants.kykPrimary,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Ayarlar',
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
        onPressed: () => context.pop(),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: Constants.textLg,
        fontWeight: FontWeight.w700,
        color: isDark ? Constants.kykGray200 : Constants.kykGray800,
      ),
    );
  }

  Widget _buildSettingsCard({
    required BuildContext context,
    required bool isDark,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Constants.kykGray800 : Constants.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Constants.kykGray700 : Constants.kykGray200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withOpacity(0.3)
                : Constants.kykGray400.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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

  void _showVersionInfo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Constants.kykGray800 : Constants.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Uygulama Bilgileri',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: isDark ? Constants.kykGray200 : Constants.kykGray800,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Versiyon', '1.0.0'),
            _buildInfoRow('Geliştirici', 'YurttaYe Team'),
            _buildInfoRow('Platform', 'Flutter'),
            _buildInfoRow('Lisans', 'MIT'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Tamam',
              style: GoogleFonts.inter(
                color: Constants.kykPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: Constants.textSm,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: Constants.textSm,
              fontWeight: FontWeight.w600,
              color: Constants.kykPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Constants.kykGray800 : Constants.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Gizlilik Politikası',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: isDark ? Constants.kykGray200 : Constants.kykGray800,
          ),
        ),
        content: Text(
          'YurttaYe uygulaması, kullanıcı gizliliğinizi korumaya önem verir. Kişisel verileriniz güvenli bir şekilde saklanır ve üçüncü taraflarla paylaşılmaz.',
          style: GoogleFonts.inter(
            fontSize: Constants.textSm,
            color: isDark ? Constants.kykGray300 : Constants.kykGray700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Anladım',
              style: GoogleFonts.inter(
                color: Constants.kykPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchWebsite() async {
    const url = 'https://yurttaye.com';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Future<void> _launchGitHub() async {
    const url = 'https://github.com/yurttaye/yurttaye-mobile';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _reportBug(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Constants.kykGray800 : Constants.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Hata Bildir',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: isDark ? Constants.kykGray200 : Constants.kykGray800,
          ),
        ),
        content: Text(
          'Hata bildirimi için GitHub üzerinden issue açabilir veya e-posta gönderebilirsiniz.',
          style: GoogleFonts.inter(
            fontSize: Constants.textSm,
            color: isDark ? Constants.kykGray300 : Constants.kykGray700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'İptal',
              style: GoogleFonts.inter(
                color: isDark ? Constants.kykGray400 : Constants.kykGray600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _launchGitHub();
            },
            child: Text(
              'GitHub',
              style: GoogleFonts.inter(
                color: Constants.kykPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 