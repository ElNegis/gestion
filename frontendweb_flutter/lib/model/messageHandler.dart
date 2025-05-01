import 'dart:convert';
import 'package:flutter/material.dart';
import '../../widgets/text/CustomSnackBar.dart';

class MessageHandler {
  static bool isShowingError = false;

  static void handleResponse({
    required BuildContext context,
    required dynamic response,
    String? successMessage,
  }) {
    print('🔹 Respuesta recibida en handleResponse: $response');

    if (response is Map<String, dynamic>) {
      String errorMessage = _extractErrorMessage(response);

      if (errorMessage.isNotEmpty) {
        showErrorMessage(context, errorMessage);
      } else if (successMessage != null) {
        showSuccessMessage(context, successMessage);
      }
    } else {
      print('⚠ Respuesta inesperada en handleResponse: $response');
    }
  }

  static String _extractErrorMessage(Map<String, dynamic> errorResponse) {
    print('🔹 Extrayendo mensaje de error: $errorResponse');

    List<String> messages = [];

    errorResponse.forEach((key, value) {
      if (value is List) {
        messages.addAll(value.map((e) => '$key: ${_decodeText(e)}').toList());
      } else if (value is String) {
        messages.add('$key: ${_decodeText(value)}');
      }
    });

    String finalMessage = messages.isNotEmpty ? messages.join('\n') : '';
    print('🔹 Mensaje de error extraído: $finalMessage');
    return finalMessage;
  }

  static void showSuccessMessage(BuildContext context, String message) {
    print('✅ Mostrando mensaje de éxito: $message');
    _showSnackbar(context, message, Icons.check_circle, Colors.green);
  }

  static void showErrorMessage(BuildContext context, String message) {
    if (message.isEmpty || isShowingError) {
      print('⚠ Intento de mostrar un error duplicado o vacío: $message');
      return;
    }

    isShowingError = true;
    print('❌ Mostrando mensaje de error: $message');

    Future.delayed(Duration.zero, () {
      _showSnackbar(context, message, Icons.error_outline, Colors.redAccent);
      Future.delayed(const Duration(seconds: 3), () {
        isShowingError = false; // Habilita nuevamente mostrar errores después de 3s
      });
    });
  }

  static void _showSnackbar(BuildContext context, String message, IconData icon, Color color) {
    CustomSnackbar.show(
      context,
      message: message,
      icon: icon,
      textColor: Colors.white,
      duration: 4,
    );
  }

  static String _decodeText(String text) {
    try {
      return utf8.decode(text.runes.toList());
    } catch (e) {
      print('⚠ Error al decodificar texto: $text');
      return text;
    }
  }
}
