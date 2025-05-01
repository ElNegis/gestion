import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/Modals/LogoutModal.dart';
import '../model/AuthHandler.dart';
import '../widgets/NavigationMenu.dart';
import '../widgets/botones/login_button.dart';
import '../controllers/UserPermissionController.dart';
import 'CortePlegado/Main_corte_plegado.dart';
import 'Cotizacion/MainCotizacion.dart';
import 'PlanchasProveedores/Main_planchas_proveedores.dart';
import 'Roles/MainRoles.dart';
import 'Users/UserMain.dart';
import 'clientes/main_clientes.dart';
import 'error401.dart';

class ManagerScreen extends StatefulWidget {
  final String username;
  final AuthHandler authHandler;

  const ManagerScreen({Key? key, required this.username, required this.authHandler}) : super(key: key);

  @override
  _ManagerScreenState createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  int _currentViewIndex = 0;
  List<String> _menuItems = [];
  List<Widget> _views = [];

  @override
  void initState() {
    super.initState();
    _cargarPermisos();
  }

  Future<void> _cargarPermisos() async {
    final userPermissionController = Provider.of<UserPermissionController>(context, listen: false);
    final success = await userPermissionController.fetchUserPermissions();
    if (success) {
      setState(() {
        _filtrarMenuPorPermisos(userPermissionController);
        _verificarAcceso(userPermissionController);
      });
    }
  }

  void _filtrarMenuPorPermisos(UserPermissionController controller) {
    final List<String> allMenuItems = [
      "PLANCHAS Y PROVEEDORES",
      "CORTE PLEGADO",
      "COTIZAR",
      "CLIENTES",
      "USUARIOS",
      "ROLES",
    ];

    final List<Widget> allViews = [
      const PlanchasProveedores(),
      const MainCortePlegado(),
      const MainCotizacion(),
      const MainClientes(),
      const UserMain(),
      const MainRoles(),
    ];

    _menuItems = [];
    _views = [];

    for (int i = 0; i < allMenuItems.length; i++) {
      final menuItem = allMenuItems[i];
      final view = allViews[i];

      if (_permisoRequerido(menuItem, controller)) {
        _menuItems.add(menuItem);
        _views.add(view);
      }
    }
  }

  bool _permisoRequerido(String menuItem, UserPermissionController controller) {
    switch (menuItem) {
      case "PLANCHAS Y PROVEEDORES":
        return controller.hasPermission("Planchas");
      case "CORTE PLEGADO":
        return controller.hasPermission("Planchas");
      case "COTIZAR":
        return controller.hasPermission("Ventas");
      case "CLIENTES":
        return controller.hasPermission("Test");
      case "USUARIOS":
        return controller.hasPermission("Users");
      case "ROLES":
        return controller.hasPermission("Users");
      default:
        return false;
    }
  }

  void _verificarAcceso(UserPermissionController controller) {
    // Si el usuario no tiene permisos o solo tiene "NoAccess"
    if (controller.permissions.isEmpty || controller.hasPermission("NoAccess")) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UnauthorizedPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userPermissionController = Provider.of<UserPermissionController>(context);

    if (_menuItems.isEmpty || _views.isEmpty) {

      return UnauthorizedPage();
    }

    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              NavigationMenu(
                menuItems: _menuItems,
                currentIndex: _currentViewIndex,
                onItemSelected: (index) {
                  setState(() {
                    _currentViewIndex = index;
                  });
                },
              ),
              Expanded(
                child: _views[_currentViewIndex],
              ),
            ],
          ),
          Positioned(
            top: 16,
            right: 16,
            child: LoginButton(
              imagePath: 'assets/images/SmilingFace.jpg',
              buttonText: widget.username,
              onPressed: () {
                LogoutModal.showLogoutDialog(context, widget.authHandler);
              },
            ),
          ),
        ],
      ),
    );
  }
}
