import 'package:flutter/material.dart';
import 'EditarPlanchasModal.dart';
import '../../widgets/text/Buscador_widget.dart';
import '../../widgets/tablas/tabla_generica_widget.dart';
import '../../controllers/plancha_controller.dart';
import '../../controllers/proveedor_controller.dart';

class ListPlanchas extends StatefulWidget {
  final PlanchaController planchaController;
  final ProveedorController proveedorController;

  const ListPlanchas({
    Key? key,
    required this.planchaController,
    required this.proveedorController,
  }) : super(key: key);

  @override
  _ListPlanchasState createState() => _ListPlanchasState();
}

class _ListPlanchasState extends State<ListPlanchas> {
  final TextEditingController buscadorController = TextEditingController();
  List<Map<String, dynamic>> planchasOriginales = [];
  List<Map<String, dynamic>> planchasFiltradas = [];
  final GlobalKey<TablaGenericaWidgetState> tablaKey =
  GlobalKey<TablaGenericaWidgetState>();

  @override
  void initState() {
    super.initState();
    _cargarPlanchas();
  }

  Future<void> _cargarPlanchas() async {
    try {
      await widget.planchaController.fetchPlanchas(context);
      setState(() {
        planchasOriginales = widget.planchaController.planchas;
        planchasFiltradas = List.from(planchasOriginales);
      });
    } catch (e) {
      print('Error al cargar las planchas: $e');
    }
  }

  void _filtrarPlanchas(String texto, String filtro) {
    setState(() {
      planchasFiltradas = planchasOriginales.where((plancha) {
        final valor = plancha[filtro]?.toString().toLowerCase() ?? '';
        return valor.contains(texto.toLowerCase());
      }).toList();
    });
  }

  Future<void> _eliminarPlanchas(List<int> ids) async {
    for (var id in ids) {
      await widget.planchaController.eliminarPlancha(context, id);
    }
    await _cargarPlanchas();
    tablaKey.currentState?.onGuardar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro
      appBar: AppBar(
        title: const Text('Planchas'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black, // Fondo negro en AppBar
      ),
      body: Column(
        children: [
          Container(
            color: Colors.black, // Fondo negro para el buscador
            child: BuscadorCustom(
              buscadorController: buscadorController,
              filtroOpciones: const ['id', 'espesor', 'largo', 'ancho'],
              onBuscar: _filtrarPlanchas,
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.black, // Fondo negro para la tabla
              child: TablaGenericaWidget(
                key: tablaKey,
                columnas: const ['ID', 'ESPESOR', 'LARGO', 'ANCHO', 'PRECIO', 'PROVEEDOR'],
                obtenerDatos: () async => planchasFiltradas,
                onEliminar: _eliminarPlanchas,
                onEditar: (plancha) async {
                  final resultado = await showDialog<bool>(
                    context: context,
                    builder: (context) => EditarPlanchasModal(
                      plancha: plancha,
                      proveedorController: widget.proveedorController,
                      onGuardar: (datos) async {
                        final id = plancha['id'];
                        return await widget.planchaController.editarPlancha(context, id, datos);
                      },
                    ),
                  );

                  if (resultado == true) {
                    await _cargarPlanchas();
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
