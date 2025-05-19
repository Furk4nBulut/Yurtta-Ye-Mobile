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
  List<Menu> _menus = [];
  int? _selectedCityId;
  String? _selectedMealType;
  String? _selectedDate;
  bool _isLoading = false;
  String? _error;
  int _page = AppConfig.initialPage; // AppConfig'ten alınan başlangıç sayfası
  final int _pageSize = AppConfig.pageSize; // Reduced for faster initial load
  bool _hasMore = true;

  List<City> get cities => _cities;
  List<Menu> get menus => _menus;
  int? get selectedCityId => _selectedCityId;
  String? get selectedMealType => _selectedMealType;
  String? get selectedDate => _selectedDate;
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
        _isLoading = false;
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
      _cities = await _apiService.getCities();
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

  Future<void> fetchMenus({bool reset = false}) async {
    if (!_hasMore && !reset) return;
    try {
      _isLoading = true;
      if (reset) {
        _page = 1;
        _menus = [];
        _hasMore = true;
      }
      _error = null;
      notifyListeners();

      final newMenus = await _apiService.getMenus(
        cityId: _selectedCityId,
        mealType: _selectedMealType,
        date: _selectedDate,
        page: _page,
        pageSize: _pageSize,
      );
      print('Menus fetched (page $_page): ${newMenus.map((m) => {'id': m.id, 'mealType': m.mealType, 'date': m.date.toIso8601String()}).toList()}');

      if (newMenus.isEmpty || newMenus.length < _pageSize) {
        _hasMore = false;
      }

      _menus = [..._menus, ...newMenus];
      _page++;
    } catch (e) {
      print('Server-side pagination failed: $e');
      try {
        final allMenus = await _apiService.getMenus();
        print('All menus fetched: ${allMenus.map((m) => {'id': m.id, 'mealType': m.mealType, 'date': m.date.toIso8601String()}).toList()}');
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
      } catch (e) {
        _error = e.toString();
        _menus = [];
        _hasMore = false;
        print('Error fetching menus: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
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

  void clearFilters() {
    _selectedCityId = null;
    _selectedMealType = null;
    _selectedDate = null;
    print('Clearing filters');
    fetchMenus(reset: true);
  }
}

// Isolate function for parsing cities
List<City> _parseCities(List<dynamic> json) {
  return json.map((e) => City.fromJson(e)).toList();
}