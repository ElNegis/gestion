import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestHandler {
  final String baseUrl;
  static const _blockedUrl = '169.254.169.254';

  RequestHandler({this.baseUrl = 'http://localhost:8000/api/'});

  Future<dynamic> getRequest(String endpoint,
      {Map<String, String>? params, Map<String, String>? headers}) async {
    return _sendRequest('GET', endpoint, params: params, headers: headers);
  }

  Future<dynamic> postRequest(String endpoint,
      {Map<String, dynamic>? data,
        Map<String, String>? params,
        Map<String, String>? headers}) async {
    return _sendRequest('POST', endpoint, data: data, params: params, headers: headers);
  }

  Future<dynamic> putRequest(String endpoint,
      {Map<String, dynamic>? data,
        Map<String, String>? params,
        Map<String, String>? headers}) async {
    return _sendRequest('PUT', endpoint, data: data, params: params, headers: headers);
  }

  Future<dynamic> deleteRequest(String endpoint,
      {Map<String, String>? params, Map<String, String>? headers}) async {
    return _sendRequest('DELETE', endpoint, params: params, headers: headers);
  }

  Future<dynamic> patchRequest(String endpoint,
      {Map<String, dynamic>? data,
        Map<String, String>? params,
        Map<String, String>? headers}) async {
    return _sendRequest('PATCH', endpoint, data: data, params: params, headers: headers);
  }

  Future<dynamic> _sendRequest(String method, String endpoint,
      {Map<String, dynamic>? data,
        Map<String, String>? params,
        Map<String, String>? headers}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: params);

      // Log de la solicitud
      print('⏳ [HTTP] Intentando $method en: $uri');
      if (params != null) print('   📌 Parámetros: $params');

      // Bloqueo de IP insegura
      if (uri.host == _blockedUrl) {
        print('🚨 [BLOQUEADO] Intento de acceso a metadatos: $_blockedUrl');
        throw Exception('Acceso a URL prohibida: $_blockedUrl');
      }

      final defaultHeaders = {
        'Content-Type': 'application/json',
        if (headers != null && headers.containsKey('Authorization'))
          'Authorization': 'Bearer ${headers['Authorization']!.replaceAll(RegExp(r'^(Token|Bearer)\s*'), '')}',
        ...?headers,
      };

      late http.Response response;
      switch (method) {
        case 'GET':
          response = await http.get(uri, headers: defaultHeaders);
          break;
        case 'POST':
          response = await http.post(uri, body: jsonEncode(data), headers: defaultHeaders);
          break;
        case 'PUT':
          response = await http.put(uri, body: jsonEncode(data), headers: defaultHeaders);
          break;
        case 'PATCH':
          response = await http.patch(uri, body: jsonEncode(data), headers: defaultHeaders);
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: defaultHeaders);
          break;
        default:
          throw Exception('Método HTTP no soportado: $method');
      }

      return _handleResponse(response, uri);
    } catch (e) {
      _handleError(e, endpoint);
    }
  }

  dynamic _handleResponse(http.Response response, Uri uri) {
    print('Respuesta de $uri -> Código: ${response.statusCode}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      print('Código HTTP ${response.statusCode} - Respuesta: ${response.body}');
      throw Exception('Error HTTP ${response.statusCode}: ${response.body}');
    }
  }

  void _handleError(dynamic error, String endpoint) {
    print('[ERROR] en la petición HTTP a "$endpoint": $error');
    throw Exception('Error en la petición HTTP a "$endpoint": $error');
  }
}
