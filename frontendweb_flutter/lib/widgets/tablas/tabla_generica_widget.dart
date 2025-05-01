import 'package:flutter/material.dart';
import '../botones/CustomButton.dart';

class TablaGenericaWidget extends StatefulWidget {
  final List<String> columnas;
  final Future<List<Map<String, dynamic>>> Function() obtenerDatos;
  final void Function(List<int> ids) onEliminar;
  final void Function(Map<String, dynamic> item) onEditar;

  const TablaGenericaWidget({
    Key? key,
    required this.columnas,
    required this.obtenerDatos,
    required this.onEliminar,
    required this.onEditar,
  }) : super(key: key);

  @override
  TablaGenericaWidgetState createState() => TablaGenericaWidgetState();
}

class TablaGenericaWidgetState extends State<TablaGenericaWidget> {
  final Set<int> selectedRows = {};

  /// Método para recargar la tabla
  void onGuardar() {
    setState(() {}); // Permite recargar la tabla
  }

  /// Mapea las columnas visibles con las claves internas del mapa de datos
  Map<String, String> _obtenerMapeoColumnas() {
    final mapeo = <String, String>{
      'ID': 'id',
      'USERNAME': 'username',
      'NOMBRE': 'nombre',
      'APELLIDO': 'apellido',
      'ESTADO': 'is_active',
    };
    return mapeo;
  }

  @override
  Widget build(BuildContext context) {
    final mapeoColumnas = _obtenerMapeoColumnas();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.obtenerDatos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error al cargar los datos: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No hay datos disponibles.',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final datos = snapshot.data!;
        print('Datos recibidos para la tabla: $datos'); // Debugging

        return Column(
          children: [
            // Botones de acción (EDITAR y ELIMINAR)
            if (selectedRows.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (selectedRows.length == 1)
                      CustomButton(
                        buttonText: 'EDITAR',
                        buttonColor: Colors.amber,
                        textColor: Colors.black,
                        onPressed: () {
                          final datoSeleccionado = datos.firstWhere(
                                (d) => d['id'] == selectedRows.first,
                            orElse: () => {},
                          );
                          widget.onEditar(datoSeleccionado);
                        },
                      ),
                    const SizedBox(width: 16),
                    CustomButton(
                      buttonText: 'ELIMINAR',
                      buttonColor: Colors.red,
                      textColor: Colors.white,
                      onPressed: () {
                        widget.onEliminar(selectedRows.toList());
                        setState(() {
                          selectedRows.clear();
                        });
                      },
                    ),
                  ],
                ),
              ),
            // Contenedor de la tabla
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C), // Fondo negro
                borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45, // Sombra más tenue
                    blurRadius: 10.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.all(16.0), // Espaciado interno
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  dataRowHeight: 56.0,
                  headingRowColor: MaterialStateProperty.all(const Color(0xFF2D2D3C)),
                  dataRowColor: MaterialStateProperty.all(Colors.black), // Fondo negro fijo
                  columns: widget.columnas
                      .map(
                        (titulo) => DataColumn(
                      label: Center(
                        child: Text(
                          titulo,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  )
                      .toList(),
                  rows: datos.map((dato) {
                    final isSelected = selectedRows.contains(dato['id']);
                    return DataRow(
                      selected: isSelected,
                      onSelectChanged: (selected) {
                        setState(() {
                          if (selected == true) {
                            selectedRows.add(dato['id']);
                          } else {
                            selectedRows.remove(dato['id']);
                          }
                        });
                      },
                      cells: widget.columnas.map((columna) {
                        final key = mapeoColumnas[columna] ?? columna.toLowerCase();
                        return DataCell(
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              dato[key]?.toString() ?? '',
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
