import '../model/AuthHandler.dart';

class ClienteService {
  /// Obtener la lista completa de clientes
  static Future<List<dynamic>> obtenerClientes(AuthHandler authHandler) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'clientes_ventas_cotizaciones/clientes/',
        headers: authHandler.getAuthHeaders(),
      );
      return response ?? [];
    } catch (e) {
      print('Error al obtener clientes: $e');
      return [];
    }
  }

  /// Obtener un cliente por ID
  static Future<Map<String, dynamic>?> obtenerClientePorId(AuthHandler authHandler, int id) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'clientes_ventas_cotizaciones/clientes/$id',
        headers: authHandler.getAuthHeaders(),
      );
      return response;
    } catch (e) {
      print('Error al obtener cliente por ID: $e');
      return null;
    }
  }

  /// Crear un nuevo cliente
  static Future<bool> crearCliente(AuthHandler authHandler, Map<String, dynamic> data) async {
    try {
      final response = await authHandler.requestHandler.postRequest(
        'clientes_ventas_cotizaciones/clientes/',
        data: data,
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error al crear cliente: $e');
      return false;
    }
  }

  /// Actualizar un cliente (parcial)
  static Future<bool> actualizarCliente(AuthHandler authHandler, int id, Map<String, dynamic> data) async {
    try {
      final response = await authHandler.requestHandler.patchRequest(
        'clientes_ventas_cotizaciones/clientes/$id',
        data: data,
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error al actualizar cliente: $e');
      return false;
    }
  }

  /// Eliminar un cliente
  static Future<bool> eliminarCliente(AuthHandler authHandler, int id) async {
    try {
      final response = await authHandler.requestHandler.deleteRequest(
        'clientes_ventas_cotizaciones/clientes/$id',
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error al eliminar cliente: $e');
      return false;
    }
  }
}
