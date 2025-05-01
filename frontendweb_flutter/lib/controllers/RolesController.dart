import 'package:flutter/material.dart';
import '../model/AuthHandler.dart';
import '../model/messageHandler.dart';
import '../service/RolesService.dart';

class RolesController with ChangeNotifier {
  final AuthHandler authHandler;

  List<Map<String, dynamic>> roles = [];
  Map<String, dynamic>? selectedRole;

  RolesController({required this.authHandler});

  /// Obtener todos los roles
  Future<bool> fetchRoles(BuildContext context) async {
    try {
      final response = await RolesService.fetchRoles(authHandler);
      MessageHandler.handleResponse(
        context: context,
        response: response,
        successMessage: 'Roles obtenidos exitosamente.',
      );

      if (response != null) {
        roles = response;
        notifyListeners();
        return true;
      }
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
    return false;
  }

  /// Obtener un rol por ID
  Future<bool> fetchRoleById(BuildContext context, int id) async {
    try {
      final response = await RolesService.fetchRoleById(authHandler, id);
      MessageHandler.handleResponse(
        context: context,
        response: response,
        successMessage: 'Rol obtenido correctamente.',
      );

      if (response != null) {
        selectedRole = response;
        notifyListeners();
        return true;
      }
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
    return false;
  }

  /// Crear un rol
  Future<bool?> createRole(
      BuildContext context, String name, String description) async {
    try {
      final response = await RolesService.createRole(authHandler, {
        'name': name,
        'description': description,
      });

      MessageHandler.handleResponse(
        context: context,
        response: response,
        successMessage: 'Rol creado exitosamente.',
      );

      if (response != null) {
        await fetchRoles(context);
        return response;
      }
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
    return null;
  }

  /// Actualizar un rol completamente
  Future<bool> updateRole(BuildContext context, int id, String name, String description) async {
    try {
      final response = await RolesService.updateRole(authHandler, id, {
        'name': name,
        'description': description,
      });

      MessageHandler.handleResponse(
        context: context,
        response: response,
        successMessage: 'Rol actualizado correctamente.',
      );

      if (response == true) {
        await fetchRoles(context);
        return true;
      }
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
    return false;
  }

  /// Actualizar parcialmente un rol
  Future<bool> patchRole(BuildContext context, int id, Map<String, dynamic> data) async {
    try {
      final response = await RolesService.patchRole(authHandler, id, data);

      MessageHandler.handleResponse(
        context: context,
        response: response,
        successMessage: 'Rol actualizado parcialmente.',
      );

      if (response == true) {
        await fetchRoles(context);
        return true;
      }
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
    return false;
  }

  /// Eliminar un rol
  Future<bool> deleteRole(BuildContext context, int id) async {
    try {
      final response = await RolesService.deleteRole(authHandler, id);
      MessageHandler.handleResponse(
        context: context,
        response: response,
        successMessage: 'Rol eliminado exitosamente.',
      );

      if (response == true) {
        await fetchRoles(context);
        return true;
      }
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
    return false;
  }
}
