import 'dart:convert';
import '../model/AuthHandler.dart';

class PermissionService {
  /// Obtener roles con permisos
  static Future<List<Map<String, dynamic>>?> fetchRolesWithPermissions(AuthHandler authHandler) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'roles_permisos/roles-con-permisos/',
        headers: authHandler.getAuthHeaders(),
      );
      if (response != null && response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
    } catch (e) {
      print('Error en fetchRoles: $e');
      try {
        final errorResponse = _extractJsonError(e);
        return Future.error(errorResponse);
      } catch (_) {
        return Future.error({'error': 'Error desconocido al obtener usuarios.'});
      }
    }
    return null;
  }

  /// Asignar un permiso a un rol
  static Future<bool> assignPermissionToRole(AuthHandler authHandler, int roleId, int permissionId) async {
    try {
      final response = await authHandler.requestHandler.postRequest(
        'roles_permisos/roles/asignar-permiso/',
        data: {
          'rol_id': roleId,
          'permiso_id': permissionId,
        },
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error al asignar permiso $permissionId al rol $roleId: $e');
      try {
        final errorResponse = _extractJsonError(e);
        return Future.error(errorResponse);
      } catch (_) {
        return Future.error({'error': 'Error desconocido al obtener usuarios.'});
      }
    }
  }

  /// Eliminar un permiso de un rol
  static Future<bool> removePermissionFromRole(AuthHandler authHandler, int roleId, int permissionId) async {
    try {
      final response = await authHandler.requestHandler.postRequest(
        'roles_permisos/roles/eliminar-permiso/',
        data: {
          'rol_id': roleId,
          'permiso_id': permissionId,
        },
        headers: authHandler.getAuthHeaders(),
      );

      return response != null;
    } catch (e) {
      print('Error al eliminar permiso $permissionId del rol $roleId: $e');
      try {
        final errorResponse = _extractJsonError(e);
        return Future.error(errorResponse);
      } catch (_) {
        return Future.error({'error': 'Error desconocido al obtener usuarios.'});
      }
    }
  }


  static Future<List<Map<String, dynamic>>?> fetchAllPermissions(AuthHandler authHandler) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'roles_permisos/permisos/',
        headers: authHandler.getAuthHeaders(),
      );
      if (response != null && response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
    } catch (e) {
      print('Error al obtener todos los permisos: $e');
      try {
        final errorResponse = _extractJsonError(e);
        return Future.error(errorResponse);
      } catch (_) {
        return Future.error({'error': 'Error desconocido al obtener usuarios.'});
      }
    }
    return null;
  }


  static Future<List<Map<String, dynamic>>?> fetchRolesWithoutPermissions(AuthHandler authHandler) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'roles_permisos/roles/roles-sin-permisos/',
        headers: authHandler.getAuthHeaders(),
      );
      if (response != null && response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
    } catch (e) {
      print('Error al obtener roles sin permisos: $e');
      try {
        final errorResponse = _extractJsonError(e);
        return Future.error(errorResponse);
      } catch (_) {
        return Future.error({'error': 'Error desconocido al obtener usuarios.'});
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

