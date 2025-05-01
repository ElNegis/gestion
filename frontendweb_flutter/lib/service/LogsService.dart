import '../model/AuthHandler.dart';

class LogsService {
  /// Obtener la lista de logs (GET /users/logs/)
  static Future<List<Map<String, dynamic>>?> fetchLogs(AuthHandler authHandler) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'users/logs/aplicativos/',
        headers: authHandler.getAuthHeaders(),
      );
      return _processListResponse(response);
    } catch (e) {
      return _handleError(e, 'Error al obtener la lista de logs.');
    }
  }


    static Future<List<Map<String, dynamic>>?> fetchLogsSeguridad(AuthHandler authHandler) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'users/logs/seguridad/',
        headers: authHandler.getAuthHeaders(),
      );
      return _processListResponse(response);
    } catch (e) {
      return _handleError(e, 'Error al obtener la lista de logs.');
    }
  }


  /// **Métodos de procesamiento y manejo de errores**

  /// Procesa la respuesta si es una lista válida
  static List<Map<String, dynamic>>? _processListResponse(dynamic response) {
    if (response != null && response is List) {
      return List<Map<String, dynamic>>.from(response);
    }
    return null;
  }

  /// Manejo uniforme de errores que devuelven `Future<List<Map<String, dynamic>>?>`
  static Future<List<Map<String, dynamic>>?> _handleError(dynamic error, String message) async {
    print('$message: $error');
    return Future.error({'error': message});
  }
}
