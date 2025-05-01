import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/RolesController.dart';
import '../../widgets/botones/CustomButton.dart';
import '../../widgets/text/CustomSnackBar.dart';
import '../../widgets/text/text_input_field.dart';
import '../../widgets/images/image_container.dart';
import '../../model/AuthHandler.dart';

class CreacionRolesScreen extends StatelessWidget {
  final AuthHandler authHandler;

  const CreacionRolesScreen({Key? key, required this.authHandler}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController descripcionController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black87,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: constraints.maxWidth > 800
                  ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: _buildForm(context, nombreController, descripcionController),
                  ),
                  const SizedBox(width: 32),
                  Flexible(
                    flex: 1,
                    child: ImageContainer(
                      imageUrl: 'assets/images/roles.png',
                      width: constraints.maxWidth * 0.4,
                    ),
                  ),
                ],
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildForm(context, nombreController, descripcionController),
                  const SizedBox(height: 32),
                  ImageContainer(
                    imageUrl: 'assets/images/roles.png',
                    width: constraints.maxWidth * 0.8,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context, TextEditingController nombreController,
      TextEditingController descripcionController) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey[700]!, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 8),
              const Text(
                "CREAR NUEVO ROL",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextInputField(
            hintText: 'Nombre del Rol',
            controller: nombreController,
          ),
          const SizedBox(height: 12),
          TextInputField(
            hintText: 'Descripción del Rol',
            controller: descripcionController,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton(
                buttonText: 'CANCELAR',
                buttonColor: Colors.grey,
                textColor: Colors.white,
                onPressed: () {
                  nombreController.clear();
                  descripcionController.clear();
                  CustomSnackbar.show(context, message: 'Formulario Limpiado');
                },
              ),
              const SizedBox(width: 16),
              CustomButton(
                buttonText: 'CREAR',
                buttonColor: Colors.green,
                textColor: Colors.white,
                onPressed: () async {
                  final name = nombreController.text.trim();
                  final description = descripcionController.text.trim();

                  if (name.isEmpty || description.isEmpty) {
                    CustomSnackbar.show(
                      context,
                      message: 'Por favor, complete todos los campos.',
                      textColor: Colors.red,
                      icon: Icons.error_outline,
                    );
                    return;
                  }

                  final rolesController = Provider.of<RolesController>(context, listen: false);
                  final success = await rolesController.createRole(context,name, description);
                  
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
