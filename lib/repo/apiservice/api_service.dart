import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'http://192.168.0.100:5000'; // http://10.0.2.2:3000 for Android emulator //localhost /5000

  Future<Map<String, dynamic>> signUp(
    String name,
    String email,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/api/auth/register');
    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final data = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>?
          : null;
      return {
        'success': response.statusCode == 201,
        'message':
            data?['message']?.toString() ??
            (response.statusCode == 201
                ? 'Verification code sent'
                : 'Sign-up failed'),
      };
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  Future<Map<String, dynamic>> verifyEmail(String email, String code) async {
    final url = Uri.parse('$baseUrl/api/auth/verify');
    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'code': code}),
          )
          .timeout(const Duration(seconds: 10));

      final data = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>?
          : null;
      return {
        'success': response.statusCode == 200,
        'message':
            data?['message']?.toString() ??
            (response.statusCode == 200
                ? 'Email verified successfully'
                : 'Verification failed'),
      };
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      final data = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>?
          : null;
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data?['message']?.toString() ?? 'Login successful',
          'token': data?['token']?.toString(),
        };
      } else {
        return {
          'success': false,
          'message': data?['message']?.toString() ?? 'Login failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
