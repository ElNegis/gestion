import 'package:flutter/material.dart';
import '../model/AuthHandler.dart';
import '../service/ClienteService.dart';

class ClienteController with ChangeNotifier {
  final AuthHandler authHandler;
  List<Map<String, dynamic>> clientes = [];

  ClienteController({required this.authHandler});

  /// Obtener la lista de clientes
  Future<void> fetchClientes() async {
    try {
      final result = await ClienteService.obtenerClientes(authHandler);
      clientes = result.cast<Map<String, dynamic>>();
      notifyListeners();
    } catch (e) {
      print('Error al obtener la lista de clientes: $e');
    }
  }

  /// Obtener un cliente por ID
  Future<Map<String, dynamic>?> obtenerClientePorId(int id) async {
    try {
      return await ClienteService.obtenerClientePorId(authHandler, id);
    } catch (e) {
      print('Error al obtener cliente por ID: $e');
      return null;
    }
  }

  /// Crear un cliente
  Future<bool> crearCliente(Map<String, dynamic> data) async {
    try {
      final success = await ClienteService.crearCliente(authHandler, data);
      if (success) {
        await fetchClientes();
      }
      return success;
    } catch (e) {
      print('Error al crear cliente: $e');
      return false;
    }
  }

  /// Actualizar un cliente
  Future<bool> actualizarCliente(int id, Map<String, dynamic> data) async {
    try {
      final success = await ClienteService.actualizarCliente(authHandler, id, data);
      if (success) {
        final index = clientes.indexWhere((cliente) => cliente['id'] == id);
        if (index != -1) {
          clientes[index] = {...clientes[index], ...data};
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      print('Error al actualizar cliente: $e');
      return false;
    }
  }

  /// Eliminar un cliente
  Future<bool> eliminarCliente(int id) async {
    try {
      final success = await ClienteService.eliminarCliente(authHandler, id);
      if (success) {
        clientes.removeWhere((cliente) => cliente['id'] == id);
        notifyListeners();
      }
      return success;
    } catch (e) {
      print('Error al eliminar cliente: $e');
      return false;
    }
  }
}
