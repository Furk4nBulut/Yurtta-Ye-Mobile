import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yurttaye_mobile/providers/menu_provider.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/widgets/city_dropdown.dart';
import 'package:yurttaye_mobile/widgets/date_picker.dart';
import 'package:yurttaye_mobile/widgets/meal_type_selector.dart';
import 'package:yurttaye_mobile/widgets/menu_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    final menuProvider = Provider.of<MenuProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      menuProvider.fetchCities();
      menuProvider.fetchMenus();
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Disables system back navigation
      child: Scaffold(
        appBar: AppBar(
          title: const Text('KYK Menü'),
          automaticallyImplyLeading: false, // Removes back button
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                Provider.of<MenuProvider>(context, listen: false).clearFilters();
                _controller.reset();
                _controller.forward();
              },
              tooltip: 'Filtreleri Temizle',
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            final provider = Provider.of<MenuProvider>(context, listen: false);
            await provider.fetchMenus();
            _controller.reset();
            _controller.forward();
          },
          color: Constants.kykBlue600,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(Constants.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menüleri Keşfet',
                    style: TextStyle(
                      fontSize: Constants.text2xl,
                      fontWeight: FontWeight.w700,
                      color: Constants.gray800,
                    ),
                  ),
                  const SizedBox(height: Constants.space4),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(Constants.space4),
                      child: Column(
                        children: [
                          const CityDropdown(),
                          const SizedBox(height: Constants.space3),
                          const MealTypeSelector(),
                          const SizedBox(height: Constants.space3),
                          const DatePicker(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Constants.space4),
                  Consumer<MenuProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Constants.kykBlue600),
                          ),
                        );
                      }
                      if (provider.error != null) {
                        return Center(
                          child: Column(
                            children: [
                              Text(
                                provider.error!.contains('Connection refused')
                                    ? 'Sunucuya bağlanılamadı.'
                                    : 'Hata: ${provider.error}',
                                style: TextStyle(
                                  fontSize: Constants.textBase,
                                  color: Constants.gray600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: Constants.space3),
                              ElevatedButton(
                                onPressed: () {
                                  provider.fetchMenus();
                                  _controller.reset();
                                  _controller.forward();
                                },
                                child: const Text('Tekrar Dene'),
                              ),
                            ],
                          ),
                        );
                      }
                      if (provider.menus.isEmpty) {
                        return Center(
                          child: Text(
                            'Menü bulunamadı.',
                            style: TextStyle(
                              fontSize: Constants.textBase,
                              color: Constants.gray600,
                            ),
                          ),
                        );
                      }
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: provider.menus.length,
                          itemBuilder: (context, index) {
                            return MenuCard(menu: provider.menus[index]);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}