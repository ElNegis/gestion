import 'package:flutter/material.dart';
import '../service/PlanchasService.dart';
import '../model/AuthHandler.dart';
import '../model/messageHandler.dart';

class PlanchaController with ChangeNotifier {
  final AuthHandler authHandler;
  List<Map<String, dynamic>> planchas = [];
  bool isLoading = false;

  PlanchaController({required this.authHandler});

  Future<void> fetchPlanchas(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await PlanchaService.GetPlanchas(authHandler);
      if (result != null) {
        planchas = result.map((plancha) {
          return {
            'id': int.tryParse(plancha['id'].toString()) ?? 0,
            'espesor': plancha['espesor'] ?? 0.0,
            'largo': plancha['largo'] ?? 0,
            'ancho': plancha['ancho'] ?? 0,
            'precio': plancha['precio'] ?? 0.0,
            'proveedor': {
              'id': int.tryParse(plancha['proveedor']['id'].toString()) ?? 0,
              'nombre': plancha['proveedor']['nombre'] ?? '',
            },
          };
        }).toList();
      }
    } catch (e) {
      MessageHandler.showErrorMessage(context, 'Error al obtener las planchas.');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> eliminarPlancha(BuildContext context, int id) async {
    try {
      final success = await PlanchaService.eliminarId(authHandler, id);
      if (success) {
        planchas.removeWhere((plancha) => plancha['id'] == id);
        notifyListeners();
        MessageHandler.showSuccessMessage(context, 'Plancha eliminada correctamente.');
      }
    } catch (e) {
      MessageHandler.showErrorMessage(context, 'Error al eliminar la plancha.');
    }
  }

  Future<bool> editarPlancha(BuildContext context, int id, Map<String, dynamic> nuevosDatos) async {
    try {
      final Map<String, dynamic> datosFormateados = {
        'espesor': nuevosDatos['espesor'] ?? 0.0,
        'largo': nuevosDatos['largo'] ?? 0,
        'ancho': nuevosDatos['ancho'] ?? 0,
        'proveedor_id': nuevosDatos['proveedor_id'] ?? 0,
        'precio_valor': nuevosDatos['precio_valor'] ?? 0.0,
      };

      final success = await PlanchaService.editarPlancha(authHandler, id, datosFormateados);
      if (success) {
        final index = planchas.indexWhere((plancha) => plancha['id'] == id);
        if (index != -1) {
          planchas[index] = {...planchas[index], ...datosFormateados};
        }
        notifyListeners();
        MessageHandler.showSuccessMessage(context, 'Plancha editada correctamente.');
      } else {
        MessageHandler.showErrorMessage(context, 'No se pudo editar la plancha.');
      }
      return success;
    } catch (e) {
      MessageHandler.showErrorMessage(context, 'Error al editar la plancha.');
      return false;
    }
  }
}
