import 'package:flutter/material.dart';
import '../service/ProoveedorService.dart';
import '../model/AuthHandler.dart';

class ProveedorDropdown extends StatefulWidget {
  final AuthHandler authHandler; // Nuevo: AuthHandler para manejar tokens
  final int? idProveedorSeleccionado;
  final Function(int?) onChanged;

  const ProveedorDropdown({
    Key? key,
    required this.authHandler,
    this.idProveedorSeleccionado,
    required this.onChanged,
  }) : super(key: key);

  @override
  _ProveedorDropdownState createState() => _ProveedorDropdownState();
}

class _ProveedorDropdownState extends State<ProveedorDropdown> {
  late Future<List<Map<String, dynamic>>> proveedoresFuture;

  @override
  void initState() {
    super.initState();
    proveedoresFuture = ProveedorService.ObtenerProveedores(widget.authHandler); // Usar AuthHandler
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: proveedoresFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: const TextStyle(color: Colors.red),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text(
            'No se encontraron proveedores',
            style: TextStyle(color: Colors.white),
          );
        } else {
          final proveedores = snapshot.data!;
          return DropdownButton<int>(
            value: widget.idProveedorSeleccionado,
            items: proveedores
                .map(
                  (proveedor) => DropdownMenuItem<int>(
                value: proveedor['id'],
                child: Text(
                  proveedor['nombre'],
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            )
                .toList(),
            onChanged: (value) {
              widget.onChanged(value);
            },
            hint: const Text("Selecciona un proveedor"),
            dropdownColor: Colors.white,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          );
        }
      },
    );
  }
}
