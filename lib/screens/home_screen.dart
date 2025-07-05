import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/providers/theme_provider.dart';
import 'package:yurttaye_mobile/utils/config.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/widgets/error_widget.dart';
import 'package:yurttaye_mobile/widgets/meal_card.dart';
import 'package:yurttaye_mobile/widgets/shimmer_loading.dart';
import 'package:intl/intl.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/widgets/upcoming_meal_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedMealIndex = 0;
  DateTime _selectedDate = DateTime.now();
  double _opacity = 1.0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Pulse animasyonu için controller
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Pulse animasyonunu başlat
    _pulseController.repeat(reverse: true);
    
    // Saat algılama ile otomatik yemek türü seçimi
    _selectMealTypeByTime();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MenuProvider>(context, listen: false);
      provider.fetchCities();
      provider.fetchMenus(reset: true, initialLoad: true);
      print('Initiating fetchMenus from HomeScreen initState');
    });
  }

  void _selectMealTypeByTime() {
    final now = DateTime.now();
    final hour = now.hour;
    
    // 13:00'dan sonra akşam yemeği, 00:00'dan sonra kahvaltı
    if (hour >= 13 || hour < 6) {
      setState(() {
        _selectedMealIndex = 1; // Akşam yemeği
      });
    } else {
      setState(() {
        _selectedMealIndex = 0; // Kahvaltı
      });
    }
  }

  void _changeDate(bool isNext) {
    final provider = Provider.of<MenuProvider>(context, listen: false);
    final selectedMealType = AppConfig.mealTypes[_selectedMealIndex];
    final newDate = isNext
        ? _selectedDate.add(const Duration(days: 1))
        : _selectedDate.subtract(const Duration(days: 1));
    
    // Geçmiş tarihe geçiş yapılacaksa, o tarihte menü var mı kontrol et
    if (!isNext) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final newDay = DateTime(newDate.year, newDate.month, newDate.day);
      
      if (newDay.isBefore(today)) {
        // Geçmiş tarihte menü var mı kontrol et
        final hasMenuInPast = provider.menus.any((menu) =>
            AppConfig.apiDateFormat.format(menu.date) == AppConfig.apiDateFormat.format(newDate) &&
            menu.mealType == selectedMealType);
        
        if (!hasMenuInPast) {
          // Geçmiş tarihte menü yoksa geçiş yapma
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Bu tarihte menü bulunmuyor',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
              backgroundColor: Constants.kykAccent,
            ),
          );
          return;
        }
      }
    }
    
    setState(() {
      _opacity = 0.5;
      _selectedDate = newDate;
    });
    print('Date changed to: ${AppConfig.apiDateFormat.format(_selectedDate)}');
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => _opacity = 1.0);
    });
    
    if (!provider.menus.any((menu) =>
    AppConfig.apiDateFormat.format(menu.date) ==
        AppConfig.apiDateFormat.format(_selectedDate))) {
      provider.fetchMenus(reset: false);
      print('Fetching menus for new date: ${AppConfig.apiDateFormat.format(_selectedDate)}');
    }
  }

  bool _hasPreviousMenu(MenuProvider provider, String selectedMealType) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Geçmiş tarihlerde sadece menü varsa true döndür
    return provider.menus.any((menu) =>
        menu.date.isBefore(_selectedDate) && 
        menu.mealType == selectedMealType &&
        DateTime(menu.date.year, menu.date.month, menu.date.day).isBefore(today) &&
        menu.id != 0); // Boş menü değilse
  }

  bool _hasNextMenu(MenuProvider provider, String selectedMealType) {
    return provider.menus.any((menu) =>
    menu.date.isAfter(_selectedDate) && menu.mealType == selectedMealType);
  }

  Future<void> _launchWebsite() async {
    const String urlString = 'https://yurttaye.onrender.com/';
    final Uri url = Uri.parse(urlString);
    try {
      bool canLaunch = await canLaunchUrl(url);

      bool launched = false;
      if (!kIsWeb && canLaunch) {
        launched = await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      }

      if (!launched) {
        if (kIsWeb || canLaunch) {
          launched = await launchUrl(
            url,
            mode: LaunchMode.platformDefault,
          );
        } else {
          throw 'No browser available to launch $urlString';
        }
      }

      if (!launched) {
        throw 'Failed to launch $urlString';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Website açılamadı: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _launchEmail() async {
    const String email = 'bulutsoftdev@gmail.com';
    const String subject = 'YurttaYe - Menü Veri Katkısı';
    const String body = '''Merhaba,

YurttaYe uygulaması için menü verisi katkısında bulunmak istiyorum.

Şehir: 
Tarih: 
Öğün Türü: 
Menü Detayları:

Teşekkürler!''';

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );

    try {
      bool canLaunch = await canLaunchUrl(emailUri);
      if (canLaunch) {
        await launchUrl(emailUri);
      } else {
        // Email uygulaması yoksa, email adresini kopyala
        await Clipboard.setData(const ClipboardData(text: email));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Email adresi kopyalandı: $email',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
              backgroundColor: Constants.kykPrimary,
              action: SnackBarAction(
                label: 'Tamam',
                textColor: Constants.white,
                onPressed: () {},
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Email açılamadı: $e',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
            backgroundColor: Constants.kykPrimary,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MenuProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final selectedMealType = AppConfig.mealTypes[_selectedMealIndex];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);

    final isPast = selectedDay.isBefore(today);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Constants.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.restaurant_menu,
                color: Constants.white,
                size: 20,
              ),
            ),
            const SizedBox(width: Constants.space2),
            Text(
              'YurttaYe',
              style: GoogleFonts.inter(
                fontSize: Constants.textXl,
                fontWeight: FontWeight.w700,
                color: Constants.white,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Constants.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.language,
              color: Constants.white,
              size: 20,
            ),
          ),
          tooltip: 'Website\'yi Ziyaret Et',
          onPressed: _launchWebsite,
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Constants.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                themeProvider.isDarkMode ? Icons.brightness_7 : Icons.brightness_4,
                color: Constants.white,
                size: 20,
              ),
            ),
            tooltip: themeProvider.isDarkMode ? 'Açık Tema' : 'Koyu Tema',
            onPressed: () {
              themeProvider.toggleTheme();
              print('Theme toggled: ${themeProvider.isDarkMode ? 'Dark' : 'Light'}');
            },
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Constants.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.filter_list,
                color: Constants.white,
                size: 20,
              ),
            ),
            tooltip: 'Filtrele',
            onPressed: () => context.pushNamed('filter'),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Constants.kykPrimary.withOpacity(0.1),
              Constants.white,
            ],
          ),
        ),
        child: isPast
            ? _buildPastDateContent(provider, selectedMealType, screenWidth)
            : provider.isLoading && provider.menus.isEmpty && provider.allMenus.isEmpty
                ? const ShimmerLoading()
                : provider.error != null
                    ? AppErrorWidget(
                        error: provider.error!,
                        onRetry: () {
                          provider.fetchMenus(reset: true);
                        },
                      )
                    : provider.menus.isEmpty && provider.allMenus.isEmpty
                        ? _buildEmptyState(context, provider)
                        : RefreshIndicator(
                            onRefresh: () async {
                              await provider.fetchMenus(reset: true);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: 60.0 + MediaQuery.of(context).padding.bottom,
                              ),
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildTodayMealCard(provider, selectedMealType, screenWidth),
                                    const SizedBox(height: Constants.space6),
                                  ],
                                ),
                              ),
                            ),
                          ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: themeProvider.isDarkMode ? Constants.kykGray800 : Constants.white,
          boxShadow: [
            BoxShadow(
              color: Constants.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: Constants.space2, vertical: Constants.space2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Kahvaltı butonu
                Expanded(
                  child: _buildMealTypeButton(
                    icon: Icons.breakfast_dining_rounded,
                    label: 'Kahvaltı',
                    isSelected: _selectedMealIndex == 0,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _opacity = 0.5;
                        _selectedMealIndex = 0;
                      });
                      Future.delayed(const Duration(milliseconds: 300), () {
                        setState(() => _opacity = 1.0);
                      });
                    },
                  ),
                ),
                
                // Ortadaki filtre butonu
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: Constants.space2),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        // Özel animasyon efekti
                        _pulseController.stop();
                        _pulseController.forward().then((_) {
                          _pulseController.repeat(reverse: true);
                        });
                        
                        context.pushNamed('filter');
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Ink(
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Constants.kykPrimary, Constants.kykPrimary.withOpacity(0.8)],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Constants.kykPrimary.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.filter_list_rounded,
                                  color: Constants.white,
                                  size: 20,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Akşam butonu
                Expanded(
                  child: _buildMealTypeButton(
                    icon: Icons.dinner_dining_rounded,
                    label: 'Akşam',
                    isSelected: _selectedMealIndex == 1,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _opacity = 0.5;
                        _selectedMealIndex = 1;
                      });
                      Future.delayed(const Duration(milliseconds: 300), () {
                        setState(() => _opacity = 1.0);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, MenuProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Constants.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(Constants.space6),
              decoration: BoxDecoration(
                color: Constants.kykGray100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.restaurant_menu,
                size: Constants.text2xl * 2,
                color: Constants.kykPrimary,
              ),
            ),
            const SizedBox(height: Constants.space4),
            Text(
              'Henüz menü bulunamadı',
              style: GoogleFonts.inter(
                fontSize: Constants.textXl,
                fontWeight: FontWeight.w600,
                color: Constants.kykGray700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Constants.space2),
            Text(
              '${DateFormat('dd MMMM yyyy').format(_selectedDate)} tarihi için henüz veri girişi yapılmadı.',
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
                    onPressed: () => _launchEmail(),
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
            
            const SizedBox(height: Constants.space4),
            ElevatedButton.icon(
              onPressed: () {
                provider.fetchMenus(reset: true);
              },
              icon: const Icon(Icons.refresh),
              label: Text(
                'Tekrar Dene',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: Constants.space6,
                  vertical: Constants.space3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayMealCard(
      MenuProvider provider,
      String selectedMealType,
      double screenWidth,
      ) {
    final today = AppConfig.apiDateFormat.format(_selectedDate);
    final menu = provider.menus.firstWhere(
          (menu) =>
      AppConfig.apiDateFormat.format(menu.date) == today && menu.mealType == selectedMealType,
      orElse: () => provider.menus.firstWhere(
            (menu) => AppConfig.apiDateFormat.format(menu.date) == today,
        orElse: () => provider.menus.isNotEmpty
            ? provider.menus.first
            : Menu(
          id: 0,
          cityId: 0,
          mealType: '',
          date: _selectedDate,
          energy: '',
          items: [],
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.space4,
        vertical: Constants.space2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(Constants.space3),
            decoration: BoxDecoration(
              color: Constants.white,
              borderRadius: BorderRadius.circular(12),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: _hasPreviousMenu(provider, selectedMealType)
                        ? Constants.kykPrimary
                        : Constants.kykGray400,
                    size: 20,
                  ),
                  onPressed: _hasPreviousMenu(provider, selectedMealType)
                      ? () => _changeDate(false)
                      : null,
                  tooltip: 'Önceki Gün',
                ),
                Column(
                  children: [
                    Text(
                      DateFormat('dd MMM yyyy').format(_selectedDate),
                      style: GoogleFonts.inter(
                        fontSize: Constants.textLg,
                        fontWeight: FontWeight.w600,
                        color: Constants.kykPrimary,
                      ),
                    ),
                    Text(
                      DateFormat('EEEE').format(_selectedDate),
                      style: GoogleFonts.inter(
                        fontSize: Constants.textSm,
                        fontWeight: FontWeight.w500,
                        color: Constants.kykGray500,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: _hasNextMenu(provider, selectedMealType)
                        ? Constants.kykPrimary
                        : Constants.kykGray400,
                    size: 20,
                  ),
                  onPressed: _hasNextMenu(provider, selectedMealType)
                      ? () => _changeDate(true)
                      : null,
                  tooltip: 'Sonraki Gün',
                ),
              ],
            ),
          ),
          const SizedBox(height: Constants.space3),
          AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 300),
            child: menu.id == 0
                ? _buildNoMenuCard(context, selectedMealType)
                : MealCard(menu: menu),
          ),
        ],
      ),
    );
  }

  Widget _buildNoMenuCard(BuildContext context, String selectedMealType) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Constants.space4),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(Constants.space3),
              decoration: BoxDecoration(
                color: Constants.kykGray100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.info_outline,
                size: Constants.textXl,
                color: Constants.kykPrimary,
              ),
            ),
            const SizedBox(height: Constants.space3),
            Text(
              'Menü Bulunamadı',
              style: GoogleFonts.inter(
                fontSize: Constants.textLg,
                fontWeight: FontWeight.w600,
                color: Constants.kykGray700,
              ),
            ),
            const SizedBox(height: Constants.space2),
            Text(
              '${DateFormat('dd MMMM yyyy').format(_selectedDate)} tarihi için henüz veri girişi yapılmadı.',
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
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingMeals(
      MenuProvider provider,
      String selectedMealType,
      double screenWidth,
      ) {
    final upcomingMenus = provider.allMenus
        .where((menu) =>
    menu.date.isAfter(_selectedDate) && menu.mealType == selectedMealType)
        .take(3)
        .toList();

    if (upcomingMenus.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.space4,
        vertical: Constants.space2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gelecek Günler',
            style: GoogleFonts.inter(
              fontSize: Constants.textLg,
              fontWeight: FontWeight.w600,
              color: Constants.kykPrimary,
            ),
          ),
          const SizedBox(height: Constants.space3),
          ...upcomingMenus.map((menu) => Padding(
            padding: const EdgeInsets.only(bottom: Constants.space2),
            child: UpcomingMealCard(menu: menu),
          )),
        ],
      ),
    );
  }

  Widget _buildPastDateContent(MenuProvider provider, String selectedMealType, double screenWidth) {
    // Seçili tarihte menü var mı kontrol et
    final today = AppConfig.apiDateFormat.format(_selectedDate);
    final hasMenuForSelectedDate = provider.menus.any((menu) =>
        AppConfig.apiDateFormat.format(menu.date) == today && 
        menu.mealType == selectedMealType);

    if (hasMenuForSelectedDate) {
      // Menü varsa normal şekilde göster
      return RefreshIndicator(
        onRefresh: () async {
          await provider.fetchMenus(reset: true);
        },
        child: Padding(
          padding: EdgeInsets.only(
            bottom: 60.0 + MediaQuery.of(context).padding.bottom,
          ),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTodayMealCard(provider, selectedMealType, screenWidth),
                _buildUpcomingMeals(provider, selectedMealType, screenWidth),
                const SizedBox(height: Constants.space6),
              ],
            ),
          ),
        ),
      );
    } else {
      // Menü yoksa sadece bulutsoftdev mesajını göster
      return _buildEmptyState(context, provider);
    }
  }

  Widget _buildMealTypeButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Constants.kykPrimary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: isSelected ? Constants.kykPrimary : Constants.kykGray200,
                borderRadius: BorderRadius.circular(6),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: Constants.kykPrimary.withOpacity(0.3),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ] : null,
              ),
              child: Icon(
                icon,
                color: isSelected ? Constants.white : Constants.kykGray600,
                size: 18,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Constants.kykPrimary : Constants.kykGray600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}