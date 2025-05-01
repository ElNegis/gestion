import '../model/RequestHandler.dart';
import '../model/AuthHandler.dart';

class ProveedorService {
  String nombre;
  final AuthHandler authHandler; // Nuevo: AuthHandler para manejar tokens
  RequestHandler request = RequestHandler();

  ProveedorService({
    required this.nombre,
    required this.authHandler,
  });

  Future<String> AgregarProveedor() async {
    try {
      final response = await authHandler.requestHandler.postRequest(
        'cotizador/proveedor/',
        data: {
          "nombre": this.nombre,
        },
        headers: authHandler.getAuthHeaders(),
      );
      return response.toString();
    } catch (e) {
      return e.toString();
    }
  }

  static Future<List<Map<String, dynamic>>> ObtenerProveedores(
      AuthHandler authHandler) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'cotizador/proveedor/',
        headers: (authHandler.getAuthHeaders()),
      );

      if (response is List) {
        return response.map((item) {
          if (item is Map<String, dynamic>) {
            return item;
          } else {
            throw Exception('Elemento no es un Map<String, dynamic>');
          }
        }).toList();
      } else {
        throw Exception('La respuesta no es una lista');
      }
    } catch (e) {
      print('Error en ObtenerProveedores: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> ObtenerProveedorPorId(int id) async {
    try {
      final response = await authHandler.requestHandler.getRequest(
        'cotizador/proveedor/$id/',
        headers: authHandler.getAuthHeaders(),
      );
      if (response is Map<String, dynamic>) {
        return response;
      } else {
        print('La respuesta no es un objeto válido.');
        return null;
      }
    } catch (e) {
      print('Error en ObtenerProveedorPorId: $e');
      return null;
    }
  }

  Future<bool> EliminarProveedor(int id) async {
    try {
      await authHandler.requestHandler.deleteRequest(
        'cotizador/proveedor/$id/',
        headers: authHandler.getAuthHeaders(),
      );
      return true;
    } catch (e) {
      print('Error en EliminarProveedor: $e');
      return false;
    }
  }

  Future<bool> EditarProveedor(int id, String nuevoNombre) async {
    try {
      final response = await authHandler.requestHandler.putRequest(
        'cotizador/proveedor/$id/',
        data: {
          "nombre": nuevoNombre,
        },
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error en EditarProveedor: $e');
      return false;
    }
  }

  Future<bool> ActualizarParcialProveedor(int id, Map<String, dynamic> cambios) async {
    try {
      final response = await authHandler.requestHandler.patchRequest(
        'cotizador/proveedor/$id/',
        data: cambios,
        headers: authHandler.getAuthHeaders(),
      );
      return response != null;
    } catch (e) {
      print('Error en ActualizarParcialProveedor: $e');
      return false;
    }
  }
}
