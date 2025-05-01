import 'package:flutter/material.dart';
import '../model/AuthHandler.dart';
import '../service/CalculoService.dart';

class CalculoController with ChangeNotifier {
  final AuthHandler authHandler;

  Map<String, dynamic>? planchaIdeal;
  Map<String, dynamic>? cortePlegado;
  double? precioPorUnidad;
  double? precioTotal;
  double? precioGolpes;
  int? piezasPorPlancha;
  int? ventaId;

  CalculoController({required this.authHandler});

  /// Calcular piezas
  Future<bool> calcularPiezas(Map<String, dynamic> datosPieza) async {
    try {
      final resultado = await CotizacionService.calcularPiezas(authHandler, datosPieza);
      if (resultado != null) {
        planchaIdeal = resultado['plancha_ideal'];
        cortePlegado = resultado['corte_plegado'];
        precioPorUnidad = resultado['precio_por_unidad'];
        precioTotal = resultado['precio_total'];
        precioGolpes = resultado['precio_golpes'];
        piezasPorPlancha = resultado['piezas_por_plancha'];
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error en calcularPiezas: $e');
    }
    return false;
  }

  /// Registrar venta
  Future<bool> registrarVenta(int clienteId, double totalVenta) async {
    try {
      final resultado = await CotizacionService.registrarVenta(authHandler, {
        'cliente': clienteId,
        'total': totalVenta,
      });
      if (resultado != null) {
        ventaId = resultado['id'];
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error en registrarVenta: $e');
    }
    return false;
  }

  /// Crear cotización
  Future<bool> crearCotizacion({
    required String pieza,
    required double precio,
    required double totalEstimado,
    required String detalles,
    required int cortePlegadoId,
    required int planchaId,
  }) async {
    if (ventaId == null) {
      print('Error: No se ha registrado una venta.');
      return false;
    }

    try {
      final resultado = await CotizacionService.crearCotizacion(authHandler, {
        'pieza': pieza,
        'precio': precio,
        'total_estimado': totalEstimado,
        'detalles': detalles,
        'corte_plegado': cortePlegadoId,
        'plancha': planchaId,
        'venta': ventaId, // Usar el ID de la venta registrada
      });
      if (resultado != null) {
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error en crearCotizacion: $e');
    }
    return false;
  }

  /// Obtener el resultado del cálculo consolidado
  Map<String, dynamic>? getResultado() {
    if (planchaIdeal == null || cortePlegado == null) {
      return null; // No hay datos calculados aún
    }

    return {
      "plancha_ideal": planchaIdeal,
      "corte_plegado": cortePlegado,
      "precio_por_unidad": precioPorUnidad,
      "precio_total": precioTotal,
      "precio_golpes": precioGolpes,
      "piezas_por_plancha": piezasPorPlancha,
    };
  }
}
