import 'dart:convert';
import '../model/AuthHandler.dart';

class RolesService {
  /// Obtener la lista de roles (GET roles_permisos/roles/)
  static Future<List<Map<String, dynamic>>?> fetchRoles(AuthHandler authHandler) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'roles_permisos/roles/',
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

  /// Obtener un rol por ID (GET roles_permisos/roles/{id}/)
  static Future<Map<String, dynamic>?> fetchRoleById(AuthHandler authHandler, int id) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'roles_permisos/roles/$id/',
        headers: authHandler.getAuthHeaders(),
      );
      return response;
    } catch (e) {
      print('Error en fetchRoleById: $e');
      return Future.error(_extractJsonError(e));
    }
  }

  /// Crear un rol (POST roles_permisos/roles/)
  static Future<bool> createRole(AuthHandler authHandler, Map<String, dynamic> data) async {
    try {
      final response = await authHandler.requestHandler.postRequest(
        'roles_permisos/roles/',
        data: data,
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error en createRole: $e');
      return Future.error(_extractJsonError(e));
    }
  }

  /// Actualizar un rol completamente (PUT roles_permisos/roles/{id}/)
  static Future<bool> updateRole(AuthHandler authHandler, int id, Map<String, dynamic> data) async {
    try {
      final response = await authHandler.requestHandler.putRequest(
        'roles_permisos/roles/$id/',
        data: data,
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error en updateRole: $e');
      return Future.error(_extractJsonError(e));
    }
  }

  /// Actualizar un rol parcialmente (PATCH roles_permisos/roles/{id}/)
  static Future<bool> patchRole(AuthHandler authHandler, int id, Map<String, dynamic> data) async {
    try {
      final response = await authHandler.requestHandler.patchRequest(
        'roles_permisos/roles/$id/',
        data: data,
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error en patchRole: $e');
      return Future.error(_extractJsonError(e));
    }
  }

  /// Eliminar un rol (DELETE roles_permisos/roles/{id}/)
  static Future<bool> deleteRole(AuthHandler authHandler, int roleId) async {
    try {
      // Obtener datos del usuario en sesión
      final currentUserResponse = await authHandler.requestHandler.getRequest(
        'users/users/me/',
        headers: authHandler.getAuthHeaders(),
      );

      if (currentUserResponse != null) {
        final List<dynamic> userRoles = currentUserResponse['roles'];
        final isRoleAssignedToUser = userRoles.any((role) => role['id'] == roleId);

        if (isRoleAssignedToUser) {
          return Future.error({'error': 'No puedes eliminar un rol asignado a tu usuario.'});
        }
      }

      final response = await authHandler.requestHandler.deleteRequest(
        'roles_permisos/roles/$roleId/',
        headers: authHandler.getAuthHeaders(),
      );

      return response != null;
    } catch (e) {
      print('Error en deleteRole: $e');
      return Future.error(_extractJsonError(e));
    }
  }

  /// Extraer JSON del error para manejo de respuestas de error en formato JSON
  static Map<String, dynamic> _extractJsonError(dynamic error) {
    String errorMessage = error.toString();
    if (errorMessage.contains('{') && errorMessage.contains('}')) {
      errorMessage = errorMessage.substring(errorMessage.indexOf('{'), errorMessage.lastIndexOf('}') + 1);
    }
    try {
      return jsonDecode(errorMessage);
    } catch (_) {
      return {'error': 'Error desconocido en la operación de roles.'};
    }
  }
}
