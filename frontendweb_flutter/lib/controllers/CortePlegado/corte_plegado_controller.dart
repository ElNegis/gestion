import 'package:flutter/material.dart';
import '../../model/AuthHandler.dart';
import '../../service/CortePlegado/CortePlegadoService.dart';

class CortePlegadoController with ChangeNotifier {
  final AuthHandler authHandler;
  List<Map<String, dynamic>> cortePlegadoLista = [];

  CortePlegadoController({required this.authHandler});

  /// Obtener lista completa de CortePlegado
  Future<void> fetchCortePlegado() async {
    try {
      final result = await CortePlegadoService.obtenerCortePlegado(authHandler);
      cortePlegadoLista = result.cast<Map<String, dynamic>>();
      notifyListeners();
    } catch (e) {
      print('Error al obtener la lista de CortePlegado: $e');
    }
  }

  /// Crear un nuevo CortePlegado
  Future<bool> crearCortePlegado(Map<String, dynamic> data) async {
    try {
      final success = await CortePlegadoService.crearCortePlegado(authHandler, data);
      if (success) {
        await fetchCortePlegado();
      }
      return success;
    } catch (e) {
      print('Error al crear CortePlegado: $e');
      return false;
    }
  }

  /// Editar CortePlegado por ID
  Future<bool> editarCortePlegado(int id, Map<String, dynamic> data) async {
    try {
      final success = await CortePlegadoService.actualizarCortePlegado(authHandler, id, data);
      if (success) {
        final index = cortePlegadoLista.indexWhere((item) => item['id'] == id);
        if (index != -1) {
          cortePlegadoLista[index] = {...cortePlegadoLista[index], ...data};
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      print('Error al editar CortePlegado: $e');
      return false;
    }
  }

  /// Eliminar CortePlegado por ID
  Future<bool> eliminarCortePlegado(int id) async {
    try {
      final success = await CortePlegadoService.eliminarCortePlegado(authHandler, id);
      if (success) {
        cortePlegadoLista.removeWhere((item) => item['id'] == id);
        notifyListeners();
      }
      return success;
    } catch (e) {
      print('Error al eliminar CortePlegado: $e');
      return false;
    }
  }
}
