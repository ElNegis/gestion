import 'package:flutter/material.dart';
import '../../controllers/PermissionController.dart';
import 'PermissionModal.dart';

class GestionPermisosScreen extends StatefulWidget {
  final PermissionController permissionController;

  const GestionPermisosScreen({Key? key, required this.permissionController}) : super(key: key);

  @override
  _GestionPermisosScreenState createState() => _GestionPermisosScreenState();
}

class _GestionPermisosScreenState extends State<GestionPermisosScreen> {
  final GlobalKey _tablaRolesConPermisosKey = GlobalKey();
  final GlobalKey _tablaRolesSinPermisosKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    await widget.permissionController.fetchRolesWithPermissions(context);
    await widget.permissionController.fetchRolesWithoutPermissions(context);
    await widget.permissionController.fetchAllPermissions(context);
    setState(() {});
  }

  void _mostrarDialogoAsignarPermiso(int roleId) {
    showDialog(
      context: context,
      builder: (context) => PermissionModal(
        title: 'Seleccionar Permiso para Asignar',
        permissions: widget.permissionController.allPermissions,
        onSelected: (permissionId) async {
          final success = await widget.permissionController.assignPermission(context, roleId, permissionId);
          if (success) {
            _cargarDatos();
          }
        },
      ),
    );
  }

  void _mostrarDialogoEliminarPermiso(int roleId, List<dynamic> permisosActuales) {
    showDialog(
      context: context,
      builder: (context) => PermissionModal(
        title: 'Seleccionar Permiso para Eliminar',
        permissions: permisosActuales,
        onSelected: (permissionId) async {
          final success = await widget.permissionController.removePermission(context, roleId, permissionId);
          if (success) {
            _cargarDatos();
          }
        },
      ),
    );
  }

  Widget _crearTabla({
    required List<Map<String, dynamic>> roles,
    required bool conPermisos,
  }) {
    if (roles.isEmpty) {
      return const Center(child: Text('No hay roles disponibles.', style: TextStyle(color: Colors.white)));
    }

    return DataTable(
      columns: [
        DataColumn(label: Text('ID', style: _estiloTexto())),
        DataColumn(label: Text('Rol', style: _estiloTexto())),
        if (conPermisos) DataColumn(label: Text('Permisos', style: _estiloTexto())),
        DataColumn(label: Text('Acciones', style: _estiloTexto())),
      ],
      rows: roles.map((rol) {
        final permisos = conPermisos
            ? (rol['permisos'] as List<dynamic>).map((permiso) => permiso['name']).join(', ')
            : null;

        return DataRow(cells: [
          DataCell(Text('${rol['id']}', style: const TextStyle(color: Colors.white))),
          DataCell(Text(rol['name'], style: const TextStyle(color: Colors.white))),
          if (conPermisos) DataCell(Text(permisos!, style: const TextStyle(color: Colors.white))),
          DataCell(
            Row(
              children: [
                _botonNeon(
                  texto: 'Asignar',
                  colorNeon: Colors.cyan,
                  onPressed: () => _mostrarDialogoAsignarPermiso(rol['id']),
                ),
                if (conPermisos) ...[
                  const SizedBox(width: 8),
                  _botonNeon(
                    texto: 'Eliminar',
                    colorNeon: Colors.pinkAccent,
                    onPressed: () => _mostrarDialogoEliminarPermiso(rol['id'], rol['permisos']),
                  ),
                ],
              ],
            ),
          ),
        ]);
      }).toList(),
    );
  }

  Widget _botonNeon({required String texto, required Color colorNeon, required VoidCallback onPressed}) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: colorNeon, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        shadowColor: colorNeon,
      ),
      onPressed: onPressed,
      child: Text(texto, style: TextStyle(color: colorNeon, fontWeight: FontWeight.bold)),
    );
  }


  TextStyle _estiloTexto() {
    return const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.cyanAccent);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestión de Permisos',
          style: TextStyle(fontFamily: 'PressStart2P', color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF121212),
      ),
      backgroundColor: const Color(0xFF121212),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Roles con Permisos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
                fontFamily: 'PressStart2P',
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _crearTabla(
                roles: widget.permissionController.rolesWithPermissions,
                conPermisos: true,
              ),
            ),
          ),
          const Divider(color: Colors.white),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Roles sin Permisos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
                fontFamily: 'PressStart2P',
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _crearTabla(
                roles: widget.permissionController.rolesWithoutPermissions,
                conPermisos: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
