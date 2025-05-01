import 'package:flutter/material.dart';
import '../model/AuthHandler.dart';
import '../service/UserPermissionsService.dart';

class UserPermissionController with ChangeNotifier {
  final AuthHandler authHandler;

  String? username;
  List<Map<String, dynamic>> permissions = [];

  UserPermissionController({required this.authHandler});

  /// Obtener permisos del usuario
  Future<bool> fetchUserPermissions() async {
    try {
      final response = await UserPermissionService.fetchUserPermissions(authHandler);
      if (response != null) {
        username = response['user'] as String?;
        permissions = List<Map<String, dynamic>>.from(response['permissions'] ?? []);
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error al obtener permisos del usuario: $e');
    }
    return false;
  }

  /// Verificar si el usuario tiene un permiso
  bool hasPermission(String permissionName) {
    return permissions.any((permission) => permission['name'] == permissionName);
  }
}
