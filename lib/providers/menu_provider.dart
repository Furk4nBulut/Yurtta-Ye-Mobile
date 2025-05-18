import 'package:flutter/material.dart';
import 'package:yurttaye_mobile/models/city.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/services/api_service.dart';

class MenuProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<City> _cities = [];
  List<Menu> _menus = [];
  bool _isLoading = false;
  String? _error;
  int? _selectedCityId;
  String? _selectedMealType;
  String? _selectedDate;

  List<City> get cities => _cities;
  List<Menu> get menus => _menus;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int? get selectedCityId => _selectedCityId;
  String? get selectedMealType => _selectedMealType;
  String? get selectedDate => _selectedDate;

  Future<void> fetchCities() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cities = await _apiService.getCities();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMenus() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _menus = await _apiService.getMenus(
        cityId: _selectedCityId,
        mealType: _selectedMealType,
        date: _selectedDate,
      );
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    }

    _isLoading = false;
    notifyListeners();
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