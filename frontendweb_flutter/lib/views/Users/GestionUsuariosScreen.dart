import 'package:flutter/material.dart';
import '../../controllers/UserRoleController.dart';
import 'UserRoleModal.dart';

class GestionUsuariosScreen extends StatefulWidget {
  final UserRoleController userRoleController;

  const GestionUsuariosScreen({Key? key, required this.userRoleController}) : super(key: key);

  @override
  _GestionUsuariosScreenState createState() => _GestionUsuariosScreenState();
}

class _GestionUsuariosScreenState extends State<GestionUsuariosScreen> {
  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    await widget.userRoleController.fetchUsersWithRoles(context);
    await widget.userRoleController.fetchUsersWithoutRoles(context);
    await widget.userRoleController.fetchRoles(context);
    setState(() {});
  }

  void _mostrarDialogoAsignarRol(int userId) async {
    await widget.userRoleController.fetchRoles(context);
    showDialog(
      context: context,
      builder: (context) => UserRoleModal(
        title: 'Seleccionar Rol para Asignar',
        roles: widget.userRoleController.roles,
        onSelected: (roleId) async {
          final success = await widget.userRoleController.assignRoleToUser(context, userId, roleId);
          if (success) {
            _cargarDatos();
          }
        },
      ),
    );
  }

  void _mostrarDialogoEliminarRol(int userId, List<dynamic> rolesActuales) {
    showDialog(
      context: context,
      builder: (context) => UserRoleModal(
        title: 'Seleccionar Rol para Eliminar',
        roles: rolesActuales,
        onSelected: (roleId) async {
          final success = await widget.userRoleController.removeRoleFromUser(context, userId, roleId);
          if (success) {
            _cargarDatos();
          }
        },
      ),
    );
  }

  Widget _crearTabla({
    required List<Map<String, dynamic>> usuarios,
    required bool conRoles,
  }) {
    if (usuarios.isEmpty) {
      return const Center(child: Text('No hay usuarios disponibles.', style: TextStyle(color: Colors.white)));
    }

    return DataTable(
      columns: [
        DataColumn(label: Text('ID', style: _estiloTexto())),
        DataColumn(label: Text('Usuario', style: _estiloTexto())),
        DataColumn(label: Text('Nombre', style: _estiloTexto())),
        if (conRoles) DataColumn(label: Text('Roles', style: _estiloTexto())),
        DataColumn(label: Text('Acciones', style: _estiloTexto())),
      ],
      rows: usuarios.map((usuario) {
        final roles = conRoles
            ? (usuario['roles'] as List<dynamic>).map((rol) => rol['name']).join(', ')
            : null;

        return DataRow(cells: [
          DataCell(Text('${usuario['id']}', style: const TextStyle(color: Colors.white))),
          DataCell(Text(usuario['username'], style: const TextStyle(color: Colors.white))),
          DataCell(Text('${usuario['nombre']} ${usuario['apellido']}', style: const TextStyle(color: Colors.white))),
          if (conRoles) DataCell(Text(roles!, style: const TextStyle(color: Colors.white))),
          DataCell(
            Row(
              children: [
                _botonNeon(
                  texto: 'Asignar',
                  colorNeon: Colors.cyan,
                  onPressed: () => _mostrarDialogoAsignarRol(usuario['id']),
                ),
                if (conRoles) ...[
                  const SizedBox(width: 8),
                  _botonNeon(
                    texto: 'Eliminar',
                    colorNeon: Colors.pinkAccent,
                    onPressed: () => _mostrarDialogoEliminarRol(usuario['id'], usuario['roles']),
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
          'Gestión de Roles de Usuarios',
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
              'Usuarios con Roles',
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
                usuarios: widget.userRoleController.usersWithRoles,
                conRoles: true,
              ),
            ),
          ),
          const Divider(color: Colors.white),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Usuarios sin Roles',
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
                usuarios: widget.userRoleController.usersWithoutRoles,
                conRoles: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
