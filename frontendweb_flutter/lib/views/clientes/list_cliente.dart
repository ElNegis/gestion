import 'package:flutter/material.dart';
import '../../widgets/text/Buscador_widget.dart';
import '../../widgets/tablas/tabla_generica_widget.dart';
import '../../controllers/ClienteController.dart';

class ClienteScreen extends StatefulWidget {
  final ClienteController clienteController;

  const ClienteScreen({Key? key, required this.clienteController}) : super(key: key);

  @override
  _ClienteScreenState createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  final TextEditingController buscadorController = TextEditingController();
  List<Map<String, dynamic>> clientesOriginales = [];
  List<Map<String, dynamic>> clientesFiltrados = [];
  final GlobalKey<TablaGenericaWidgetState> tablaKey = GlobalKey<TablaGenericaWidgetState>();

  @override
  void initState() {
    super.initState();
    _cargarClientes();
  }

  Future<void> _cargarClientes() async {
    await widget.clienteController.fetchClientes();
    setState(() {
      // Mapear correctamente los datos con el campo 'id' y demás
      clientesOriginales = widget.clienteController.clientes.map((cliente) {
        return {
          'id': cliente['id'], // Campo id
          'codigo_clien': cliente['codigo_clien'], // Código cliente
          'nombre': cliente['nombre'],
          'apellido': cliente['apellido'],
          'telefono': cliente['telefono'], // Campo teléfono incluido
          'email': cliente['email'],
        };
      }).toList();

      clientesFiltrados = List.from(clientesOriginales);
    });
  }

  void _filtrarClientes(String texto, String filtro) {
    setState(() {
      clientesFiltrados = clientesOriginales.where((cliente) {
        final valor = cliente[filtro]?.toString().toLowerCase() ?? '';
        return valor.contains(texto.toLowerCase());
      }).toList();
    });
  }

  Future<void> _eliminarClientes(List<int> ids) async {
    for (var id in ids) {
      await widget.clienteController.eliminarCliente(id);
    }
    await _cargarClientes();
    tablaKey.currentState?.onGuardar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D3C),
      appBar: AppBar(
        title: const Text('Clientes'),
        backgroundColor: const Color(0xFF2D2D3C),
      ),
      body: Column(
        children: [
          // Componente de búsqueda
          BuscadorCustom(
            buscadorController: buscadorController,
            filtroOpciones: const ['id', 'codigo_clien', 'nombre', 'apellido', 'telefono', 'email'],
            onBuscar: _filtrarClientes,
          ),
          // Tabla genérica
          Expanded(
            child: TablaGenericaWidget(
              key: tablaKey,
              columnas: const ['ID', 'CÓDIGO', 'NOMBRE', 'APELLIDO', 'TELÉFONO', 'EMAIL'], // Incluye teléfono y código cliente
              obtenerDatos: () async => clientesFiltrados,
              onEliminar: _eliminarClientes,
              onEditar: (cliente) async {
                // Controladores para editar los campos
                final TextEditingController nombreController =
                TextEditingController(text: cliente['nombre']);
                final TextEditingController apellidoController =
                TextEditingController(text: cliente['apellido']);
                final TextEditingController telefonoController =
                TextEditingController(text: cliente['telefono']);
                final TextEditingController emailController =
                TextEditingController(text: cliente['email']);

                final resultado = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Editar Cliente'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: TextEditingController(
                            text: cliente['codigo_clien'], // Mostrar código cliente
                          ),
                          enabled: false, // Campo no editable
                          decoration: const InputDecoration(
                            hintText: 'Código Cliente',
                            labelText: 'Código Cliente',
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: nombreController,
                          decoration: const InputDecoration(hintText: 'Nombre'),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: apellidoController,
                          decoration: const InputDecoration(hintText: 'Apellido'),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: telefonoController,
                          decoration: const InputDecoration(hintText: 'Teléfono'),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(hintText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final id = cliente['id'];
                          final data = {
                            'nombre': nombreController.text,
                            'apellido': apellidoController.text,
                            'telefono': telefonoController.text,
                            'email': emailController.text,
                          };
                          final success = await widget.clienteController.actualizarCliente(id, data);
                          Navigator.pop(context, success);
                        },
                        child: const Text('Guardar'),
                      ),
                    ],
                  ),
                );

                if (resultado == true) {
                  await _cargarClientes();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
