import 'package:flutter/material.dart';
import '../model/AuthHandler.dart';
import '../model/messageHandler.dart';
import '../service/PermissionService.dart';
import '../service/UserService.dart';

class PermissionController with ChangeNotifier {
  final AuthHandler authHandler;
  List<Map<String, dynamic>> rolesWithoutPermissions = [];
  List<Map<String, dynamic>> rolesWithPermissions = [];
  List<Map<String, dynamic>> allPermissions = [];
  Map<String, dynamic>? currentUser;

  PermissionController({required this.authHandler});

  /// Obtener roles con permisos
  Future<bool> fetchRolesWithPermissions(BuildContext context) async {
    try {
      final response = await PermissionService.fetchRolesWithPermissions(authHandler);
      MessageHandler.handleResponse(
        context: context,
        response: response,
        successMessage: 'Roles con permisos obtenidos exitosamente.',
      );

      if (response != null) {
        rolesWithPermissions = response;
        notifyListeners();
        return true;
      }
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
    return false;
  }

  /// Asignar un permiso a un rol
  Future<bool> assignPermission(BuildContext context, int roleId, int permissionId) async {
    try {
      final response = await PermissionService.assignPermissionToRole(authHandler, roleId, permissionId);
      MessageHandler.handleResponse(
        context: context,
        response: response,
        successMessage: 'Permiso asignado correctamente.',
      );

      if (response) {
        await fetchRolesWithPermissions(context);
        return true;
      }
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
    return false;
  }

  /// Eliminar un permiso de un rol
  Future<bool> removePermission(BuildContext context, int roleId, int permissionId) async {
    try {
      // Obtener datos del usuario en sesión
      final currentUserData = await UserService.fetchCurrentUser(authHandler);
      if (currentUserData != null) {
        currentUser = currentUserData;
        final List<dynamic> userRoles = currentUser!['roles'] ?? [];

        // Verificar si el usuario tiene el rol que intenta eliminar
        final isRoleAssignedToUser = userRoles.any((role) => role['id'] == roleId);
        if (isRoleAssignedToUser) {
          MessageHandler.showErrorMessage(context, 'No puedes eliminar tu propio rol.');
          return false;
        }
      }

      // Intentar eliminar el permiso del rol
      final response = await PermissionService.removePermissionFromRole(authHandler, roleId, permissionId);
      MessageHandler.handleResponse(
        context: context,
        response: response,
        successMessage: 'Permiso eliminado exitosamente.',
      );

      if (response) {
        await fetchRolesWithPermissions(context);
        return true;
      }
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
    return false;
  }

  /// Obtener todos los permisos
  Future<bool> fetchAllPermissions(BuildContext context) async {
    try {
      final response = await PermissionService.fetchAllPermissions(authHandler);
      MessageHandler.handleResponse(
        context: context,
        response: response,
        successMessage: 'Permisos obtenidos correctamente.',
      );

      if (response != null) {
        allPermissions = response;
        notifyListeners();
        return true;
      }
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
    return false;
  }

  /// Obtener roles sin permisos
  Future<bool> fetchRolesWithoutPermissions(BuildContext context) async {
    try {
      final response = await PermissionService.fetchRolesWithoutPermissions(authHandler);
      MessageHandler.handleResponse(
        context: context,
        response: response,
        successMessage: 'Roles sin permisos obtenidos correctamente.',
      );

      if (response != null) {
        rolesWithoutPermissions = response;
        notifyListeners();
        return true;
      }
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
    return false;
  }
}
