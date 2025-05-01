import 'package:flutter/material.dart';
import '../service/ProoveedorService.dart';
import '../model/AuthHandler.dart';

class ProveedorController with ChangeNotifier {
  final AuthHandler authHandler;
  List<Map<String, dynamic>> proveedores = [];

  ProveedorController({required this.authHandler});

  Future<void> fetchProveedores() async {
    try {
      final result = await ProveedorService.ObtenerProveedores(authHandler);
      if (result.isNotEmpty) {
        proveedores = result;
        notifyListeners();
      }
    } catch (e) {
      print('Error al obtener los proveedores: $e');
    }
  }

  Future<void> eliminarProveedor(int id) async {
    try {
      final proveedorService = ProveedorService(
        authHandler: authHandler,
        nombre: '', // Aquí el nombre no se usa, pero es requerido
      );
      final success = await proveedorService.EliminarProveedor(id);
      if (success) {
        proveedores.removeWhere((proveedor) => proveedor['id'] == id);
        notifyListeners();
      }
    } catch (e) {
      print('Error al eliminar el proveedor: $e');
    }
  }

  Future<bool> editarProveedor(int id, String nuevoNombre) async {
    try {
      final proveedorService = ProveedorService(
        authHandler: authHandler,
        nombre: nuevoNombre, // Pasar el nombre que se desea actualizar
      );
      final success = await proveedorService.EditarProveedor(id, nuevoNombre);
      if (success) {
        final index = proveedores.indexWhere((proveedor) => proveedor['id'] == id);
        if (index != -1) {
          proveedores[index]['nombre'] = nuevoNombre;
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      print('Error al editar el proveedor: $e');
      return false;
    }
  }
}
