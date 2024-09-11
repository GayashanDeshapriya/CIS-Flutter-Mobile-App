import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class AuthService {
  var baseUrl = 'https://192.168.0.100:7134/api';
  static Logger _logger = Logger();

  static Future login(String username, String password) async {
    try {
      _logger.d('Attempting to login with username: $username');
      //Uri url = Uri.parse('https://logixbmsmob.advantis.world/BMSAppUATAuth/api/Auth/login');
      //Uri url=Uri.parse('HTTP://192.168.0.100:7134/api/Auth/login');
      // Uri url =Uri.parse('HTTP://192.168.0.100:4444/v1/test_project/SaveCompletedJob');
      Uri url =
          Uri.parse('HTTP://10.11.1.11:4444/v1/test_project/SaveCompletedJob');

// final response = await http.get(url,
//           headers: {'Content-Type': 'application/json'},
//           //body: jsonEncode({'username': username, 'password': password})
//           );

      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'username': username, 'password': password}));

      _logger.d('API Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        //final token = responseBody["result"]['token'];
        final token = responseBody["result"];
        _logger.i('Token: $token');

        //Save token to shared preferences
        if (token != null && token is String) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);

          _logger.i('Token saved: $token');
          return true;
        } else {
          _logger.w('Token not found in response');
          return false;
        }
      } else {
        _logger.w('Login failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _logger.e('Error: $e');
      return false;
    }
  }

  //Method to get the save token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
