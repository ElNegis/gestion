import 'package:flutter/material.dart';
import '../model/AuthHandler.dart';
import '../model/messageHandler.dart';

class AuthController with ChangeNotifier {
  final AuthHandler authHandler;
  Map<String, dynamic>? currentUser;

  AuthController({required this.authHandler});

  /// Iniciar sesión
  Future<bool> login(BuildContext context, String username, String password) async {
    try {
      final response = await authHandler.login(username, password);
      if (response == null) return false;

      MessageHandler.handleResponse(
        context: context,
        response: response,
        successMessage: 'Inicio de sesión exitoso.',
      );

      currentUser = response;
      notifyListeners();
      return true;
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
      return false;
    }
  }


  /// Cerrar sesión
  Future<void> logout(BuildContext context) async {
    try {
      await authHandler.logout();
      MessageHandler.showSuccessMessage(context, 'Cierre de sesión exitoso.');
      currentUser = null;
      notifyListeners();
    } catch (e) {
      MessageHandler.handleResponse(context: context, response: e);
    }
  }

}
