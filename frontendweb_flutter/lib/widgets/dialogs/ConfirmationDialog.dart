import 'package:flutter/material.dart';
import '../../widgets/text/CustomTitle.dart';
import '../../widgets/botones/CustomButton.dart';

class ConfirmationDialog {
  static Future<void> show({
    required BuildContext context,
    required VoidCallback onConfirm, // Acción si se confirma
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false, // No se cierra al tocar fuera
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.grey.shade900, // Fondo oscuro estilizado
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4, // Ancho compacto
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Mensaje principal
                  const CustomTitle(
                    title: '¿Está seguro de guardar los cambios?',
                    isBold: true,
                    titleFontSize: 18,
                  ),
                  const SizedBox(height: 24),

                  // Botones centrados
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        buttonText: 'NO',
                        buttonColor: Colors.redAccent,
                        textColor: Colors.white,
                        fontSize: 14,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 12.0),
                        borderRadius: BorderRadius.circular(8),
                        onPressed: () {
                          Navigator.of(context).pop(); // Cierra el diálogo
                        },
                      ),
                      const SizedBox(width: 16), // Espaciado entre botones
                      CustomButton(
                        buttonText: 'SÍ',
                        buttonColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 14,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 12.0),
                        borderRadius: BorderRadius.circular(8),
                        onPressed: () {
                          Navigator.of(context).pop(); // Cierra el diálogo
                          onConfirm(); // Acción al confirmar
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
