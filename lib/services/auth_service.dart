import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:yurttaye_mobile/utils/constants.dart';

class AuthService {
  final http.Client _client = http.Client();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> login(String username, String password) async {
    final response = await _client.post(
      Uri.parse('${Constants.apiUrl}/Account/Login'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'username': username,
        'password': password,
        'returnUrl': '/Admin/AdminMenu',
      },
    );

    if (response.statusCode == 302 || response.statusCode == 200) {
      // Cookie'ler http.Client tarafından otomatik yönetilir
      await _storage.write(key: 'username', value: username);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _client.get(Uri.parse('${Constants.apiUrl}/Account/Logout'));
    await _storage.delete(key: 'username');
  }

  Future<String?> getUsername() async {
    return await _storage.read(key: 'username');
  }

  void dispose() {
    _client.close();
  }
}