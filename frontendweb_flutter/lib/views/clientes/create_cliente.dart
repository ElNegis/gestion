import 'package:flutter/material.dart';
import '../../service/ClienteService.dart';
import '../../widgets/text/CustomSnackBar.dart';
import '../../widgets/text/text_input_field.dart';
import '../../widgets/botones/CustomButton.dart';
import '../../widgets/images/image_container.dart';
import '../../model/AuthHandler.dart';

class ClienteScreenAdd extends StatelessWidget {
  final AuthHandler authHandler;

  const ClienteScreenAdd({Key? key, required this.authHandler}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: constraints.maxWidth > 800
                  ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildForm(context),
                    ),
                  ),
                  const SizedBox(width: 32),
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ImageContainer(
                          imageUrl: 'assets/images/Metalize.png',
                          width: constraints.maxWidth * 0.4,
                          height: constraints.maxWidth * 0.4,
                        ),
                      ),
                    ),
                  ),
                ],
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildForm(context),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ImageContainer(
                        imageUrl: 'assets/images/Metalize.png',
                        width: constraints.maxWidth * 0.8,
                        height: constraints.maxWidth * 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController apellidoController = TextEditingController();
    final TextEditingController telefonoController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "CLIENTES",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        TextInputField(
          hintText: "Ingresa el nombre",
          controller: nombreController,
        ),
        const SizedBox(height: 16),
        TextInputField(
          hintText: "Ingresa el apellido",
          controller: apellidoController,
        ),
        const SizedBox(height: 16),
        TextInputField(
          hintText: "Ingresa el teléfono",
          controller: telefonoController,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            CustomButton(
              buttonText: "CANCELAR",
              buttonColor: const Color(0xFFB35A58),
              textColor: Colors.white,
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: 16),
            CustomButton(
              buttonText: "CONFIRMAR",
              buttonColor: const Color(0xFF2E8B57),
              textColor: Colors.white,
              onPressed: () => _crearCliente(
                context,
                nombreController.text,
                apellidoController.text,
                telefonoController.text,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _crearCliente(
      BuildContext context,
      String nombre,
      String apellido,
      String telefono,
      ) async {
    if (nombre.isEmpty || apellido.isEmpty || telefono.isEmpty) {
      CustomSnackbar.show(
        context,
        message: '¡Complete todos los campos!',
        fontSize: 18.0,
        icon: Icons.error,
      );
      return;
    }

    try {
      final success = await ClienteService.crearCliente(
        authHandler,
        {
          'nombre': nombre,
          'apellido': apellido,
          'telefono': telefono,
        },
      );

      if (success) {
        CustomSnackbar.show(
          context,
          message: 'Cliente creado correctamente',
          fontSize: 18.0,
          icon: Icons.check,
          textColor: Colors.green,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        context,
        message: 'Ocurrió un error inesperado: $e',
        isBold: true,
        fontSize: 18.0,
        icon: Icons.error,
        textColor: Colors.white,
      );
    }
  }
}
