import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/ClienteController.dart'; // Controlador de Clientes
import '../../model/AuthHandler.dart'; // Manejo de autenticación
import '../../model/RequestHandler.dart'; // Request Handler
import '../../widgets/ManagerOption.dart'; // Widget del menú
import 'create_cliente.dart'; // Pantalla para crear clientes
import 'list_cliente.dart'; // Pantalla para listar clientes

class MainClientes extends StatelessWidget {
  const MainClientes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authHandler = AuthHandler(requestHandler: RequestHandler());

    return FutureBuilder<void>(
      future: authHandler.initialize(), // Inicialización del AuthHandler
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Mostrando cargando
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al inicializar la autenticación')); // Error en la autenticación
        } else {
          return ChangeNotifierProvider<ClienteController>(
            create: (context) => ClienteController(authHandler: authHandler),
            builder: (context, _) {
              final clienteController =
              Provider.of<ClienteController>(context, listen: false);

              return ManagerOption(
                menuItems: const [
                  'Crear Cliente', // Primera opción del menú
                  'Listado de Clientes', // Segunda opción del menú
                ],
                views: [
                  ClienteScreenAdd(authHandler: authHandler), // Pantalla para crear clientes
                  ClienteScreen(clienteController: clienteController), // Pantalla para listar clientes
                ],
                menuHeight: 120, // Altura del menú
              );
            },
          );
        }
      },
    );
  }
}
