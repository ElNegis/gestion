import '../model/AuthHandler.dart';

class PlanchaService {
  final double espesor;
  final int largo;
  final int ancho;
  final double precioValor;
  final int proveedorId;
  final AuthHandler authHandler;

  PlanchaService({
    required this.espesor,
    required this.largo,
    required this.ancho,
    required this.precioValor,
    required this.proveedorId,
    required this.authHandler,
  });

  Future<String> CreacionPlancha() async {
    try {
      final response = await authHandler.requestHandler.postRequest(
        'cotizador/planchas/',
        data: {
          "espesor": espesor,
          "largo": largo,
          "ancho": ancho,
          "precio_valor": precioValor,
          "proveedor_id": proveedorId,
        },
        headers: authHandler.getAuthHeaders(),
      );
      return response.toString();
    } catch (e) {
      return 'Error en CreacionPlancha';
    }
  }

  static Future<List<Map<String, dynamic>>?> GetPlanchas(AuthHandler authHandler) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'cotizador/planchas/',
        headers: authHandler.getAuthHeaders(),
      );

      if (response is List) {
        return response.cast<Map<String, dynamic>>();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> eliminarId(AuthHandler authHandler, int id) async {
    try {
      await authHandler.requestHandler.deleteRequest(
        'cotizador/planchas/$id/',
        headers: authHandler.getAuthHeaders(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> editarPlancha(AuthHandler authHandler, int id, Map<String, dynamic> data) async {
    try {
      final response = await authHandler.requestHandler.patchRequest(
        'cotizador/planchas/$id/',
        data: {
          'espesor': data['espesor'] ?? 0.0,
          'largo': data['largo'] ?? 0,
          'ancho': data['ancho'] ?? 0,
          'proveedor_id': data['proveedor_id'] ?? 0,
          'precio_valor': data['precio_valor'] ?? 0.0,
        },
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      return false;
    }
  }
}
