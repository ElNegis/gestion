import 'dart:convert';
import '../model/AuthHandler.dart';

class UserRoleService {
  /// Obtener usuarios con roles
  static Future<List<Map<String, dynamic>>?> fetchUsersWithRoles(AuthHandler authHandler) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'users/users/usuarios-con-roles/',
        headers: authHandler.getAuthHeaders(),
      );
      if (response != null && response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
    } catch (e) {
      print('Error en fetchUsersWithRoles: $e');
      return Future.error(_extractJsonError(e));
    }
    return null;
  }

  /// Obtener usuarios sin roles
  static Future<List<Map<String, dynamic>>?> fetchUsersWithoutRoles(AuthHandler authHandler) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'users/users/usuarios-sin-roles/',
        headers: authHandler.getAuthHeaders(),
      );
      if (response != null && response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
    } catch (e) {
      print('Error en fetchUsersWithoutRoles: $e');
      return Future.error(_extractJsonError(e));
    }
    return null;
  }

  /// Asignar un rol a un usuario
  static Future<bool> assignRoleToUser(AuthHandler authHandler, int userId, int roleId) async {
    try {
      final response = await authHandler.requestHandler.postRequest(
        'users/roles/assign/',
        data: {
          'user_id': userId,
          'role_id': roleId,
        },
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error en assignRoleToUser (userId: $userId, roleId: $roleId): $e');
      return Future.error(_extractJsonError(e));
    }
  }

  /// Eliminar un rol de un usuario
  static Future<bool> removeRoleFromUser(AuthHandler authHandler, int userId, int roleId) async {
    try {
      final response = await authHandler.requestHandler.postRequest(
        'users/roles/remove/',
        data: {
          'user_id': userId,
          'role_id': roleId,
        },
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error en removeRoleFromUser (userId: $userId, roleId: $roleId): $e');
      return Future.error(_extractJsonError(e));
    }
  }

  /// Obtener lista de roles
  static Future<List<Map<String, dynamic>>?> fetchRoles(AuthHandler authHandler) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'roles_permisos/roles',
        headers: authHandler.getAuthHeaders(),
      );
      if (response != null && response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
    } catch (e) {
      print('Error en fetchRoles: $e');
      return Future.error(_extractJsonError(e));
    }
    return null;
  }

  /// Extraer JSON del error para manejar respuestas de error en formato JSON
  static Map<String, dynamic> _extractJsonError(dynamic error) {
    String errorMessage = error.toString();
    if (errorMessage.contains('{') && errorMessage.contains('}')) {
      errorMessage = errorMessage.substring(errorMessage.indexOf('{'), errorMessage.lastIndexOf('}') + 1);
    }
    try {
      return jsonDecode(errorMessage);
    } catch (_) {
      return {'error': 'Error desconocido'};
    }
  }
}
