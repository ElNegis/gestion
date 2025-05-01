import 'package:flutter/material.dart';
import 'EditarProveedoresModal.dart'; // Importamos el modal modularizado
import '../../widgets/text/Buscador_widget.dart';
import '../../widgets/tablas/tabla_generica_widget.dart';
import '../../controllers/proveedor_controller.dart';

class ProveedorScreen extends StatefulWidget {
  final ProveedorController proveedorController;

  const ProveedorScreen({Key? key, required this.proveedorController})
      : super(key: key);

  @override
  _ProveedorScreenState createState() => _ProveedorScreenState();
}

class _ProveedorScreenState extends State<ProveedorScreen> {
  final TextEditingController buscadorController = TextEditingController();
  List<Map<String, dynamic>> proveedoresOriginales = [];
  List<Map<String, dynamic>> proveedoresFiltrados = [];
  final GlobalKey<TablaGenericaWidgetState> tablaKey =
  GlobalKey<TablaGenericaWidgetState>();

  @override
  void initState() {
    super.initState();
    _cargarProveedores();
  }

  Future<void> _cargarProveedores() async {
    try {
      await widget.proveedorController.fetchProveedores();
      setState(() {
        proveedoresOriginales = widget.proveedorController.proveedores
            .map((proveedor) {
          return {
            'id': proveedor['id'],
            'nombre': proveedor['nombre'],
          };
        }).toList();
        proveedoresFiltrados = List.from(proveedoresOriginales);
      });
    } catch (e) {
      print('Error al cargar los proveedores: $e');
    }
  }

  void _filtrarProveedores(String texto, String filtro) {
    setState(() {
      proveedoresFiltrados = proveedoresOriginales.where((proveedor) {
        final valor = proveedor[filtro]?.toString().toLowerCase() ?? '';
        return valor.contains(texto.toLowerCase());
      }).toList();
    });
  }

  Future<void> _eliminarProveedores(List<int> ids) async {
    for (var id in ids) {
      await widget.proveedorController.eliminarProveedor(id);
    }
    await _cargarProveedores();
    tablaKey.currentState?.onGuardar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro
      appBar: AppBar(
        title: const Text('Proveedores'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black, // Fondo negro en AppBar
      ),
      body: Column(
        children: [
          // Buscador
          Container(
            color: Colors.black, // Fondo negro para el buscador
            child: BuscadorCustom(
              buscadorController: buscadorController,
              filtroOpciones: const ['id', 'nombre'],
              onBuscar: _filtrarProveedores,
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.black, // Fondo negro para la tabla
              child: TablaGenericaWidget(
                key: tablaKey,
                columnas: const ['ID', 'NOMBRE'],
                obtenerDatos: () async {
                  return proveedoresFiltrados;
                },
                onEliminar: _eliminarProveedores,
                onEditar: (proveedor) async {
                  final resultado = await showDialog<bool>(
                    context: context,
                    builder: (context) => EditarProveedoresModal(
                      proveedor: proveedor, // Proveedor completo enviado
                      onGuardar: (datos) async {
                        final id = proveedor['id'];
                        final nuevoNombre = datos['nombre'];
                        return await widget.proveedorController
                            .editarProveedor(id, nuevoNombre);
                      },
                    ),
                  );

                  if (resultado == true) {
                    await _cargarProveedores();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
