import 'dart:convert';
import '../model/AuthHandler.dart';

class UserService {
  /// Obtener la lista de usuarios (GET /users/users/)
  static Future<List<Map<String, dynamic>>?> fetchUsers(AuthHandler authHandler) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'users/users/',
        headers: authHandler.getAuthHeaders(),
      );
      if (response != null && response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
    } catch (e) {
      print('Error en fetchUsers: $e');
      try {
        final errorResponse = _extractJsonError(e);
        return Future.error(errorResponse);
      } catch (_) {
        return Future.error({'error': 'Error desconocido al obtener usuarios.'});
      }
    }
    return null;
  }

  /// Obtener un usuario por ID (GET /users/users/{id})
  static Future<Map<String, dynamic>?> fetchUserById(AuthHandler authHandler, int id) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'users/users/$id',
        headers: authHandler.getAuthHeaders(),
      );
      return response;
    } catch (e) {
      print('Error en fetchUserById: $e');
      try {
        final errorResponse = _extractJsonError(e);
        return Future.error(errorResponse);
      } catch (_) {
        return Future.error({'error': 'Error desconocido al obtener el usuario.'});
      }
    }
  }

  /// Crear un usuario (POST /users/users/)
  static Future<Map<String, dynamic>?> createUser(AuthHandler authHandler, Map<String, dynamic> data) async {
    try {
      final response = await authHandler.requestHandler.postRequest(
        'users/users/',
        data: data,
        headers: authHandler.getAuthHeaders(),
      );
      return response;
    } catch (e) {
      print('Error en createUser: $e');
      try {
        final errorResponse = _extractJsonError(e);
        return Future.error(errorResponse);
      } catch (_) {
        return Future.error({'error': 'Error desconocido al crear el usuario.'});
      }
    }
    return null;
  }

  /// Actualizar un usuario completamente (PUT /users/users/{id})
  static Future<bool> updateUser(AuthHandler authHandler, int id, Map<String, dynamic> data) async {
    try {
      final response = await authHandler.requestHandler.putRequest(
        'users/users/$id/',
        data: data,
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error en updateUser: $e');
      try {
        final errorResponse = _extractJsonError(e);
        return Future.error(errorResponse);
      } catch (_) {
        return Future.error({'error': 'Error desconocido al actualizar el usuario.'});
      }
    }
  }

  /// Actualizar un usuario parcialmente (PATCH /users/users/{id})
  static Future<bool> patchUser(AuthHandler authHandler, int id, Map<String, dynamic> data) async {
    try {
      final response = await authHandler.requestHandler.patchRequest(
        'users/users/$id',
        data: data,
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error en patchUser: $e');
      try {
        final errorResponse = _extractJsonError(e);
        return Future.error(errorResponse);
      } catch (_) {
        return Future.error({'error': 'Error desconocido al actualizar parcialmente el usuario.'});
      }
    }
  }

  /// Eliminar un usuario (DELETE /users/users/{id})
  static Future<bool> deleteUser(AuthHandler authHandler, int id, int currentUserId) async {
    try {
      if (id == currentUserId) {
        return Future.error({'error': 'Un usuario no puede eliminarse a sí mismo.'});
      }
      final response = await authHandler.requestHandler.deleteRequest(
        'users/users/$id',
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error en deleteUser: $e');
      try {
        final errorResponse = _extractJsonError(e);
        return Future.error(errorResponse);
      } catch (_) {
        return Future.error({'error': 'Error desconocido al eliminar el usuario.'});
      }
    }
  }

  /// Obtener datos del usuario en sesión (GET /users/users/me/)
  static Future<Map<String, dynamic>?> fetchCurrentUser(AuthHandler authHandler) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'users/users/me/',
        headers: authHandler.getAuthHeaders(),
      );
      return response;
    } catch (e) {
      print('Error en fetchCurrentUser: $e');
      try {
        final errorResponse = _extractJsonError(e);
        return Future.error(errorResponse);
      } catch (_) {
        return Future.error({'error': 'Error desconocido al obtener el usuario en sesión.'});
      }
    }
    return null;
  }

  /// Extraer JSON del error
  static Map<String, dynamic> _extractJsonError(dynamic error) {
    String errorMessage = error.toString();
    if (errorMessage.contains('{') && errorMessage.contains('}')) {
      errorMessage = errorMessage.substring(errorMessage.indexOf('{'), errorMessage.lastIndexOf('}') + 1);
    }
    return jsonDecode(errorMessage);
  }
}
