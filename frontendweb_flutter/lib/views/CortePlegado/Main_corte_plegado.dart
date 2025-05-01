import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/CortePlegado/corte_plegado_controller.dart';
import '../../model/AuthHandler.dart';
import '../../model/RequestHandler.dart';
import '../../widgets/ManagerOption.dart';
import 'CreacionCortePlegado.dart';
import 'List_CortePlegado.dart';

class MainCortePlegado extends StatelessWidget {
  const MainCortePlegado({Key? key}) : super(key: key);

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
          return ChangeNotifierProvider<CortePlegadoController>(
            create: (context) => CortePlegadoController(authHandler: authHandler),
            builder: (context, _) {
              final cortePlegadoController =
              Provider.of<CortePlegadoController>(context, listen: false);

              return ManagerOption(
                menuItems: const ['Crear Corte Plegado', 'Listado de Corte Plegado'],
                views: [
                  CortePlegadoScreenAdd(authHandler: authHandler),
                  CortePlegadoScreen(cortePlegadoController: cortePlegadoController),
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
