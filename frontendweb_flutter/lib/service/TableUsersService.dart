import 'dart:convert';
import '../model/RequestHandler.dart';
import 'LogService.dart';

class TableUsersService {
  final RequestHandler request = RequestHandler();

  /// Obtener todos los usuarios con manejo de errores mejorado
  Future<List<Map<String, dynamic>>?> fetchAllUsers(String accessToken) async {
    try {
      // Registrar evento de inicio de sesión
      LogService().logEvent('Usuario inició sesión con éxito');

      final response = await request.getRequest(
        'users/', // Endpoint para obtener todos los usuarios
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response != null && response is List) {
        return response.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print('Error en fetchAllUsers: $e');
      return Future.error(_extractJsonError(e));
    }
    return null;
  }

  /// Extraer JSON del error para manejo de respuestas de error en formato JSON
  static Map<String, dynamic> _extractJsonError(dynamic error) {
    String errorMessage = error.toString();
    if (errorMessage.contains('{') && errorMessage.contains('}')) {
      errorMessage = errorMessage.substring(errorMessage.indexOf('{'), errorMessage.lastIndexOf('}') + 1);
    }
    try {
      return jsonDecode(errorMessage);
    } catch (_) {
      return {'error': 'Error desconocido en fetchAllUsers'};
    }
  }
}
