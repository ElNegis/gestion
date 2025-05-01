import 'package:flutter/material.dart';

class ResultadoWidget extends StatelessWidget {
  final Map<String, dynamic> resultado;

  const ResultadoWidget({Key? key, required this.resultado}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extraer datos del resultado
    final planchaIdeal = resultado['plancha_ideal'] ?? {};
    final cortePlegado = resultado['corte_plegado'] ?? {};
    final precioPorUnidad = resultado['precio_por_unidad'] ?? 0.0;
    final precioTotal = resultado['precio_total'] ?? 0.0;
    final precioGolpes = resultado['precio_golpes'] ?? 0.0;
    final piezasPorPlancha = resultado['piezas_por_plancha'] ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[700]!, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Resultado del Cálculo",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionTitle("Plancha Ideal"),
          _buildDetail("Espesor", "${planchaIdeal['espesor']} mm"),
          _buildDetail("Largo", "${planchaIdeal['largo']} mm"),
          _buildDetail("Ancho", "${planchaIdeal['ancho']} mm"),
          _buildDetail("Precio", "\$${planchaIdeal['precio']}"),
          _buildDetail("Proveedor", planchaIdeal['proveedor']?['nombre'] ?? "-"),
          const SizedBox(height: 16),
          _buildSectionTitle("Corte Plegado"),
          _buildDetail("Espesor", "${cortePlegado['espesor']} mm"),
          _buildDetail("Largo", "${cortePlegado['largo']} mm"),
          _buildDetail("Precio por unidad", "\$${cortePlegado['precio']}"),
          const SizedBox(height: 16),
          _buildSectionTitle("Precios Calculados"),
          _buildDetail("Precio por Unidad", "\$${precioPorUnidad.toStringAsFixed(2)}"),
          _buildDetail("Precio Total", "\$${precioTotal.toStringAsFixed(2)}"),
          _buildDetail("Precio por Golpes", "\$${precioGolpes.toStringAsFixed(2)}"),
          _buildDetail("Piezas por Plancha", "${piezasPorPlancha.toStringAsFixed(2)}"),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
