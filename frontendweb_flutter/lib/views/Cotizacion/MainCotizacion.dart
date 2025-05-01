import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/CalculoController.dart';
import '../../controllers/ClienteController.dart';
import '../../model/AuthHandler.dart';
import '../../model/RequestHandler.dart';
import '../../widgets/ManagerOption.dart';
import 'CalculoCotizacionScreen.dart';


class MainCotizacion extends StatelessWidget {
  const MainCotizacion({Key? key}) : super(key: key);

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
              ChangeNotifierProvider(
                create: (context) => CalculoController(authHandler: authHandler),
              ),
              ChangeNotifierProvider(
                create: (context) => ClienteController(authHandler: authHandler),
              ),
            ],
            builder: (context, _) {
              final calculoController = Provider.of<CalculoController>(context, listen: false);

              return ManagerOption(
                menuItems: const ['Cálculo de Piezas'],
                views: [
                  CalculoPiezasScreen(
                    calculoController: calculoController,
                  ),
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
