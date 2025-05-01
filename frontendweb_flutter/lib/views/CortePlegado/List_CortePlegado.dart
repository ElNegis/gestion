import 'package:flutter/material.dart';
import '../../widgets/text/Buscador_widget.dart';
import '../../widgets/tablas/tabla_generica_widget.dart';
import '../../controllers/CortePlegado/corte_plegado_controller.dart';
import 'EditarCortePlegadoModal.dart';

class CortePlegadoScreen extends StatefulWidget {
  final CortePlegadoController cortePlegadoController;

  const CortePlegadoScreen({Key? key, required this.cortePlegadoController}) : super(key: key);

  @override
  _CortePlegadoScreenState createState() => _CortePlegadoScreenState();
}

class _CortePlegadoScreenState extends State<CortePlegadoScreen> {
  final TextEditingController buscadorController = TextEditingController();
  List<Map<String, dynamic>> cortePlegadoOriginales = [];
  List<Map<String, dynamic>> cortePlegadoFiltrados = [];
  final GlobalKey<TablaGenericaWidgetState> tablaKey = GlobalKey<TablaGenericaWidgetState>();

  @override
  void initState() {
    super.initState();
    _cargarCortePlegado();
  }

  Future<void> _cargarCortePlegado() async {
    await widget.cortePlegadoController.fetchCortePlegado();
    setState(() {
      cortePlegadoOriginales = widget.cortePlegadoController.cortePlegadoLista.map((corte) {
        return {
          'id': corte['id'],
          'espesor': corte['espesor'],
          'largo': corte['largo'],
          'precio': corte['precio'],
        };
      }).toList();
      cortePlegadoFiltrados = List.from(cortePlegadoOriginales);
    });
  }

  void _filtrarCortePlegado(String texto, String filtro) {
    setState(() {
      cortePlegadoFiltrados = cortePlegadoOriginales.where((corte) {
        final valor = corte[filtro]?.toString().toLowerCase() ?? '';
        return valor.contains(texto.toLowerCase());
      }).toList();
    });
  }

  Future<void> _eliminarCortePlegado(List<int> ids) async {
    for (var id in ids) {
      await widget.cortePlegadoController.eliminarCortePlegado(id);
    }
    await _cargarCortePlegado();
    tablaKey.currentState?.onGuardar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro
      appBar: AppBar(
        title: const Text('Corte Plegado'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black, // Fondo negro en AppBar
      ),
      body: Column(
        children: [
          // Buscador con fondo negro
          Container(
            color: Colors.black,
            child: BuscadorCustom(
              buscadorController: buscadorController,
              filtroOpciones: const ['id', 'espesor', 'largo', 'precio'],
              onBuscar: _filtrarCortePlegado,
            ),
          ),
          // Tabla con fondo negro
          Expanded(
            child: Container(
              color: Colors.black,
              child: TablaGenericaWidget(
                key: tablaKey,
                columnas: const ['ID', 'ESPESOR', 'LARGO', 'PRECIO'],
                obtenerDatos: () async => cortePlegadoFiltrados,
                onEliminar: _eliminarCortePlegado,
                onEditar: (corte) async {
                  final resultado = await showDialog<bool>(
                    context: context,
                    builder: (context) => EditarCortePlegadoModal(
                      corte: corte,
                      onGuardar: (datos) async {
                        final success = await widget.cortePlegadoController.editarCortePlegado(
                          corte['id'],
                          datos,
                        );
                        if (success) await _cargarCortePlegado();
                        return success;
                      },
                    ),
                  );
                  if (resultado == true) {
                    await _cargarCortePlegado();
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
