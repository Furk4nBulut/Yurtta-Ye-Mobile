import 'package:flutter/material.dart';
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

  List<City> get cities => _cities;
  List<Menu> get menus => _menus;
  int? get selectedCityId => _selectedCityId;
  String? get selectedMealType => _selectedMealType;
  String? get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCities() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      _cities = await _apiService.getCities();
      print('Cities fetched: ${_cities.map((c) => {'id': c.id, 'name': c.name}).toList()}');
    } catch (e) {
      _error = e.toString();
      print('Error fetching cities: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMenus() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      // Try server-side filtering
      _menus = await _apiService.getMenus(
        cityId: _selectedCityId,
        mealType: _selectedMealType,
        date: _selectedDate,
      );
      print('Menus fetched: ${_menus.map((m) => {'id': m.id, 'mealType': m.mealType, 'date': m.date.toIso8601String()}).toList()}');
    } catch (e) {
      print('Server-side filtering failed: $e');
      // Fallback to client-side filtering
      try {
        final allMenus = await _apiService.getMenus();
        print('All menus fetched: ${allMenus.map((m) => {'id': m.id, 'mealType': m.mealType, 'date': m.date.toIso8601String()}).toList()}');
        _menus = allMenus.where((menu) {
          bool matchesCity = _selectedCityId == null || menu.cityId == _selectedCityId;
          bool matchesMealType = _selectedMealType == null || menu.mealType == _selectedMealType;
          bool matchesDate = _selectedDate == null || AppConfig.apiDateFormat.format(menu.date) == _selectedDate;
          return matchesCity && matchesMealType && matchesDate;
        }).toList();
        print('Filtered menus: ${_menus.map((m) => {'id': m.id, 'mealType': m.mealType, 'date': m.date.toIso8601String()}).toList()}');
      } catch (e) {
        _error = e.toString();
        _menus = [];
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
    fetchMenus();
  }

  void setSelectedMealType(String? mealType) {
    if (mealType != null && !AppConfig.mealTypes.contains(mealType)) {
      print('Invalid mealType: $mealType');
      return;
    }
    _selectedMealType = mealType;
    print('Setting mealType: $mealType');
    fetchMenus();
  }

  void setSelectedDate(String? date) {
    _selectedDate = date;
    print('Setting date: $date');
    fetchMenus();
  }

  void clearFilters() {
    _selectedCityId = null;
    _selectedMealType = null;
    _selectedDate = null;
    print('Clearing filters');
    fetchMenus();
  }
}