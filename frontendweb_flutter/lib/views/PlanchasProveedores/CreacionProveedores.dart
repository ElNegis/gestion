import 'package:flutter/material.dart';
import 'package:frontendweb_flutter/service/ProoveedorService.dart';
import 'package:frontendweb_flutter/widgets/LabelAboveWidget.dart';
import 'package:frontendweb_flutter/widgets/text/CustomSnackBar.dart';
import '../../widgets/text/text_input_field.dart';
import '../../widgets/botones/CustomButton.dart';
import '../../widgets/images/image_container.dart';
import '../../model/AuthHandler.dart';

class ProveedoresScreenAdd extends StatelessWidget {
  final AuthHandler authHandler; // AuthHandler para manejar los tokens

  const ProveedoresScreenAdd({Key? key, required this.authHandler})
      : super(key: key);

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
                        aspectRatio: 1, // Proporción cuadrada
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
                      aspectRatio: 1, // Proporción cuadrada
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
    final TextEditingController proveedorController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelAboveWidget(label: 'Proveedor',
            child: TextInputField(
              hintText: "Ingresa el nombre del proveedor",
              controller: proveedorController,
              prefixIcon: const Icon(Icons.business_center_sharp, color: Colors.blue,),
            ))
        ,
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
              onPressed: () =>
                  _agregarProveedor(context, proveedorController.text),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _agregarProveedor(
      BuildContext context, String nombreProveedor) async {
    if (nombreProveedor.isEmpty) {
      CustomSnackbar.show(
        context,
        message: '¡Complete todos los campos!',
        fontSize: 18.0,
        icon: Icons.error,
      );
      return;
    }

    try {
      final nuevoProveedor =
      ProveedorService(nombre: nombreProveedor, authHandler: authHandler);
      await nuevoProveedor.AgregarProveedor();

      CustomSnackbar.show(
        context,
        message: 'Proveedor creado exitosamente',
        fontSize: 18.0,
        icon: Icons.check,
        textColor: Colors.green,
      );
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
