import '../model/AuthHandler.dart';

class CotizacionService {
  /// Calcular piezas
  static Future<Map<String, dynamic>?> calcularPiezas(AuthHandler authHandler, Map<String, dynamic> data) async {
    try {
      final response = await authHandler.requestHandler.postRequest(
        'cotizador/calcular-piezas/',
        data: data,
        headers: authHandler.getAuthHeaders(),
      );
      return response;
    } catch (e) {
      print('Error al calcular piezas: $e');
      try {
        final errorResponse = _extraerErrorJson(e);
        return Future.error(errorResponse);
      } catch (_) {
        return Future.error({'error': 'Error desconocido al calcular piezas.'});
      }
    }
  }

  /// Registrar venta
  static Future<Map<String, dynamic>?> registrarVenta(AuthHandler authHandler, Map<String, dynamic> data) async {
    try {
      final response = await authHandler.requestHandler.postRequest(
        'clientes_ventas_cotizaciones/ventas/',
        data: data,
        headers: authHandler.getAuthHeaders(),
      );
      return response;
    } catch (e) {
      print('Error al registrar la venta: $e');
      try {
        final errorResponse = _extraerErrorJson(e);
        return Future.error(errorResponse);
      } catch (_) {
        return Future.error({'error': 'Error desconocido al registrar la venta.'});
      }
    }
  }

  /// Crear cotización
  static Future<Map<String, dynamic>?> crearCotizacion(AuthHandler authHandler, Map<String, dynamic> data) async {
    try {
      final response = await authHandler.requestHandler.postRequest(
        'clientes_ventas_cotizaciones/cotizaciones/',
        data: data,
        headers: authHandler.getAuthHeaders(),
      );
      return response;
    } catch (e) {
      print('Error al crear cotización: $e');
      try {
        final errorResponse = _extraerErrorJson(e);
        return Future.error(errorResponse);
      } catch (_) {
        return Future.error({'error': 'Error desconocido al crear cotización.'});
      }
    }
  }

  /// Extraer error en formato JSON
  static Map<String, dynamic> _extraerErrorJson(dynamic error) {
    String mensajeError = error.toString();
    if (mensajeError.contains('{') && mensajeError.contains('}')) {
      mensajeError = mensajeError.substring(mensajeError.indexOf('{'), mensajeError.lastIndexOf('}') + 1);
    }
    return mensajeError.isNotEmpty ? Map<String, dynamic>.from(error) : {'error': 'Error desconocido'};
  }
}
