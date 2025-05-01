import 'package:flutter/material.dart';
import '../model/AuthHandler.dart';
import '../service/UserRoleService.dart';
import '../model/messageHandler.dart';

class UserRoleController with ChangeNotifier {
  final AuthHandler authHandler;

  List<Map<String, dynamic>> usersWithRoles = [];
  List<Map<String, dynamic>> usersWithoutRoles = [];
  List<Map<String, dynamic>> roles = [];

  UserRoleController({required this.authHandler});

  /// Obtener usuarios con roles
  Future<bool> fetchUsersWithRoles(BuildContext context) async {
    try {
      final users = await UserRoleService.fetchUsersWithRoles(authHandler);
      MessageHandler.handleResponse(
        context: context,
        response: users,
        successMessage: 'Usuarios con roles obtenidos correctamente.',
      );

      if (users != null) {
        usersWithRoles = users;
        notifyListeners();
        return true;
      }
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
    return false;
  }

  /// Obtener usuarios sin roles
  Future<bool> fetchUsersWithoutRoles(BuildContext context) async {
    try {
      final users = await UserRoleService.fetchUsersWithoutRoles(authHandler);
      MessageHandler.handleResponse(
        context: context,
        response: users,
        successMessage: 'Usuarios sin roles obtenidos correctamente.',
      );

      if (users != null) {
        usersWithoutRoles = users;
        notifyListeners();
        return true;
      }
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
    return false;
  }

  /// Asignar un rol a un usuario
  Future<bool> assignRoleToUser(BuildContext context, int userId, int roleId) async {
    try {
      final success = await UserRoleService.assignRoleToUser(authHandler, userId, roleId);
      MessageHandler.handleResponse(
        context: context,
        response: success,
        successMessage: 'Rol asignado correctamente.',
      );

      if (success) {
        await fetchUsersWithRoles(context); // Refrescar usuarios con roles
        await fetchUsersWithoutRoles(context); // Refrescar usuarios sin roles
      }
      return success;
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
    return false;
  }

  /// Eliminar un rol de un usuario
  Future<bool> removeRoleFromUser(BuildContext context, int userId, int roleId) async {
    try {
      final success = await UserRoleService.removeRoleFromUser(authHandler, userId, roleId);
      MessageHandler.handleResponse(
        context: context,
        response: success,
        successMessage: 'Rol eliminado correctamente.',
      );

      if (success) {
        await fetchUsersWithRoles(context); // Refrescar usuarios con roles
      }
      return success;
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
    return false;
  }

  /// Obtener la lista de roles
  Future<bool> fetchRoles(BuildContext context) async {
    try {
      final fetchedRoles = await UserRoleService.fetchRoles(authHandler);
      MessageHandler.handleResponse(
        context: context,
        response: fetchedRoles,
        successMessage: 'Roles obtenidos correctamente.',
      );

      if (fetchedRoles != null) {
        roles = fetchedRoles;
        notifyListeners();
        return true;
      }
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
    return false;
  }
}
