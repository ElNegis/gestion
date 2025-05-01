import 'package:flutter/material.dart';
import 'package:frontendweb_flutter/widgets/botones/CustomButton.dart';
import '../../controllers/UserController.dart';
import '../../widgets/text/Buscador_widget.dart';
import '../../widgets/tablas/tabla_generica_widget.dart';
import 'EditUserModal.dart';
import 'logs_modal.dart';
import 'logs_modal_seguridad.dart';

class ListUserScreen extends StatefulWidget {
  final UserController userController;

  const ListUserScreen({Key? key, required this.userController}) : super(key: key);

  @override
  _ListUserScreenState createState() => _ListUserScreenState();
}

class _ListUserScreenState extends State<ListUserScreen> {
  final TextEditingController buscadorController = TextEditingController();
  List<Map<String, dynamic>> usersOriginales = [];
  List<Map<String, dynamic>> usersFiltrados = [];
  final GlobalKey<TablaGenericaWidgetState> tablaKey = GlobalKey<TablaGenericaWidgetState>();

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  Future<void> _cargarUsuarios() async {
    await widget.userController.fetchUsers(context);
    setState(() {
      usersOriginales = widget.userController.users.map((user) {
        return {
          'id': user['id'],
          'username': user['username'],
          'nombre': user['nombre'],
          'apellido': user['apellido'],
          'is_active': user['is_active'] ? 'Activo' : 'Inactivo',
        };
      }).toList();
      usersFiltrados = List.from(usersOriginales);
    });
  }

  void _filtrarUsuarios(String texto, String filtro) {
    setState(() {
      usersFiltrados = usersOriginales.where((user) {
        final valor = user[filtro]?.toString().toLowerCase() ?? '';
        return valor.contains(texto.toLowerCase());
      }).toList();
    });
  }

  Future<void> _eliminarUsuarios(List<int> ids) async {
    for (var id in ids) {
      await widget.userController.deleteUser(context, id);
    }
    await _cargarUsuarios();
    tablaKey.currentState?.onGuardar();
  }

  Future<void> _editarUsuario(Map<String, dynamic> user) async {
    final resultado = await showDialog<bool>(
      context: context,
      builder: (context) => EditUserModal(
        user: user,
        onGuardar: (datos) async {
          return await widget.userController.updateUser(
            context,
            datos['id'],
            datos['nombre'],
            datos['apellido'],
            datos['password'],
          );
        },
      ),
    );

    if (resultado == true) {
      await _cargarUsuarios();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Usuarios'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Buscador
              BuscadorCustom(
                buscadorController: buscadorController,
                filtroOpciones: const ['id', 'username', 'nombre', 'apellido', 'is_active'],
                onBuscar: _filtrarUsuarios,
              ),
              // Tabla de usuarios
              Expanded(
                child: TablaGenericaWidget(
                  key: tablaKey,
                  columnas: const ['ID', 'USERNAME', 'NOMBRE', 'APELLIDO', 'ESTADO'],
                  obtenerDatos: () async => usersFiltrados,
                  onEliminar: _eliminarUsuarios,
                  onEditar: _editarUsuario,
                ),
              ),
            ],
          ),
          // Posiciona los botones en la esquina inferior izquierda
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOutlinedButton(
                  text: 'Mostrar Logs Aplicativos',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return LogsModal(userController: widget.userController);
                      },
                    );
                  },
                ),
                const SizedBox(height: 8),
                _buildOutlinedButton(
                  text: 'Mostrar Logs Seguridad',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return LogsModalSecurity(userController: widget.userController);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Botón personalizado con borde verde y fondo negro
  Widget _buildOutlinedButton({required String text, required VoidCallback onPressed}) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.black, // Fondo negro
        side: const BorderSide(color: Colors.green, width: 2.0), // Borde verde
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.green, fontSize: 16), // Texto verde
      ),
    );
  }
}
