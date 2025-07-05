import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yurttaye_mobile/models/city.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/services/api_service.dart';
import 'package:yurttaye_mobile/utils/config.dart';

class MenuProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<City> _cities = [];
  List<Menu> _menus = []; // Filtered menus
  List<Menu> _allMenus = []; // Unfiltered menus for HomeScreen
  int? _selectedCityId;
  String? _selectedMealType;
  String? _selectedDate;
  int _selectedMealIndex = 0;
  bool _isLoading = false;
  String? _error;
  int _page = AppConfig.initialPage;
  final int _pageSize = AppConfig.pageSize;
  bool _hasMore = true;

  List<City> get cities => _cities;
  List<Menu> get menus => _menus;
  List<Menu> get allMenus => _allMenus;
  int? get selectedCityId => _selectedCityId;
  String? get selectedMealType => _selectedMealType;
  String? get selectedDate => _selectedDate;
  int get selectedMealIndex => _selectedMealIndex;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;

  Future<void> fetchCities() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedCities = prefs.getString('cities');

    if (cachedCities != null) {
      try {
        final List<dynamic> json = jsonDecode(cachedCities);
        _cities = await compute(_parseCities, json);
        print('Cities loaded from cache: ${_cities.map((c) => {'id': c.id, 'name': c.name}).toList()}');
        notifyListeners();
        return;
      } catch (e) {
        print('Error parsing cached cities: $e');
      }
    }

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      _cities = await _apiService.getCities().timeout(const Duration(seconds: 10));
      print('Cities fetched: ${_cities.map((c) => {'id': c.id, 'name': c.name}).toList()}');
      await prefs.setString('cities', jsonEncode(_cities.map((c) => c.toJson()).toList()));
    } catch (e) {
      _error = e.toString();
      print('Error fetching cities: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMenus({bool reset = false, bool initialLoad = false}) async {
    final prefs = await SharedPreferences.getInstance();
    if (reset || initialLoad) {
      _page = AppConfig.initialPage;
      _menus = [];
      _allMenus = [];
      _hasMore = true;
    }

    // Try loading cached menus for initial load
    if (initialLoad && prefs.getString('menus') != null) {
      try {
        final List<dynamic> json = jsonDecode(prefs.getString('menus')!);
        _menus = await compute(_parseMenus, json);
        _allMenus = List.from(_menus); // Copy to allMenus for initial display
        print('Menus loaded from cache: ${_menus.length} items');
        notifyListeners();
        // Fetch fresh data in the background
        _fetchMenusBackground();
        return;
      } catch (e) {
        print('Error parsing cached menus: $e');
      }
    }

    if (!_hasMore && !reset && !initialLoad) return;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Fetch filtered menus (smaller page size for initial load)
      final newMenus = await _apiService.getMenus(
        cityId: _selectedCityId,
        mealType: initialLoad ? AppConfig.mealTypes[0] : _selectedMealType, // Default to first meal type
        date: initialLoad ? AppConfig.apiDateFormat.format(DateTime.now()) : _selectedDate,
        page: _page,
        pageSize: initialLoad ? 5 : _pageSize, // Smaller page size for initial load
      ).timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Filtered menus API request timed out'));

      print('Menus fetched (page $_page): ${newMenus.map((m) => {'id': m.id, 'mealType': m.mealType, 'date': m.date.toIso8601String()}).toList()}');

      if (newMenus.isEmpty || newMenus.length < _pageSize) {
        _hasMore = false;
      }

      _menus = [..._menus, ...newMenus];
      if (initialLoad || reset) {
        _allMenus = List.from(_menus); // Initialize allMenus with filtered menus
      }
      _page++;

      // Cache menus
      await prefs.setString('menus', jsonEncode(_menus.map((m) => m.toJson()).toList()));
      print('Menus cached: ${_menus.length} items');

      // Fetch unfiltered menus in the background
      if (initialLoad || reset) {
        _fetchMenusBackground();
      }
    } catch (e) {
      print('Server-side pagination failed: $e');
      try {
        final allMenus = await _apiService.getMenus().timeout(const Duration(seconds: 10));
        print('All menus fetched: ${allMenus.map((m) => {'id': m.id, 'mealType': m.mealType, 'date': m.date.toIso8601String()}).toList()}');
        if (reset) {
          _allMenus = allMenus;
        } else {
          _allMenus = [..._allMenus, ...allMenus];
        }
        final filteredMenus = allMenus.where((menu) {
          bool matchesCity = _selectedCityId == null || menu.cityId == _selectedCityId;
          bool matchesMealType = _selectedMealType == null || menu.mealType == _selectedMealType;
          bool matchesDate = _selectedDate == null || AppConfig.apiDateFormat.format(menu.date) == _selectedDate;
          return matchesCity && matchesMealType && matchesDate;
        }).toList();

        final start = (_page - 1) * _pageSize;
        final end = start + _pageSize;
        final newMenus = filteredMenus.length > start ? filteredMenus.sublist(start, end > filteredMenus.length ? filteredMenus.length : end) : [];

        if (newMenus.isEmpty || end >= filteredMenus.length) {
          _hasMore = false;
        }

        _menus = [..._menus, ...newMenus];
        _page++;
        print('Filtered menus (page $_page): ${_menus.map((m) => {'id': m.id, 'mealType': m.mealType, 'date': m.date.toIso8601String()}).toList()}');

        // Cache menus
        await prefs.setString('menus', jsonEncode(_menus.map((m) => m.toJson()).toList()));
      } catch (e) {
        _error = e.toString();
        _hasMore = false;
        print('Error fetching menus: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch unfiltered menus in the background
  Future<void> _fetchMenusBackground() async {
    try {
      final allNewMenus = await _apiService.getMenus(
        page: _page,
        pageSize: _pageSize * 2,
      ).timeout(const Duration(seconds: 10));
      _allMenus = [..._allMenus, ...allNewMenus];
      print('Unfiltered menus fetched in background (page $_page, total: ${_allMenus.length})');
      notifyListeners();
    } catch (e) {
      print('Error fetching unfiltered menus in background: $e');
    }
  }

  void setSelectedCity(int? cityId) {
    _selectedCityId = cityId;
    print('Setting cityId: $cityId');
    fetchMenus(reset: true);
  }

  void setSelectedMealType(String? mealType) {
    if (mealType != null && !AppConfig.mealTypes.contains(mealType)) {
      print('Invalid mealType: $mealType');
      return;
    }
    _selectedMealType = mealType;
    print('Setting mealType: $mealType');
    fetchMenus(reset: true);
  }

  void setSelectedDate(String? date) {
    _selectedDate = date;
    print('Setting date: $date');
    fetchMenus(reset: true);
  }

  void setSelectedMealIndex(int index) {
    _selectedMealIndex = index;
    print('Setting meal index: $index');
  }

  void clearFilters() {
    _selectedCityId = null;
    _selectedMealType = null;
    _selectedDate = null;
    print('Clearing filters');
    fetchMenus(reset: true);
  }

  List<Menu> getUpcomingMeals(DateTime selectedDate) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    
    return _allMenus
        .where((menu) =>
            menu.date.isAfter(todayOnly) && 
            menu.mealType == AppConfig.mealTypes[_selectedMealIndex ?? 0])
        .take(3)
        .toList();
  }
}

// Isolate functions for parsing JSON data
List<City> _parseCities(List<dynamic> json) {
  return json.map((e) => City.fromJson(e)).toList();
}

List<Menu> _parseMenus(List<dynamic> json) {
  return json.map((e) => Menu.fromJson(e)).toList();
}
