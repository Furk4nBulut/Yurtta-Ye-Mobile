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
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<MenuProvider>(context, listen: false);
      provider.fetchCities();
      await Future.delayed(const Duration(milliseconds: 500));
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
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = _selectedDate != null ? DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day) : today;
    final isPast = _selectedDate != null && selectedDay.isBefore(today);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Constants.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.filter_list,
                color: Constants.white,
                size: 18,
              ),
            ),
            const SizedBox(width: Constants.space2),
            Text(
              'Filtrele',
              style: GoogleFonts.inter(
                fontSize: Constants.textLg,
                fontWeight: FontWeight.w600,
                color: Constants.white,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Constants.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
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
                  content: Text(
                    'Filtreler sıfırlandı',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  ),
                  backgroundColor: Constants.kykPrimary,
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
            : isPast
                ? _buildPastDateWarning()
                : Column(
                    children: [
                      // Filtre bölümü
                      Expanded(
                        flex: 1,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(Constants.space4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFilterSection(
                                'Şehir Seç',
                                Icons.location_city,
                                _buildCityFilter(provider),
                              ),
                              const SizedBox(height: Constants.space6),
                              _buildFilterSection(
                                'Öğün Tipi',
                                Icons.restaurant_menu,
                                _buildMealTypeFilter(provider),
                              ),
                              const SizedBox(height: Constants.space6),
                              _buildFilterSection(
                                'Tarih Seç',
                                Icons.calendar_today,
                                _buildDateFilter(provider),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Sonuçlar bölümü
                      Expanded(
                        flex: 2,
                        child: _buildResultsSection(provider),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildFilterSection(String title, IconData icon, Widget content) {
    return Container(
      padding: const EdgeInsets.all(Constants.space4),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: Constants.textLg,
                  fontWeight: FontWeight.w600,
                  color: Constants.kykGray700,
                ),
              ),
            ],
          ),
          const SizedBox(height: Constants.space3),
          content,
        ],
      ),
    );
  }

  Widget _buildCityFilter(MenuProvider provider) {
    if (provider.cities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(Constants.space4),
        decoration: BoxDecoration(
          color: Constants.kykGray50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.hourglass_empty,
              size: 20,
              color: Constants.kykGray500,
            ),
            const SizedBox(width: Constants.space2),
            Text(
              'Şehirler yükleniyor...',
              style: GoogleFonts.inter(
                fontSize: Constants.textBase,
                color: Constants.kykGray500,
              ),
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: Constants.space2,
      runSpacing: Constants.space2,
      children: provider.cities.map((city) {
        final isSelected = provider.selectedCityId == city.id;
        return GestureDetector(
          onTap: () {
            provider.setSelectedCity(isSelected ? null : city.id);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Constants.space3,
              vertical: Constants.space2,
            ),
            decoration: BoxDecoration(
              color: isSelected ? Constants.kykPrimary : Constants.kykGray100,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Constants.kykPrimary : Constants.kykGray300,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_city,
                  size: 16,
                  color: isSelected ? Constants.white : Constants.kykGray600,
                ),
                const SizedBox(width: Constants.space2),
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
      }).toList(),
    );
  }

  Widget _buildMealTypeFilter(MenuProvider provider) {
    return Wrap(
      spacing: Constants.space2,
      runSpacing: Constants.space2,
      children: AppConfig.mealTypes.map((mealType) {
        final isSelected = provider.selectedMealType == mealType;
        return GestureDetector(
          onTap: () {
            provider.setSelectedMealType(isSelected ? null : mealType);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Constants.space3,
              vertical: Constants.space2,
            ),
            decoration: BoxDecoration(
              color: isSelected ? Constants.kykAccent : Constants.kykGray100,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Constants.kykAccent : Constants.kykGray300,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  mealType == 'Kahvaltı' ? Icons.breakfast_dining : Icons.dinner_dining,
                  size: 16,
                  color: isSelected ? Constants.white : Constants.kykGray600,
                ),
                const SizedBox(width: Constants.space2),
                Text(
                  mealType,
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
      }).toList(),
    );
  }

  Widget _buildDateFilter(MenuProvider provider) {
    return Column(
      children: [
        OutlinedButton.icon(
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
          icon: const Icon(Icons.calendar_today),
          label: Text(
            _selectedDate != null
                ? DateFormat('dd MMMM yyyy').format(_selectedDate!)
                : 'Tarih Seç',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: Constants.kykPrimary,
            side: BorderSide(color: Constants.kykPrimary, width: 1.5),
            padding: const EdgeInsets.symmetric(
              horizontal: Constants.space4,
              vertical: Constants.space3,
            ),
          ),
        ),
        if (_selectedDate != null) ...[
          const SizedBox(height: Constants.space3),
          Container(
            padding: const EdgeInsets.all(Constants.space3),
            decoration: BoxDecoration(
              color: Constants.kykPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Constants.kykPrimary,
                  size: 20,
                ),
                const SizedBox(width: Constants.space2),
                Text(
                  DateFormat('dd MMMM yyyy, EEEE').format(_selectedDate!),
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

  Widget _buildResultsSection(MenuProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Constants.kykGray50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Başlık
          Container(
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
                    Icons.search,
                    color: Constants.kykPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: Constants.space3),
                Expanded(
                  child: Text(
                    'Filtrelenmiş Sonuçlar',
                    style: GoogleFonts.inter(
                      fontSize: Constants.textLg,
                      fontWeight: FontWeight.w600,
                      color: Constants.kykGray700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Constants.space2,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Constants.kykPrimary,
                    borderRadius: BorderRadius.circular(12),
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
                                horizontal: Constants.space4,
                                vertical: Constants.space2,
                              ),
                              itemCount: provider.menus.length + (provider.hasMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == provider.menus.length) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(Constants.space4),
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: Constants.space3),
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
                Icons.search_off,
                size: Constants.text2xl * 2,
                color: Constants.kykPrimary,
              ),
            ),
            const SizedBox(height: Constants.space4),
            Text(
              'Sonuç Bulunamadı',
              style: GoogleFonts.inter(
                fontSize: Constants.textXl,
                fontWeight: FontWeight.w600,
                color: Constants.kykGray700,
              ),
            ),
            const SizedBox(height: Constants.space2),
            Text(
              _selectedDate != null
                  ? '${DateFormat('dd MMMM yyyy').format(_selectedDate!)} tarihi için henüz veri girişi yapılmadı.'
                  : 'Seçilen tarihte henüz veri girişi yapılmadı.',
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
            const SizedBox(height: Constants.space4),
            
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
          ],
        ),
      ),
    );
  }

  Widget _buildPastDateWarning() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Constants.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_amber_rounded, color: Constants.kykAccent, size: 64),
            const SizedBox(height: Constants.space4),
            Text(
              _selectedDate != null
                  ? '${DateFormat('dd MMMM yyyy').format(_selectedDate!)} geçmiş bir tarih. Geçmiş günlere ait menüler görüntülenemez.'
                  : 'Geçmiş bir tarih seçildi. Geçmiş günlere ait menüler görüntülenemez.',
              style: GoogleFonts.inter(
                fontSize: Constants.textBase,
                color: Constants.kykGray700,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Constants.space2),
            Text(
              'Lütfen bugünün veya gelecekteki bir tarihi seçin.',
              style: GoogleFonts.inter(
                fontSize: Constants.textSm,
                color: Constants.kykGray500,
              ),
              textAlign: TextAlign.center,
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
}