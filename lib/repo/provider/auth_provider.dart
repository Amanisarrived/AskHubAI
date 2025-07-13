import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../apiservice/api_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSignedUp = false;
  bool _isLoggedIn = false;
  String? _token;
  String? _pendingEmail;
  late SharedPreferences _storage;
  final _apiService = ApiService();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSignedUp => _isSignedUp;
  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    try {
      _storage = await SharedPreferences.getInstance();
      _token = _storage.getString('jwt_token');
      _isLoggedIn = _token != null;
      debugPrint(
        'Loaded token: ${_token?.substring(0, 10)}..., isLoggedIn: $_isLoggedIn',
      );
      if (_token == null) {
        _errorMessage = null;
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load token: $e';
      debugPrint('Token load error: $e');
      _isLoggedIn = false;
      notifyListeners();
    }
  }

  Future<void> _saveToken(String? token) async {
    try {
      _storage = await SharedPreferences.getInstance();
      if (token != null) {
        await _storage.setString('jwt_token', token);
        debugPrint('Token saved: ${token.substring(0, 10)}...');
      } else {
        await _storage.remove('jwt_token');
        debugPrint('Token deleted');
      }
    } catch (e) {
      _errorMessage = 'Failed to save token: $e';
      debugPrint('Token save error: $e');
      notifyListeners();
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    _isSignedUp = false;
    _pendingEmail = email;
    notifyListeners();

    try {
      final result = await _apiService.signUp(name, email, password);
      debugPrint('Sign-up response: $result');
      _isLoading = false;
      if (result['success'] == true) {
        _isSignedUp = true;
      } else {
        _errorMessage = result['message']?.toString() ?? 'Sign-up failed';
        _pendingEmail = null;
      }
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Sign-up error: $e';
      debugPrint('Sign-up error: $e');
      _pendingEmail = null;
      notifyListeners();
    }
  }

  Future<bool> verifyEmail(String email, String code) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.verifyEmail(email, code);
      debugPrint('Verify email response: $result');
      _isLoading = false;
      if (result['success'] == true) {
        _isSignedUp = false;
        _pendingEmail = null;
      } else {
        _errorMessage = result['message']?.toString() ?? 'Verification failed';
      }
      notifyListeners();
      return result['success'] == true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Verification error: $e';
      debugPrint('Verification error: $e');
      notifyListeners();
      return false;
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    _isLoggedIn = false;
    _token = null;
    notifyListeners();

    try {
      final result = await _apiService.login(email, password);
      debugPrint('Login response: $result');
      _isLoading = false;
      if (result['success'] == true && result['token'] != null) {
        _token = result['token'];
        await _saveToken(_token);
        _isLoggedIn = true;
        debugPrint(
          'Login successful, token: ${_token?.substring(0, 10)}..., isLoggedIn: $_isLoggedIn',
        );
      } else {
        _errorMessage =
            result['message']?.toString() ?? 'Login failed: No token received';
        debugPrint('Login failed: ${_errorMessage}');
      }
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Login error: $e';
      debugPrint('Login error: $e');
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    _isLoggedIn = false;
    _token = null;
    _pendingEmail = null;
    notifyListeners();

    try {
      await _saveToken(null);
      _isLoading = false;
      debugPrint('Logout successful');
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Logout error: $e';
      debugPrint('Logout error: $e');
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void resetSignUp() {
    _isSignedUp = false;
    _pendingEmail = null;
    notifyListeners();
  }
}
