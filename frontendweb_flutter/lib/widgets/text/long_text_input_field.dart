import 'package:flutter/material.dart';
import 'type_text_enum.dart';


class LongTextInputField extends StatefulWidget {

  final TypeText validationType;

  final String hintText;
  final double? width;
  final double height;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  // Nuevos parámetros
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final TextStyle? hintStyle;

  const LongTextInputField({
    Key? key,
    required this.hintText,
    this.width = 550.0,
    this.height = 150.0, // Altura predeterminada para textos largos
    this.controller,
    this.onChanged,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.hintStyle,
    this.validationType = TypeText.none,
  }) : super(key: key);

  @override
  _LongTextInputFieldState createState() => _LongTextInputFieldState();
}

class _LongTextInputFieldState extends State<LongTextInputField> {
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: widget.height,
          width: widget.width,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: widget.borderColor ?? Colors.grey[600]!,
              width: 1.0,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            maxLines: null, // Soporta múltiples líneas
            expands: true, // Expande automáticamente para llenar el espacio
            keyboardType: TextInputType.multiline,
            onChanged: (value) {
              _validateInput(value); // Lógica de validación
              if (widget.onChanged != null) widget.onChanged!(value);
            },
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: widget.hintStyle ??
                  const TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
              border: InputBorder.none,
            ),
            style: TextStyle(
              color: widget.textColor ?? Colors.black,
            ),
          ),
        ),
        if (errorMessage != null) // Mostrar mensaje de error
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  void _validateInput(String value) {
    setState(() {
      errorMessage = null;
      switch (widget.validationType) {
        case TypeText.number:
          if (value.isNotEmpty && !RegExp(r'^\d+$').hasMatch(value)) {
            errorMessage = 'Ingrese solo números enteros.';
          }
          break;
        case TypeText.decimal:
          if (value.isNotEmpty && !RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
            errorMessage = 'Ingrese un número decimal válido.';
          }
          break;
        case TypeText.string:
          if (value.isNotEmpty && !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
            errorMessage = 'Ingrese solo letras.';
          }
          break;
        case TypeText.none:
        // Sin validación
          break;
      }
    });
  }
}
