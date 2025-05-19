import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yurttaye_mobile/models/city.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/utils/config.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<City>> getCities() async {
    try {
      final response = await _client
          .get(Uri.parse('${Constants.apiUrl}${AppConfig.cityEndpoint}'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.map((json) => City.fromJson(json as Map<String, dynamic>)).toList();
      }
      throw Exception('Şehirler yüklenemedi: HTTP ${response.statusCode}');
    } catch (e) {
      throw Exception('Bağlantı hatası: $e');
    }
  }

  Future<List<Menu>> getMenus({int? cityId, String? mealType, String? date}) async {
    try {
      var uri = Uri.parse('${Constants.apiUrl}${AppConfig.menuEndpoint}');
      uri = uri.replace(queryParameters: {
        if (cityId != null) 'cityId': cityId.toString(),
        if (mealType != null) 'mealType': mealType,
        if (date != null) 'date': date,
      });

      final response = await _client.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.map((json) => Menu.fromJson(json as Map<String, dynamic>)).toList();
      }
      throw Exception('Menüler yüklenemedi: HTTP ${response.statusCode}');
    } catch (e) {
      throw Exception('Bağlantı hatası: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}