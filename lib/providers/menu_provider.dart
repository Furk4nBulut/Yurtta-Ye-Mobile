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

  Menu? get todayMenu {
    if (_menus.isEmpty) return null;
    final today = AppConfig.apiDateFormat.format(DateTime.now());
    try {
      return _menus.firstWhere(
            (menu) => AppConfig.apiDateFormat.format(menu.date) == today,
        orElse: () => _menus.first,
      );
    } catch (e) {
      print('Error finding todayMenu: $e');
      return null;
    }
  }

  Future<void> fetchCities() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      _cities = await _apiService.getCities();
      print('Cities fetched: ${_cities.map((c) => {'id': c.id, 'name': c.name}).toList()}');
    } catch (e) {
      _error = 'Şehirler yüklenemedi: $e';
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
      _menus = await _apiService.getMenus(
        cityId: _selectedCityId,
        mealType: _selectedMealType,
        date: _selectedDate,
      );
      print('Menus fetched: ${_menus.map((m) => m.toJson()).toList()}');
    } catch (e) {
      _error = 'Menüler yüklenemedi: $e';
      print('Error fetching menus: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedCity(int? cityId) {
    _selectedCityId = cityId;
    fetchMenus();
  }

  void setSelectedMealType(String? mealType) {
    if (mealType != null && !AppConfig.mealTypes.contains(mealType)) {
      return;
    }
    _selectedMealType = mealType;
    fetchMenus();
  }

  void setSelectedDate(String? date) {
    _selectedDate = date;
    fetchMenus();
  }

  void clearFilters() {
    _selectedCityId = null;
    _selectedMealType = null;
    _selectedDate = null;
    fetchMenus();
  }
}