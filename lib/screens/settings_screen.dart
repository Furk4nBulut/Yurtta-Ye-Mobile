import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yurttaye_mobile/providers/language_provider.dart';
import 'package:yurttaye_mobile/providers/theme_provider.dart';
import 'package:yurttaye_mobile/services/notification_service.dart';
import 'package:yurttaye_mobile/services/notification_test.dart';
import 'package:yurttaye_mobile/utils/app_config.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/utils/localization.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final NotificationService _notificationService = NotificationService();
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final enabled = await _notificationService.areNotificationsEnabled();
    setState(() {
      _notificationsEnabled = enabled;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    await _notificationService.setNotificationsEnabled(value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final languageCode = languageProvider.currentLanguageCode;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? Constants.kykGray900 : Constants.kykGray50,
      appBar: _buildAppBar(context, isDark, languageProvider),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Constants.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, Localization.getText('app_settings', languageCode)),
            const SizedBox(height: Constants.space3),
            
            // Tema ve Dil Ayarları
            _buildSettingsCard(
              context: context,
              isDark: isDark,
              child: Column(
                children: [
                  _buildSettingsItem(
                    context: context,
                    isDark: isDark,
                    icon: Icons.palette_rounded,
                    title: Localization.getText('theme', languageCode),
                    subtitle: themeProvider.isDarkMode 
                        ? Localization.getText('dark_theme', languageCode)
                        : Localization.getText('light_theme', languageCode),
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
                    icon: Icons.language_rounded,
                    title: Localization.getText('language', languageCode),
                    subtitle: languageProvider.currentLanguageName,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _showLanguageSelector(context, languageProvider);
                    },
                  ),
                  const Divider(height: 1),
                  _buildSettingsItem(
                    context: context,
                    isDark: isDark,
                    icon: Icons.notifications_rounded,
                    title: Localization.getText('notifications', languageCode),
                    subtitle: Localization.getText('meal_reminders', languageCode),
                    trailing: Switch(
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        HapticFeedback.lightImpact();
                        _toggleNotifications(value);
                      },
                      activeThumbColor: Constants.kykPrimary,
                      activeTrackColor: Constants.kykPrimary.withValues(alpha: 0.5),
                    ),
                  ),
                  const Divider(height: 1),
                  _buildSettingsItem(
                    context: context,
                    isDark: isDark,
                    icon: Icons.science_rounded,
                    title: 'Test Bildirimi',
                    subtitle: 'Bildirim sistemini test et',
                    onTap: () {
                      HapticFeedback.lightImpact();
                      NotificationTest.showTestDialog(context);
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: Constants.space4),
            _buildSectionTitle(context, Localization.getText('links', languageCode)),
            const SizedBox(height: Constants.space3),
            
            // Bağlantılar Kartı
            _buildSettingsCard(
              context: context,
              isDark: isDark,
              child: Column(
                children: [
                  _buildSettingsItem(
                    context: context,
                    isDark: isDark,
                    icon: Icons.language_rounded,
                    title: Localization.getText('website', languageCode),
                    subtitle: Localization.getText('website_subtitle', languageCode),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _launchWebsite();
                    },
                  ),
                  const Divider(height: 1),
                  _buildSettingsItem(
                    context: context,
                    isDark: isDark,
                    icon: Icons.code_rounded,
                    title: Localization.getText('github', languageCode),
                    subtitle: Localization.getText('source_code', languageCode),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _launchGitHub();
                    },
                  ),
                  const Divider(height: 1),
                  _buildSettingsItem(
                    context: context,
                    isDark: isDark,
                    icon: Icons.play_circle_rounded,
                    title: Localization.getText('google_play', languageCode),
                    subtitle: Localization.getText('rate_app', languageCode),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _launchGooglePlay();
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: Constants.space4),
            _buildSectionTitle(context, Localization.getText('about', languageCode)),
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
                    title: Localization.getText('app_version', languageCode),
                    subtitle: '${AppConfig.appVersion} (${AppConfig.appBuildNumber})',
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _showVersionInfo(context, languageProvider);
                    },
                  ),
                  const Divider(height: 1),
                  _buildSettingsItem(
                    context: context,
                    isDark: isDark,
                    icon: Icons.privacy_tip_rounded,
                    title: Localization.getText('privacy_policy', languageCode),
                    subtitle: Localization.getText('terms_of_use', languageCode),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _showPrivacyPolicy(context, languageProvider);
                    },
                  ),
                  const Divider(height: 1),
                  _buildSettingsItem(
                    context: context,
                    isDark: isDark,
                    icon: Icons.bug_report_rounded,
                    title: Localization.getText('report_bug', languageCode),
                    subtitle: Localization.getText('report_issue', languageCode),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _reportBug(context, languageProvider);
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: Constants.space4),
            _buildSectionTitle(context, Localization.getText('developer', languageCode)),
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
                    icon: Icons.person_rounded,
                    title: Localization.getText('developer', languageCode),
                    subtitle: AppConfig.developerName,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _showDeveloperInfo(context, languageProvider);
                    },
                  ),
                  const Divider(height: 1),
                  _buildSettingsItem(
                    context: context,
                    isDark: isDark,
                    icon: Icons.business_rounded,
                    title: Localization.getText('company', languageCode),
                    subtitle: AppConfig.developerCompany,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _launchDeveloperWebsite();
                    },
                  ),
                  const Divider(height: 1),
                  _buildSettingsItem(
                    context: context,
                    isDark: isDark,
                    icon: Icons.email_rounded,
                    title: Localization.getText('contact', languageCode),
                    subtitle: AppConfig.developerEmail,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _launchEmail();
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: Constants.space6),
            
            // Alt bilgi
            Center(
              child: Column(
                children: [
                  Text(
                    '${AppConfig.appName} v${AppConfig.appVersion}',
                    style: GoogleFonts.inter(
                      fontSize: Constants.textSm,
                      color: isDark ? Constants.kykGray400 : Constants.kykGray500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '© 2025 ${AppConfig.developerCompany}',
                    style: GoogleFonts.inter(
                      fontSize: Constants.textXs,
                      color: isDark ? Constants.kykGray500 : Constants.kykGray400,
                      fontWeight: FontWeight.w400,
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

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark, LanguageProvider languageProvider) {
    return AppBar(
      backgroundColor: isDark ? Constants.kykGray800 : Constants.kykPrimary,
      elevation: 0,
      centerTitle: true,
              title: Text(
          Localization.getText('settings', languageProvider.currentLanguageCode),
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

  void _showLanguageSelector(BuildContext context, LanguageProvider languageProvider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? Constants.kykGray800 : Constants.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Constants.kykGray600 : Constants.kykGray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
                              child: Text(
                  Localization.getText('select_language', languageProvider.currentLanguageCode),
                style: GoogleFonts.inter(
                  fontSize: Constants.textLg,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Constants.kykGray200 : Constants.kykGray800,
                ),
              ),
            ),
            ...languageProvider.supportedLanguages.map((language) {
              final isSelected = language['code'] == languageProvider.currentLanguageCode;
              return ListTile(
                leading: Text(
                  language['flag']!,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(
                  language['name']!,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    color: isDark ? Constants.kykGray200 : Constants.kykGray800,
                  ),
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: Constants.kykPrimary,
                        size: 24,
                      )
                    : null,
                onTap: () {
                  languageProvider.changeLanguage(language['code']!);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showVersionInfo(BuildContext context, LanguageProvider languageProvider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Constants.kykGray800 : Constants.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          Localization.getText('app_info', languageProvider.currentLanguageCode),
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: isDark ? Constants.kykGray200 : Constants.kykGray800,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Localization.getText('name', languageProvider.currentLanguageCode), AppConfig.appName),
            _buildInfoRow(Localization.getText('version', languageProvider.currentLanguageCode), AppConfig.appVersion),
            _buildInfoRow(Localization.getText('build', languageProvider.currentLanguageCode), AppConfig.appBuildNumber),
            _buildInfoRow(Localization.getText('developer', languageProvider.currentLanguageCode), AppConfig.developerName),
            _buildInfoRow(Localization.getText('platform', languageProvider.currentLanguageCode), 'Flutter'),
            _buildInfoRow(Localization.getText('license', languageProvider.currentLanguageCode), 'MIT'),
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

  void _showPrivacyPolicy(BuildContext context, LanguageProvider languageProvider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Constants.kykGray800 : Constants.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          Localization.getText('privacy_policy', languageProvider.currentLanguageCode),
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
              Localization.getText('understood', languageProvider.currentLanguageCode),
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

  void _showDeveloperInfo(BuildContext context, LanguageProvider languageProvider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Constants.kykGray800 : Constants.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          Localization.getText('developer_info', languageProvider.currentLanguageCode),
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: isDark ? Constants.kykGray200 : Constants.kykGray800,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Localization.getText('name', languageProvider.currentLanguageCode), AppConfig.developerName),
            _buildInfoRow(Localization.getText('company', languageProvider.currentLanguageCode), AppConfig.developerCompany),
            _buildInfoRow(Localization.getText('email', languageProvider.currentLanguageCode), AppConfig.developerEmail),
            _buildInfoRow('Website', 'yurttaye.onrender.com'),
            _buildInfoRow('GitHub', 'github.com/bulutsoft-dev'),
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

  Future<void> _launchWebsite() async {
    if (await canLaunchUrl(Uri.parse(AppConfig.websiteUrl))) {
      await launchUrl(Uri.parse(AppConfig.websiteUrl));
    }
  }

  Future<void> _launchGitHub() async {
    if (await canLaunchUrl(Uri.parse(AppConfig.githubUrl))) {
      await launchUrl(Uri.parse(AppConfig.githubUrl));
    }
  }

  Future<void> _launchGooglePlay() async {
    if (await canLaunchUrl(Uri.parse(AppConfig.googlePlayUrl))) {
      await launchUrl(Uri.parse(AppConfig.googlePlayUrl));
    }
  }

  Future<void> _launchDeveloperWebsite() async {
    if (await canLaunchUrl(Uri.parse(AppConfig.websiteUrl))) {
      await launchUrl(Uri.parse(AppConfig.websiteUrl));
    }
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: AppConfig.developerEmail,
      query: 'subject=YurttaYe Uygulama Desteği',
    );
    
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _reportBug(BuildContext context, LanguageProvider languageProvider) {
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
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _launchEmail();
            },
            child: Text(
              'E-posta',
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