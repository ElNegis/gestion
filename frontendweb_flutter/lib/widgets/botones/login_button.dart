import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String imagePath;
  final String buttonText;
  final VoidCallback onPressed;

  const LoginButton({
    super.key,
    required this.imagePath,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Acción al hacer clic en cualquier parte
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botón con imagen
          Container(
            width: 86, // Tamaño del botón cuadrado
            height: 86,
            decoration: BoxDecoration(
              color: Colors.white, // Fondo blanco del recuadro
              borderRadius: BorderRadius.circular(5), // Bordes redondeados
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(2, 2), // Sombra ligera
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0), // Espaciado interno
              child: Image.asset(
                imagePath, // Ruta de la imagen
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 8), // Espacio entre el botón y el texto
          Text(
            buttonText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'PressStart2P', // Estilo retro
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
