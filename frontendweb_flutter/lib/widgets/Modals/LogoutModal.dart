import 'package:flutter/material.dart';
import 'dart:async';
import '../../model/AuthHandler.dart'; // Ajusta la ruta según la ubicación de tu archivo AuthHandler
import '../../views/home_page.dart'; // Ajusta la ruta según la ubicación de tu archivo home_page

class LogoutModal {
  static void showLogoutDialog(BuildContext context, AuthHandler authHandler) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _RetroLogoutDialog(authHandler: authHandler);
      },
    );
  }
}

class _RetroLogoutDialog extends StatefulWidget {
  final AuthHandler authHandler;

  const _RetroLogoutDialog({Key? key, required this.authHandler}) : super(key: key);

  @override
  State<_RetroLogoutDialog> createState() => _RetroLogoutDialogState();
}

class _RetroLogoutDialogState extends State<_RetroLogoutDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black, // Fondo negro retro
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.greenAccent, width: 2), // Borde neón verde
      ),
      title: const Center(
        child: Text(
          'Cerrar sesión',
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'PressStart2P', // Fuente pixel art retro
            color: Colors.greenAccent,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_animation.value, 0),
                child: const Text(
                  '(╥﹏╥)',
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'PressStart2P',
                    color: Colors.redAccent,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          const Text(
            '¿Estás seguro de que deseas cerrar sesión?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'PressStart2P',
              color: Colors.white,
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.greenAccent),
          ),
          child: const Text(
            'Cancelar',
            style: TextStyle(fontFamily: 'PressStart2P'),
          ),
        ),
        TextButton(
          onPressed: () async {
            await widget.authHandler.logout();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const HomePage(imageUrl: 'assets/images/metalize.png'),
              ),
                  (Route<dynamic> route) => false,
            );
          },
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.redAccent),
          ),
          child: const Text(
            'Cerrar sesión',
            style: TextStyle(fontFamily: 'PressStart2P'),
          ),
        ),
      ],
    );
  }
}
