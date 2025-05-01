import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/RolesController.dart';
import '../../controllers/PermissionController.dart'; // Cambiar nombre correcto del controlador
import '../../model/AuthHandler.dart';
import '../../model/RequestHandler.dart';
import '../../widgets/ManagerOption.dart';
import 'CreacionRoles.dart';
import 'GestionPermisosScreen.dart'; // Importar la pantalla de gestión de permisos
import 'ListRolesScreen.dart';

class MainRoles extends StatelessWidget {
  const MainRoles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authHandler = AuthHandler(requestHandler: RequestHandler());

    return FutureBuilder<void>(
      future: authHandler.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al inicializar la autenticación: ${snapshot.error}'));
        } else {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<RolesController>(
                create: (context) => RolesController(authHandler: authHandler),
              ),
              ChangeNotifierProvider<PermissionController>(
                create: (context) => PermissionController(authHandler: authHandler),
              ),
            ],
            child: Builder(
              builder: (context) {
                final rolesController = Provider.of<RolesController>(context, listen: false);
                final permisosController = Provider.of<PermissionController>(context, listen: false);

                return ManagerOption(
                  menuItems: const ['Crear Rol', 'Listado de Roles', 'Gestión de Permisos'],
                  views: [
                    CreacionRolesScreen(authHandler: authHandler),
                    ListRolesScreen(rolesController: rolesController),
                    GestionPermisosScreen(permissionController: permisosController), // Agregamos esta pestaña
                  ],
                  menuHeight: 120,
                );
              },
            ),
          );
        }
      },
    );
  }
}
