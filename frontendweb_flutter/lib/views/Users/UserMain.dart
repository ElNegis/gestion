import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/UserController.dart';
import '../../controllers/UserRoleController.dart';
import '../../model/AuthHandler.dart';
import '../../model/RequestHandler.dart';
import '../../widgets/ManagerOption.dart';
import 'CreacionUser.dart';
import './GestionUsuariosScreen.dart';
import 'ListUser.dart';

class UserMain extends StatelessWidget {
  const UserMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authHandler = AuthHandler(requestHandler: RequestHandler());

    return FutureBuilder<void>(
      future: authHandler.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al inicializar la autenticación'));
        } else {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<UserController>(
                create: (context) => UserController(authHandler: authHandler),
              ),
              ChangeNotifierProvider<UserRoleController>(
                create: (context) => UserRoleController(authHandler: authHandler),
              ),
            ],
            builder: (context, _) {
              final userController = Provider.of<UserController>(context, listen: false);
              final userRoleController = Provider.of<UserRoleController>(context, listen: false);

              return ManagerOption(
                menuItems: const ['Crear Usuario', 'Listado de Usuarios', 'Gestión de Roles'],
                views: [
                  UserCreationScreen(authHandler: authHandler),
                  ListUserScreen(userController: userController),
                  GestionUsuariosScreen(userRoleController: userRoleController), // Aquí se pasa el controlador
                ],
                menuHeight: 120,
              );
            },
          );
        }
      },
    );
  }
}
