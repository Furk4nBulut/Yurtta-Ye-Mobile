import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/utils/config.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/widgets/error_widget.dart';
import 'package:yurttaye_mobile/widgets/meal_card.dart';
import 'package:yurttaye_mobile/widgets/shimmer_loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> with SingleTickerProviderStateMixin {
  DateTime? _selectedDate;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  final ScrollController _scrollController = ScrollController();
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<MenuProvider>(context, listen: false);
      provider.fetchCities();
      await Future.delayed(const Duration(milliseconds: 300));
      provider.fetchMenus(reset: true);
      setState(() => _isInitialLoad = false);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
          !Provider.of<MenuProvider>(context, listen: false).isLoading &&
          Provider.of<MenuProvider>(context, listen: false).hasMore) {
        Provider.of<MenuProvider>(context, listen: false).fetchMenus();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MenuProvider>(context);
    return Scaffold(
      backgroundColor: Constants.kykGray50,
      appBar: AppBar(
        backgroundColor: Constants.kykPrimary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Filtrele',
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
        actions: [
          TextButton.icon(
            onPressed: () {
              provider.clearFilters();
              setState(() => _selectedDate = null);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Constants.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Filtreler sıfırlandı',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  backgroundColor: Constants.kykPrimary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            icon: const Icon(Icons.refresh, color: Constants.white, size: 18),
            label: Text(
              'Sıfırla',
              style: GoogleFonts.inter(
                color: Constants.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: _isInitialLoad
            ? const ShimmerLoading()
            : Container(
                color: Constants.kykGray50,
                child: Column(
                  children: [
                    // Filtre bölümü - Keskin köşeler
                    Container(
                      height: MediaQuery.of(context).size.height * 0.18,
                      color: Constants.kykGray50,
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          // Şehir ve Öğün Tipi yan yana
                          Row(
                            children: [
                              Expanded(
                                child: _buildSharpFilterSection(
                                  'Şehir',
                                  Icons.location_city,
                                  _buildEnhancedCityFilter(provider),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: _buildSharpFilterSection(
                                  'Öğün',
                                  Icons.restaurant_menu,
                                  _buildEnhancedMealTypeFilter(provider),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 0),
                          // Tarih seçici tam genişlik
                          _buildSharpFilterSection(
                            'Tarih',
                            Icons.calendar_today,
                            _buildEnhancedDateFilter(provider),
                          ),
                        ],
                      ),
                    ),
                    // Hiç boşluk yok
                    // Sonuçlar bölümü - Yukarıya dayalı
                    Expanded(
                      child: _buildSharpResultsSection(provider),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSharpFilterSection(String title, IconData icon, Widget content) {
    return Container(
      padding: EdgeInsets.only(left: 4, right: 4, top: 4, bottom: title == 'Tarih' ? 0 : 4),
      decoration: BoxDecoration(
        color: Constants.white,
        borderRadius: BorderRadius.zero,
        border: Border.all(
          color: Constants.kykGray200,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Constants.kykGray200.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Constants.kykPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.zero,
                ),
                child: Icon(
                  icon,
                  color: Constants.kykPrimary,
                  size: 10,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: Constants.textSm,
                  fontWeight: FontWeight.w600,
                  color: Constants.kykGray700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          content,
        ],
      ),
    );
  }

  Widget _buildEnhancedCityFilter(MenuProvider provider) {
    if (provider.cities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Constants.kykGray50,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation<Color>(Constants.kykPrimary),
              ),
            ),
            const SizedBox(width: 3),
            Text(
              'Yükleniyor...',
              style: GoogleFonts.inter(
                fontSize: Constants.textSm,
                color: Constants.kykGray500,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 26,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: provider.cities.length,
        itemBuilder: (context, index) {
          final city = provider.cities[index];
          final isSelected = provider.selectedCityId == city.id;
          return GestureDetector(
            onTap: () {
              provider.setSelectedCity(isSelected ? null : city.id);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 3),
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: isSelected ? Constants.kykPrimary : Constants.kykGray100,
                borderRadius: BorderRadius.zero,
                border: Border.all(
                  color: isSelected ? Constants.kykPrimary : Constants.kykGray200,
                  width: 0.5,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: Constants.kykPrimary.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ] : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_city,
                    size: 9,
                    color: isSelected ? Constants.white : Constants.kykGray600,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    city.name,
                    style: GoogleFonts.inter(
                      fontSize: Constants.textSm,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Constants.white : Constants.kykGray700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedMealTypeFilter(MenuProvider provider) {
    return SizedBox(
      height: 26,
      child: Row(
        children: AppConfig.mealTypes.map((mealType) {
          final isSelected = provider.selectedMealType == mealType;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                provider.setSelectedMealType(isSelected ? null : mealType);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 3,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Constants.kykAccent : Constants.kykGray100,
                  borderRadius: BorderRadius.zero,
                  border: Border.all(
                    color: isSelected ? Constants.kykAccent : Constants.kykGray200,
                    width: 0.5,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: Constants.kykAccent.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ] : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      mealType == 'Kahvaltı' ? Icons.breakfast_dining : Icons.dinner_dining,
                      size: 9,
                      color: isSelected ? Constants.white : Constants.kykGray600,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      mealType == 'Kahvaltı' ? 'Kahv' : 'Akş',
                      style: GoogleFonts.inter(
                        fontSize: Constants.textSm,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Constants.white : Constants.kykGray700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEnhancedDateFilter(MenuProvider provider) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: Constants.kykPrimary,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                setState(() => _selectedDate = picked);
                provider.setSelectedDate(AppConfig.apiDateFormat.format(picked));
              }
            },
            icon: const Icon(Icons.calendar_today, size: 10),
            label: Text(
              _selectedDate != null
                  ? DateFormat('dd/MM').format(_selectedDate!)
                  : 'Tarih',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: Constants.textSm,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Constants.kykPrimary,
              side: BorderSide(color: Constants.kykPrimary, width: 1),
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
        ),
        if (_selectedDate != null) ...[
          const SizedBox(width: 3),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: Constants.kykPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.zero,
              border: Border.all(
                color: Constants.kykPrimary.withOpacity(0.3),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Constants.kykPrimary,
                  size: 8,
                ),
                const SizedBox(width: 2),
                Text(
                  DateFormat('EEE').format(_selectedDate!),
                  style: GoogleFonts.inter(
                    fontSize: Constants.textSm,
                    fontWeight: FontWeight.w500,
                    color: Constants.kykPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSharpResultsSection(MenuProvider provider) {
    return Container(
      decoration: const BoxDecoration(
        color: Constants.white,
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        children: [
          // Başlık - Keskin köşeler
          Container(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
            decoration: const BoxDecoration(
              color: Constants.white,
              borderRadius: BorderRadius.zero,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Constants.kykPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Icon(
                    Icons.search,
                    color: Constants.kykPrimary,
                    size: 16,
                  ),
                ),
                const SizedBox(width: Constants.space2),
                Expanded(
                  child: Text(
                    'Filtrelenmiş Sonuçlar',
                    style: GoogleFonts.inter(
                      fontSize: Constants.textBase,
                      fontWeight: FontWeight.w600,
                      color: Constants.kykGray700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Constants.space2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Constants.kykPrimary,
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Text(
                    '${provider.menus.length}',
                    style: GoogleFonts.inter(
                      fontSize: Constants.textSm,
                      fontWeight: FontWeight.w600,
                      color: Constants.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Sonuçlar listesi
          Expanded(
            child: provider.isLoading && provider.menus.isEmpty
                ? const ShimmerLoading()
                : provider.error != null
                    ? AppErrorWidget(
                        error: provider.error!,
                        onRetry: () => provider.fetchMenus(reset: true),
                      )
                    : provider.menus.isEmpty
                        ? _buildEmptyResults()
                        : RefreshIndicator(
                            onRefresh: () async => provider.fetchMenus(reset: true),
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(
                                horizontal: Constants.space3,
                                vertical: Constants.space1,
                              ),
                              itemCount: provider.menus.length + (provider.hasMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == provider.menus.length) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(Constants.space3),
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: Constants.space2),
                                  child: MealCard(
                                    menu: provider.menus[index],
                                    onTap: () => context.pushNamed(
                                      'menu_detail',
                                      pathParameters: {'id': provider.menus[index].id.toString()},
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyResults() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Constants.space4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(Constants.space4),
              decoration: BoxDecoration(
                color: Constants.kykGray100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.search_off,
                size: Constants.textXl,
                color: Constants.kykPrimary,
              ),
            ),
            const SizedBox(height: Constants.space3),
            Text(
              'Sonuç Bulunamadı',
              style: GoogleFonts.inter(
                fontSize: Constants.textLg,
                fontWeight: FontWeight.w600,
                color: Constants.kykGray700,
              ),
            ),
            const SizedBox(height: Constants.space2),
            Text(
              _selectedDate != null
                  ? '${DateFormat('dd MMM yyyy').format(_selectedDate!)} tarihi için henüz veri girişi yapılmadı.'
                  : 'Seçilen kriterlere uygun sonuç bulunamadı.',
              style: GoogleFonts.inter(
                fontSize: Constants.textSm,
                color: Constants.kykGray500,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Constants.space3),

            // Veri katkısı mesajı - Daha kompakt
            Container(
              padding: const EdgeInsets.all(Constants.space3),
              decoration: BoxDecoration(
                color: Constants.kykAccent.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Constants.kykAccent.withOpacity(0.2),
                  width: 0.5,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Constants.kykAccent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.volunteer_activism,
                          color: Constants.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: Constants.space2),
                      Expanded(
                        child: Text(
                          'Veri Katkısı',
                          style: GoogleFonts.inter(
                            fontSize: Constants.textBase,
                            fontWeight: FontWeight.w600,
                            color: Constants.kykGray700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Constants.space2),
                  Text(
                    'Menü bilgisi varsa bize ulaşarak katkıda bulunabilirsiniz!',
                    style: GoogleFonts.inter(
                      fontSize: Constants.textSm,
                      color: Constants.kykGray600,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Constants.space2),
                  ElevatedButton.icon(
                    onPressed: () => _launchEmail(),
                    icon: const Icon(Icons.email, size: 16),
                    label: Text(
                      'Bize Ulaşın',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: Constants.textSm,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.kykAccent,
                      foregroundColor: Constants.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Constants.space3,
                        vertical: Constants.space1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
              content: Row(
                children: [
                  Icon(Icons.copy, color: Constants.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Email adresi kopyalandı: $email',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              backgroundColor: Constants.kykPrimary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
            content: Row(
              children: [
                Icon(Icons.error, color: Constants.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Email açılamadı',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            backgroundColor: Constants.kykPrimary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }
}