import 'package:flutter/material.dart';

class BuscadorCustom extends StatefulWidget {
  final TextEditingController buscadorController;
  final List<String> filtroOpciones;
  final void Function(String buscadorTexto, String filtroSeleccionado) onBuscar;

  const BuscadorCustom({
    Key? key,
    required this.buscadorController,
    required this.filtroOpciones,
    required this.onBuscar,
  }) : super(key: key);

  @override
  _BuscadorWidgetState createState() => _BuscadorWidgetState();
}

class _BuscadorWidgetState extends State<BuscadorCustom> {
  late String filtroSeleccionado;

  @override
  void initState() {
    super.initState();
    filtroSeleccionado = widget.filtroOpciones.first; // Filtro predeterminado
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo de texto para búsqueda
            Container(
              width: 250, // Reducir la anchura del buscador
              child: TextField(
                controller: widget.buscadorController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Buscar',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                onChanged: (value) {
                  widget.onBuscar(value, filtroSeleccionado);
                },
              ),
            ),
            const SizedBox(width: 10),
            // Dropdown para filtro
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: DropdownButton<String>(
                value: filtroSeleccionado,
                dropdownColor: Colors.grey[800],
                items: widget.filtroOpciones
                    .map(
                      (filtro) => DropdownMenuItem(
                    value: filtro,
                    child: Text(
                      filtro,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    filtroSeleccionado = value!;
                    widget.onBuscar(widget.buscadorController.text, filtroSeleccionado);
                  });
                },
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                underline: const SizedBox(), // Quitar línea inferior
              ),
            ),
          ],
        ),
      ),
    );
  }
}
