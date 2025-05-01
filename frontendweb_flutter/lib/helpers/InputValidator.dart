import 'package:flutter/material.dart';
import '../widgets/text/CustomSnackBar.dart';
import '../widgets/text/type_text_enum.dart';

class InputValidator {
  static bool validateField({
    required BuildContext context,
    required String value,
    required String fieldName,
    required TypeText validationType,
  }) {
    if (value.trim().isEmpty) {
      CustomSnackbar.show(
        context,
        message: 'El campo "$fieldName" es obligatorio.',
        icon: Icons.warning_amber_rounded,
        textColor: Colors.redAccent,
        duration: 3,
        height: 80.0,
      );
      return false;
    }

    switch (validationType) {
      case TypeText.number:
        if (!RegExp(r'^\d+$').hasMatch(value)) {
          CustomSnackbar.show(
            context,
            message: 'El campo "$fieldName" debe contener solo números enteros.',
            icon: Icons.warning_amber_rounded,
            textColor: Colors.redAccent,
            duration: 3,
            height: 80.0,
          );
          return false;
        }
        break;

      case TypeText.decimal:
        if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
          CustomSnackbar.show(
            context,
            message: 'El campo "$fieldName" debe contener un número decimal válido.',
            icon: Icons.warning_amber_rounded,
            textColor: Colors.redAccent,
            duration: 3,
            height: 80.0,
          );
          return false;
        }
        break;

      case TypeText.string:
        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
          CustomSnackbar.show(
            context,
            message: 'El campo "$fieldName" debe contener solo letras.',
            icon: Icons.warning_amber_rounded,
            textColor: Colors.redAccent,
            duration: 3,
            height: 80.0,
          );
          return false;
        }
        break;

      case TypeText.none:
        break;
    }

    return true;
  }
}
