import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yurttaye_mobile/models/city.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/utils/config.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class ApiService {
  Future<List<City>> getCities() async {
    final url = '${Constants.apiUrl}${AppConfig.cityEndpoint}';
    print('Fetching cities from: $url');
    final response = await _makeRequest(url);
    print('Cities response: status=${response.statusCode}, body=${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => City.fromJson(json)).toList();
    } else {
      throw Exception('Şehirler yüklenemedi: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<Menu>> getMenus({int? cityId, String? mealType, String? date}) async {
    final queryParams = <String, String>{};
    if (cityId != null) queryParams['cityId'] = cityId.toString();
    if (mealType != null) queryParams['mealType'] = mealType;
    if (date != null) queryParams['date'] = date;

    final uri = Uri.parse('${Constants.apiUrl}${AppConfig.menuEndpoint}').replace(queryParameters: queryParams);
    print('Fetching menus from: $uri');
    final response = await _makeRequest(uri.toString());
    print('Menus response: status=${response.statusCode}, body=${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Menu.fromJson(json)).toList();
    } else {
      throw Exception('Menüler yüklenemedi: ${response.statusCode} - ${response.body}');
    }
  }

  Future<http.Response> _makeRequest(String url, {int retries = 3, Duration delay = const Duration(seconds: 2)}) async {
    for (int i = 0; i < retries; i++) {
      try {
        final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
        if (response.statusCode == 200 || response.statusCode >= 400) {
          return response;
        }
        print('Request failed with status ${response.statusCode}, retrying (${i + 1}/$retries)...');
      } catch (e) {
        print('Request error: $e, retrying (${i + 1}/$retries)...');
      }
      await Future.delayed(delay);
    }
    throw Exception('İstek başarısız: Maksimum deneme sayısına ulaşıldı');
  }
}