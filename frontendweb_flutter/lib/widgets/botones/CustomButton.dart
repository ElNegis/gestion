import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Color? buttonColor;
  final Color? textColor;
  final VoidCallback onPressed;

  // Nuevos parámetros
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final double elevation;
  final Color? shadowColor;

  const CustomButton({
    Key? key,
    required this.buttonText,
    this.buttonColor = Colors.green,
    this.textColor = Colors.white,
    required this.onPressed,
    this.fontSize = 18.0, // Tamaño de texto predeterminado
    this.fontWeight = FontWeight.bold, // Peso de texto predeterminado
    this.padding = const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)), // Bordes redondeados predeterminados
    this.elevation = 2.0, // Elevación predeterminada
    this.shadowColor, // Color de sombra personalizado
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: padding,
        elevation: elevation,
        shadowColor: shadowColor ?? Colors.black45, // Sombra predeterminada
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
