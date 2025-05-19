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
    final today = AppConfig.apiDateFormat.format(DateTime.now());
    return menus.firstWhere(
          (menu) => AppConfig.apiDateFormat.format(menu.date) == today,
    );
  }

  Future<void> fetchCities() async {
    try {
      _isLoading = true;
      notifyListeners();
      _cities = await _apiService.getCities();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMenus() async {
    try {
      _isLoading = true;
      notifyListeners();
      _menus = await _apiService.getMenus(
        cityId: _selectedCityId,
        mealType: _selectedMealType,
        date: _selectedDate,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
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