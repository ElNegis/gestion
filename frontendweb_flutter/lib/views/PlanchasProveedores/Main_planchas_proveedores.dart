import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/plancha_controller.dart';
import '../../controllers/proveedor_controller.dart'; // Importar ProveedorController
import 'List_Planchas.dart';
import 'CreacionPlanchas.dart';
import '../DummyView.dart';
import '../../widgets/ManagerOption.dart';
import 'CreacionProveedores.dart';
import '../../model/AuthHandler.dart';
import '../../model/RequestHandler.dart';
import 'List_proveedores.dart';

class PlanchasProveedores extends StatelessWidget {
  const PlanchasProveedores({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authHandler = AuthHandler(requestHandler: RequestHandler()); // Crear AuthHandler

    return FutureBuilder<void>(
      future: authHandler.initialize(), // Inicializar tokens
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Mostrando cargando
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al inicializar la autenticación')); // Mostrar error
        } else {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<PlanchaController>(
                create: (context) => PlanchaController(authHandler: authHandler),
              ),
              ChangeNotifierProvider<ProveedorController>(
                create: (context) => ProveedorController(authHandler: authHandler),
              ),
            ],
            builder: (context, _) {
              final planchaController = Provider.of<PlanchaController>(context, listen: false);
              final proveedorController = Provider.of<ProveedorController>(context, listen: false);

              return ManagerOption(
                menuItems: const [
                  "Agregar Plancha",
                  "Listado De planchas",
                  "Agregar Proveedor",
                  "Listado de Proveedores",
                ],
                views: [
                  PlanchasScreenAdd(authHandler: authHandler), // Pantalla de agregar planchas
                  ListPlanchas(planchaController: planchaController, proveedorController:proveedorController), // Listado de planchas
                  ProveedoresScreenAdd(authHandler: authHandler), // Pantalla de agregar proveedores
                  ProveedorScreen(proveedorController: proveedorController), // Listado de proveedores
                ],
                menuHeight: 120, // Ajusta la altura del menú si lo deseas
              );
            },
          );
        }
      },
    );
  }
}


