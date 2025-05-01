import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'RequestHandler.dart';

class AuthHandler {
  final RequestHandler requestHandler;
  String? _accessToken;
  String? _refreshToken;
  Timer? _tokenTimer;

  AuthHandler({required this.requestHandler});

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await requestHandler.postRequest(
        'users/auth/login/',
        data: {'username': username, 'password': password},
      );
      _accessToken = response['access_token'];
      _refreshToken = response['refresh_token'];


      await _saveTokens();
      _startTokenTimer();
      return {'success': true, 'data': response};
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }


  Future<bool> refreshAccessToken() async {
    if (_refreshToken == null) {
      return false;
    }

    try {
      print('Intentando refrescar el AccessToken usando el RefreshToken: $_refreshToken');
      final response = await requestHandler.postRequest(
        'auth/refresh/',
        data: {'refresh': _refreshToken},
      );
      _accessToken = response['access'];
      _refreshToken = response['refresh'];

      print('Tokens renovados exitosamente.');
      print('Nuevo AccessToken: $_accessToken');
      print('Nuevo RefreshToken: $_refreshToken');

      await _saveTokens();
      _startTokenTimer();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    print('Cerrando sesión e invalidando tokens');

    if (_refreshToken != null) {
      try {
        await requestHandler.postRequest(
          'users/auth/logout/',
          data: {"refresh_token": _refreshToken},
          headers: getAuthHeaders(),
        );
      } catch (e) {
        print('$e');
      }
    } else {
      print('No hay RefreshToken disponible para invalidar.');
    }

    _accessToken = null;
    _refreshToken = null;
    _tokenTimer?.cancel();
    await _clearTokens();

  }


  Map<String, String> getAuthHeaders() {
    print('Generando headers de autorización...');
    if (_accessToken != null) {
      return {'Authorization': 'Bearer $_accessToken'};
    } else {

      return {};
    }
  }

  Future<void> _saveTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', _accessToken ?? ''); // Unificar clave
    await prefs.setString('refreshToken', _refreshToken ?? ''); // Unificar clave
  }

  Future<void> _loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('accessToken'); // Unificar clave
    _refreshToken = prefs.getString('refreshToken'); // Unificar clave

    if (_accessToken != null) _startTokenTimer();
  }

  Future<void> _clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }

  void _startTokenTimer() {
    _tokenTimer?.cancel();
    _tokenTimer = Timer(Duration(minutes: 59), () async {

      await refreshAccessToken();
    });
  }

  Future<void> initialize() async {
    await _loadTokens();
  }
}