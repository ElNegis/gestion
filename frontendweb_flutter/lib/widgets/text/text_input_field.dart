import 'package:flutter/material.dart';
import 'type_text_enum.dart';

class TextInputField extends StatefulWidget {
  final String hintText;
  final double? width;
  final double height;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  // Nuevos parámetros
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final TextStyle? hintStyle;
  final Icon? prefixIcon;
  final TypeText validationType;


  const TextInputField({
    Key? key,
    required this.hintText,
    this.width = 550.0,
    this.height = 50.0,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.onChanged,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.hintStyle,
    this.prefixIcon,
    this.validationType = TypeText.none, // Por defecto sin validación
  }) : super(key: key);

  @override
  _TextInputFieldState createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  bool _isObscured = true;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: widget.height,
          width: widget.width,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: widget.borderColor ?? Colors.grey[600]!,
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              if (widget.prefixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: widget.prefixIcon,
                ),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  obscureText: widget.isPassword && _isObscured,
                  keyboardType: widget.keyboardType,
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
              if (widget.isPassword)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                  child: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[400],
                  ),
                ),
            ],
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
          break;
      }
    });
  }
}
