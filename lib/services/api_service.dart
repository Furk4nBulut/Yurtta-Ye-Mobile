import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yurttaye_mobile/models/city.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class ApiService {
  Future<List<City>> getCities() async {
    final response = await http.get(Uri.parse('${Constants.apiUrl}/City'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => City.fromJson(json)).toList();
    } else {
      throw Exception('Şehirler yüklenemedi: ${response.statusCode}');
    }
  }

  Future<List<Menu>> getMenus({int? cityId, String? mealType, String? date}) async {
    var uri = Uri.parse('${Constants.apiUrl}/Menu');
    if (cityId != null || mealType != null || date != null) {
      uri = uri.replace(queryParameters: {
        if (cityId != null) 'cityId': cityId.toString(),
        if (mealType != null) 'mealType': mealType,
        if (date != null) 'date': date,
      });
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Menu.fromJson(json)).toList();
    } else {
      throw Exception('Menüler yüklenemedi: ${response.statusCode}');
    }
  }
}