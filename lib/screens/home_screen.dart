import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/providers/theme_provider.dart';
import 'package:yurttaye_mobile/themes/app_theme.dart';
import 'package:yurttaye_mobile/utils/config.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/widgets/error_widget.dart';
import 'package:yurttaye_mobile/widgets/meal_card.dart';
import 'package:yurttaye_mobile/widgets/shimmer_loading.dart';
import 'package:intl/intl.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/widgets/upcomig_meal_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedMealIndex = 0; // 0: Kahvaltı, 1: Akşam Yemeği
  DateTime _selectedDate = DateTime.now(); // Track the selected date
  double _opacity = 1.0; // For fade animation

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MenuProvider>(context, listen: false);
      provider.fetchMenus(reset: true);
      print('Initiating fetchMenus from HomeScreen initState');
    });
  }

  // Navigate to previous or next date
  void _changeDate(bool isNext) {
    setState(() {
      _opacity = 0.5; // Start fade animation
      _selectedDate = isNext
          ? _selectedDate.add(const Duration(days: 1))
          : _selectedDate.subtract(const Duration(days: 1));
    });
    print('Date changed to: ${AppConfig.apiDateFormat.format(_selectedDate)}');
    // Reset opacity after animation
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => _opacity = 1.0);
    });
    // Fetch menus for the new date if not already loaded
    final provider = Provider.of<MenuProvider>(context, listen: false);
    if (!provider.menus.any((menu) =>
    AppConfig.apiDateFormat.format(menu.date) ==
        AppConfig.apiDateFormat.format(_selectedDate))) {
      provider.fetchMenus(reset: false);
      print('Fetching menus for new date: ${AppConfig.apiDateFormat.format(_selectedDate)}');
    }
  }

  // Check if previous or next menus exist
  bool _hasPreviousMenu(MenuProvider provider, String selectedMealType) {
    return provider.menus.any((menu) =>
    menu.date.isBefore(_selectedDate) && menu.mealType == selectedMealType);
  }

  bool _hasNextMenu(MenuProvider provider, String selectedMealType) {
    return provider.menus.any((menu) =>
    menu.date.isAfter(_selectedDate) && menu.mealType == selectedMealType);
  }

  // Launch the website
  Future<void> _launchWebsite() async {
    const String urlString = 'https://yurttaye.onrender.com/';
    final Uri url = Uri.parse(urlString);
    try {
      bool canLaunch = await canLaunchUrl(url);
      print('Can launch URL: $urlString, Result: $canLaunch');

      bool launched = false;
      if (!kIsWeb && canLaunch) {
        // Try external application for native platforms
        launched = await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
        print('External launch attempted: $urlString, Success: $launched');
      }

      // Fallback to platform default if external fails or on web
      if (!launched) {
        if (kIsWeb || canLaunch) {
          launched = await launchUrl(
            url,
            mode: LaunchMode.platformDefault,
          );
          print('Platform default launch attempted: $urlString, Success: $launched');
        } else {
          throw 'No browser available to launch $urlString';
        }
      }

      if (!launched) {
        throw 'Failed to launch $urlString';
      }
    } catch (e) {
      print('Error launching website: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Website açılamadı: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MenuProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final selectedMealType = AppConfig.mealTypes[_selectedMealIndex];

    return Scaffold(
      extendBody: true, // Allow content to extend behind BottomAppBar
      appBar: AppBar(
        title: const Text('YurttaYe'),
        leading: IconButton(
          icon: const Icon(Icons.language, color: Constants.white),
          tooltip: 'Website\'yi Ziyaret Et',
          onPressed: _launchWebsite,
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.brightness_7 : Icons.brightness_4,
              color: Constants.white,
            ),
            tooltip: themeProvider.isDarkMode ? 'Açık Tema' : 'Koyu Tema',
            onPressed: () {
              themeProvider.toggleTheme();
              print('Theme toggled: ${themeProvider.isDarkMode ? 'Dark' : 'Light'}');
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filtrele',
            onPressed: () => context.pushNamed('filter'),
          ),
        ],
      ),
      body: provider.isLoading && provider.menus.isEmpty && provider.allMenus.isEmpty
          ? const ShimmerLoading()
          : provider.error != null
          ? AppErrorWidget(
        error: provider.error!,
        onRetry: () {
          provider.fetchMenus(reset: true);
          print('Retrying fetchMenus from HomeScreen error widget');
        },
      )
          : provider.menus.isEmpty && provider.allMenus.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: Constants.text2xl * 2,
              color: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(height: Constants.space4),
            Text(
              'Hiçbir menü bulunamadı',
              style: Theme.of(context).textTheme.displayMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: Constants.space3),
            OutlinedButton.icon(
              onPressed: () {
                Provider.of<MenuProvider>(context, listen: false).fetchMenus(reset: true);
                print('Retry button pressed in HomeScreen');
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Tekrar Dene'),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: () async {
          await provider.fetchMenus(reset: true);
          print('RefreshIndicator triggered in HomeScreen');
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
                // Today's Meal Card with Navigation Buttons and Meal Time
                _buildTodayMealCard(provider, selectedMealType, screenWidth),
                // Upcoming Meals
                _buildUpcomingMeals(provider, selectedMealType, screenWidth),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _launchWebsite,
        backgroundColor: Constants.kykBlue600,
        foregroundColor: Constants.white,
        shape: const CircleBorder(),
        tooltip: 'Website\'yi Ziyaret Et',
        child: const Icon(Icons.language),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        color: themeProvider.isDarkMode ? Constants.gray800 : Constants.white,
        elevation: 8.0,
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: 52.0, // Fixed to prevent overflow
          padding: const EdgeInsets.symmetric(horizontal: Constants.space1),
          child: BottomNavigationBar(
            currentIndex: _selectedMealIndex,
            onTap: (index) {
              setState(() {
                _opacity = 0.5; // Trigger fade animation on meal type change
                _selectedMealIndex = index;
              });
              Future.delayed(const Duration(milliseconds: 300), () {
                setState(() => _opacity = 1.0);
              });
              print('Selected meal type: ${AppConfig.mealTypes[index]}');
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconSize: Constants.textSm,
            selectedLabelStyle: Theme.of(context).textTheme.bodySmall,
            unselectedLabelStyle: Theme.of(context).textTheme.bodySmall,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.breakfast_dining),
                label: 'Kahvaltı',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dinner_dining),
                label: 'Akşam Yemeği',
              ),
            ],
          ),
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
    final isSmallScreen = screenWidth < 400;
    final isVerySmallScreen = screenWidth < 350;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.space4,
        vertical: Constants.space2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Navigation Buttons and Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: _hasPreviousMenu(provider, selectedMealType)
                      ? Constants.kykBlue600
                      : Constants.gray600,
                ),
                onPressed: _hasPreviousMenu(provider, selectedMealType)
                    ? () => _changeDate(false)
                    : null,
                tooltip: 'Önceki Gün',
              ),
              Text(
                DateFormat('dd MMM yyyy').format(_selectedDate),
                style: Theme.of(context).textTheme.displayMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward,
                  color: _hasNextMenu(provider, selectedMealType)
                      ? Constants.kykBlue600
                      : Constants.gray600,
                ),
                onPressed: _hasNextMenu(provider, selectedMealType)
                    ? () => _changeDate(true)
                    : null,
                tooltip: 'Sonraki Gün',
              ),
            ],
          ),
          const SizedBox(height: Constants.space2),
          // Menu Card or Empty State
          menu.id == 0
              ? Card(
            child: Padding(
              padding: const EdgeInsets.all(Constants.space3),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: Constants.textBase,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(width: Constants.space2),
                  Expanded(
                    child: Text(
                      'Seçilen tarihte menü bulunamadı',
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          )
              : MealCard(menu: menu),
          const SizedBox(height: Constants.space2),
          // Meal Time Information as Text
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Constants.space4,
              vertical: Constants.space2,
            ),
            child: Semantics(
              label:
              '$selectedMealType: ${selectedMealType == 'Kahvaltı' ? '06:30 başlangıç - 12:00 bitiş' : '16:00 başlangıç - 23:00 bitiş'}',
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 300),
                child: Text(
                  '$selectedMealType: ${selectedMealType == 'Kahvaltı' ? '06:30 başlangıç - 12:00 bitiş' : '16:00 başlangıç - 23:00 bitiş'}',
                  style: GoogleFonts.poppins(
                    fontSize: isVerySmallScreen ? 12.0 : 14.0,
                    fontWeight: FontWeight.w500,
                    color: Constants.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
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
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date))
      ..take(7);

    if (upcomingMenus.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Constants.space4,
          vertical: Constants.space2,
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              size: Constants.textBase,
              color: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(width: Constants.space2),
            Expanded(
              child: Text(
                'Gelecek $selectedMealType bulunamadı',
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    final cardWidth = screenWidth * 0.65; // 65% of screen width, max 280

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.space4,
        vertical: Constants.space2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Gelecek $selectedMealType',
                  style: Theme.of(context).textTheme.displayMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.arrow_forward,
                size: Constants.textBase,
                color: Constants.kykBlue600,
              ),
            ],
          ),
          const SizedBox(height: Constants.space3),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: upcomingMenus
                  .map((menu) => Container(
                width: cardWidth.clamp(200.0, 280.0), // Responsive width
                margin: const EdgeInsets.only(right: Constants.space3),
                child: UpcomingMealCard(
                  menu: menu,
                  onTap: () => context.pushNamed(
                    'menu_detail',
                    pathParameters: {'id': menu.id.toString()},
                  ),
                ),
              ))
                  .toList(),
            ),
          ),
          const SizedBox(height: Constants.space4), // Extra padding to ensure visibility
        ],
      ),
    );
  }
}