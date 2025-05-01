import 'dart:convert';
import 'package:http/http.dart' as http;

class PiezaService {
  final String baseUrl;

  PiezaService({required this.baseUrl});

  /// Calcular piezas (POST /cotizador/calcular-piezas/)
  Future<Map<String, dynamic>?> calcularPiezas({
    required int espesor,
    required int largoPieza,
    required int anchoPieza,
    required int cantidadGolpes,
    required int cantidadPiezas,
  }) async {
    final url = Uri.parse('$baseUrl/cotizador/calcular-piezas/');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "espesor": espesor,
          "largo_pieza": largoPieza,
          "ancho_pieza": anchoPieza,
          "cantidad_golpes": cantidadGolpes,
          "cantidad_piezas": cantidadPiezas,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return Future.error(_extractJsonError(response));
      }
    } catch (e) {
      print('Error en calcularPiezas: $e');
      return Future.error({'error': 'Error desconocido al calcular piezas.'});
    }
  }

  /// Extraer JSON del error
  static Map<String, dynamic> _extractJsonError(http.Response response) {
    try {
      return jsonDecode(response.body);
    } catch (_) {
      return {'error': 'Error en la respuesta del servidor. Código: ${response.statusCode}'};
    }
  }
}
