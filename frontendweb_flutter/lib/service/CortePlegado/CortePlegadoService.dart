import '../../model/AuthHandler.dart';

class CortePlegadoService {
  /// Obtener la lista completa de CortePlegado
  static Future<List<dynamic>> obtenerCortePlegado(AuthHandler authHandler) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'cotizador/CortePlegado/',
        headers: authHandler.getAuthHeaders(),
      );
      return response ?? [];
    } catch (e) {
      print('Error al obtener CortePlegado: $e');
      return [];
    }
  }

  /// Crear un nuevo CortePlegado
  static Future<bool> crearCortePlegado(AuthHandler authHandler, Map<String, dynamic> data) async {
    try {
      final response = await authHandler.requestHandler.postRequest(
        'cotizador/CortePlegado/',
        data: data,
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error al crear CortePlegado: $e');
      return false;
    }
  }

  /// Obtener CortePlegado por ID
  static Future<Map<String, dynamic>?> obtenerCortePlegadoPorId(AuthHandler authHandler, int id) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'cotizador/CortePlegado/$id/',
        headers: authHandler.getAuthHeaders(),
      );
      return response;
    } catch (e) {
      print('Error al obtener CortePlegado por ID: $e');
      return null;
    }
  }

  /// Actualizar CortePlegado por ID
  static Future<bool> actualizarCortePlegado(AuthHandler authHandler, int id, Map<String, dynamic> data) async {
    try {
      final response = await authHandler.requestHandler.putRequest(
        'cotizador/CortePlegado/$id/',
        data: data,
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error al actualizar CortePlegado: $e');
      return false;
    }
  }

  /// Actualizar parcialmente CortePlegado por ID
  static Future<bool> actualizarParcialCortePlegado(AuthHandler authHandler, int id, Map<String, dynamic> data) async {
    try {
      final response = await authHandler.requestHandler.patchRequest(
        'cotizador/CortePlegado/$id/',
        data: data,
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error al actualizar parcialmente CortePlegado: $e');
      return false;
    }
  }

  /// Eliminar CortePlegado por ID
  static Future<bool> eliminarCortePlegado(AuthHandler authHandler, int id) async {
    try {
      final response = await authHandler.requestHandler.deleteRequest(
        'cotizador/CortePlegado/$id/',
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error al eliminar CortePlegado: $e');
      return false;
    }
  }
}
