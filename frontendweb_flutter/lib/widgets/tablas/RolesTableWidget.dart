import 'package:flutter/material.dart';

class RolesTableWidget extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> Function() obtenerRoles;
  final Future<void> Function(int id) onEliminar;
  final Future<void> Function(Map<String, dynamic> item) onEditar;

  const RolesTableWidget({
    Key? key,
    required this.obtenerRoles,
    required this.onEliminar,
    required this.onEditar,
  }) : super(key: key);

  @override
  _RolesTableWidgetState createState() => _RolesTableWidgetState();
}

class _RolesTableWidgetState extends State<RolesTableWidget> {
  final Set<int> selectedRows = {};

  /// Método para recargar la tabla
  void onGuardar() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.obtenerRoles(),
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
        } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No hay roles disponibles.',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final roles = snapshot.data!;
        print('Roles renderizados en la tabla: $roles'); // Depuración

        return Column(
          children: [
            if (selectedRows.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (selectedRows.length == 1)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                        onPressed: () async {
                          final idSeleccionado = selectedRows.first;
                          final itemSeleccionado = roles.firstWhere((rol) => rol['id'] == idSeleccionado);
                          await widget.onEditar(itemSeleccionado);
                          onGuardar();
                        },
                        child: const Text(
                          'EDITAR',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () async {
                        for (final id in selectedRows) {
                          await widget.onEliminar(id);
                        }
                        setState(() {
                          selectedRows.clear();
                        });
                        onGuardar();
                      },
                      child: const Text('ELIMINAR', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 10.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  dataRowHeight: 56.0,
                  headingRowColor: MaterialStateProperty.all(const Color(0xFF2D2D3C)),
                  dataRowColor: MaterialStateProperty.all(const Color(0xFF1E1E2C)),
                  columns: const [
                    DataColumn(
                      label: Center(
                        child: Text(
                          'ID',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Center(
                        child: Text(
                          'NOMBRE',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Center(
                        child: Text(
                          'DESCRIPCIÓN',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],

                  rows: roles.map((rol) {
                    final isSelected = selectedRows.contains(rol['id']);
                    return DataRow(
                      selected: isSelected,
                      onSelectChanged: (selected) {
                        setState(() {
                          if (selected == true) {
                            selectedRows.add(rol['id']);
                          } else {
                            selectedRows.remove(rol['id']);
                          }
                        });
                      },
                      cells: [
                        DataCell(Text('${rol['id']}', style: const TextStyle(color: Colors.white))),
                        DataCell(Text(rol['name'] ?? '', style: const TextStyle(color: Colors.white))),
                        DataCell(Text(rol['description'] ?? '', style: const TextStyle(color: Colors.white))),
                      ],
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