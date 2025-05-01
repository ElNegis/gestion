import 'package:flutter/material.dart';
import '../model/AuthHandler.dart';
import '../model/messageHandler.dart';
import '../service/UserService.dart';
import '../service/LogsService.dart';

class UserController with ChangeNotifier {
  final AuthHandler authHandler;

  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> logs = [];
  Map<String, dynamic>? selectedUser;
  Map<String, dynamic>? currentUser;

  UserController({required this.authHandler});

  /// Obtener todos los usuarios
  Future<bool> fetchUsers(BuildContext context) async {
    try {
      final response = await UserService.fetchUsers(authHandler);
      MessageHandler.handleResponse(
        context: context,
        response: response,
        successMessage: 'Usuarios obtenidos exitosamente.',
      );

      if (response != null) {
        users = response;
        notifyListeners();
        return true;
      }
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
    return false;
  }

  /// Obtener un usuario por ID
  Future<bool> fetchUserById(BuildContext context, int id) async {
    try {
      final response = await UserService.fetchUserById(authHandler, id);
      MessageHandler.handleResponse(
        context: context,
        response: response,
        successMessage: 'Usuario obtenido correctamente.',
      );

      if (response != null) {
        selectedUser = response;
        notifyListeners();
        return true;
      }
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
    return false;
  }

  /// Crear un usuario
  Future<Map<String, dynamic>?> createUser(BuildContext context, String nombre, String apellido, String password) async {
    try {
      final response = await UserService.createUser(authHandler, {
        'nombre': nombre,
        'apellido': apellido,
        'password': password,
      });

      MessageHandler.handleResponse(
        context: context,
        response: response,
        successMessage: 'Usuario creado exitosamente.',
      );

      if (response != null) {
        await fetchUsers(context);
        return response;
      }
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
    return null;
  }

  /// Actualizar un usuario completamente
  Future<bool> updateUser(BuildContext context, int id, String nombre, String apellido, String password) async {
    try {
      final response = await UserService.updateUser(authHandler, id, {
        'nombre': nombre,
        'apellido': apellido,
        'password': password,
      });

      MessageHandler.handleResponse(
        context: context,
        response: response,
        successMessage: 'Usuario actualizado correctamente.',
      );

      if (response == true) {
        await fetchUsers(context);
        return true;
      }
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
    return false;
  }

  /// Actualizar parcialmente un usuario
  Future<bool> putUser(BuildContext context, int id, Map<String, dynamic> data) async {
    try {
      final response = await UserService.updateUser(authHandler, id, data);

      MessageHandler.handleResponse(
        context: context,
        response: response,
        successMessage: 'Usuario actualizado parcialmente.',
      );

      if (response == true) {
        await fetchUsers(context);
        return true;
      }
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
    return false;
  }

  /// Eliminar un usuario
  Future<bool> deleteUser(BuildContext context, int id) async {
    try {
      final currentUserData = await UserService.fetchCurrentUser(authHandler);
      if (currentUserData != null) {
        currentUser = currentUserData;
        if (id == currentUser!['id']) {
          MessageHandler.showErrorMessage(context, 'No puedes eliminar tu propio usuario.');
          return false;
        }
      }

      final response = await UserService.deleteUser(authHandler, id, currentUser!['id']);
      MessageHandler.handleResponse(
        context: context,
        response: response,
        successMessage: 'Usuario eliminado exitosamente.',
      );

      if (response == true) {
        await fetchUsers(context);
        return true;
      }
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
    return false;
  }

  /// Obtener datos del usuario en sesión
  Future<void> fetchCurrentUser(BuildContext context) async {
    try {
      final response = await UserService.fetchCurrentUser(authHandler);
      MessageHandler.handleResponse(
        context: context,
        response: response,
        successMessage: 'Datos del usuario en sesión cargados correctamente.',
      );

      if (response != null) {
        currentUser = response;
        notifyListeners();
      }
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
  }

  /// Obtener logs
  Future<bool> fetchLogs(BuildContext context) async {
    try {
      final response = await LogsService.fetchLogs(authHandler);
      MessageHandler.handleResponse(
        context: context,
        response: response,
        successMessage: 'Logs obtenidos exitosamente.',
      );

      if (response != null) {
        logs = response;
        notifyListeners();
        return true;
      }
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
    return false;
  }



    Future<bool> fetchLogsSecurity(BuildContext context) async {
    try {
      final response = await LogsService.fetchLogsSeguridad(authHandler);
      MessageHandler.handleResponse(
        context: context,
        response: response,
        successMessage: 'Logs obtenidos exitosamente.',
      );

      if (response != null) {
        logs = response;
        notifyListeners();
        return true;
      }
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
    return false;
  }
}

