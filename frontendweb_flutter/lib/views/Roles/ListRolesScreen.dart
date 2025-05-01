import 'package:flutter/material.dart';
import '../../widgets/text/Buscador_widget.dart';
import '../../widgets/tablas/RolesTableWidget.dart';
import '../../controllers/RolesController.dart';
import 'RolesModal.dart';

class ListRolesScreen extends StatefulWidget {
  final RolesController rolesController;

  const ListRolesScreen({Key? key, required this.rolesController}) : super(key: key);

  @override
  _ListRolesScreenState createState() => _ListRolesScreenState();
}

class _ListRolesScreenState extends State<ListRolesScreen> {
  final TextEditingController buscadorController = TextEditingController();
  List<Map<String, dynamic>> rolesOriginales = [];
  List<Map<String, dynamic>> rolesFiltrados = [];

  @override
  void initState() {
    super.initState();
    _cargarRoles();
  }

  Future<void> _cargarRoles() async {
    await widget.rolesController.fetchRoles(context);
    print('Roles obtenidos del controlador: ${widget.rolesController.roles}');
    setState(() {
      rolesOriginales = widget.rolesController.roles;
      rolesFiltrados = List.from(rolesOriginales);
    });
  }

  void _filtrarRoles(String texto, String filtro) {
    final key = {
      'ID': 'id',
      'NOMBRE': 'name',
      'DESCRIPCIÓN': 'description',
    }[filtro];
    setState(() {
      rolesFiltrados = rolesOriginales.where((rol) {
        final valor = rol[key]?.toString().toLowerCase() ?? '';
        return valor.contains(texto.toLowerCase());
      }).toList();
    });
  }

  Future<void> _eliminarRoles(int id) async {
    print('Eliminando rol con ID: $id...');
    await widget.rolesController.deleteRole(context, id);
    await _cargarRoles();
  }

  Future<void> _editarRol(Map<String, dynamic> rol) async {
    print('Editando rol: $rol');
    final resultado = await showDialog<bool>(
      context: context,
      builder: (context) => EditarRolesModal(
        rol: rol, // Se pasa el rol actual
        onGuardar: (datos) async {
          final id = datos['id'];
          final name = datos['name'];
          final description = datos['description'];
          return await widget.rolesController.updateRole(context, id, name, description);
        },
      ),
    );
    if (resultado == true) {
      await _cargarRoles(); // Recarga la lista de roles después de guardar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro
      appBar: AppBar(
        title: const Text('Listado de Roles'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black, // Fondo del AppBar negro
      ),
      body: Column(
        children: [
          Container(
            color: Colors.black, // Fondo negro también para el buscador
            child: BuscadorCustom(
              buscadorController: buscadorController,
              filtroOpciones: const ['ID', 'NOMBRE', 'DESCRIPCIÓN'],
              onBuscar: _filtrarRoles,
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.black, // Fondo negro en toda la pantalla
              child: RolesTableWidget(
                obtenerRoles: () async {
                  print('Obteniendo datos para la tabla...');
                  return rolesFiltrados;
                },
                onEliminar: _eliminarRoles,
                onEditar: _editarRol,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
