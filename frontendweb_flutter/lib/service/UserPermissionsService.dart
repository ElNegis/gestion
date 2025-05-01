import '../model/AuthHandler.dart';

class UserPermissionService {
  /// Obtener permisos de usuario
  static Future<Map<String, dynamic>?> fetchUserPermissions(AuthHandler authHandler) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'roles_permisos/users/permissions/',
        headers: authHandler.getAuthHeaders(),
      );
      if (response != null && response is Map<String, dynamic>) {
        return response;
      }
    } catch (e) {
      print('Error al obtener los permisos del usuario: $e');
    }
    return null;
  }
}
