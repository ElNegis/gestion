import 'package:flutter/material.dart';
import '../../widgets/botones/CustomButton.dart';
import '../../widgets/text/text_input_field.dart';
import '../../widgets/text/TextSubTitle.dart';
import '../../widgets/LabelAboveWidget.dart';
import '../../helpers/InputValidator.dart';
import '../../model/messageHandler.dart';
import '../../widgets/dialogs/ConfirmationDialog.dart';
import '../../widgets/text/PasswordVerificationField.dart';
import '../../widgets/text/type_text_enum.dart';

class EditUserModal extends StatefulWidget {
  final Map<String, dynamic> user;
  final Future<bool> Function(Map<String, dynamic>) onGuardar;

  const EditUserModal({Key? key, required this.user, required this.onGuardar})
      : super(key: key);

  @override
  _EditUserModalState createState() => _EditUserModalState();
}

class _EditUserModalState extends State<EditUserModal> {
  late TextEditingController nameController;
  late TextEditingController lastNameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user['nombre']);
    lastNameController = TextEditingController(text: widget.user['apellido']);
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _guardarDatos() async {
    final nombre = nameController.text.trim();
    final apellido = lastNameController.text.trim();
    final password = passwordController.text.trim();

    // Validar los campos
    if (!InputValidator.validateField(
      context: context,
      value: nombre,
      fieldName: 'Nombre',
      validationType: TypeText.string,
    )) return;

    if (!InputValidator.validateField(
      context: context,
      value: apellido,
      fieldName: 'Apellido',
      validationType: TypeText.string,
    )) return;

    if (!InputValidator.validateField(
      context: context,
      value: password,
      fieldName: 'Contraseña',
      validationType: TypeText.none,
    )) return;

    ConfirmationDialog.show(
      context: context,
      onConfirm: () async {
        try {
          final datos = {
            'id': widget.user['id'],
            'nombre': nombre,
            'apellido': apellido,
            'password': password,
          };

          final success = await widget.onGuardar(datos);
          if (success) {
            Navigator.pop(context, true); // Cierra el modal
          } else {
            MessageHandler.showErrorMessage(context, 'Error Inesperado');
          }
        } catch (e) {
          MessageHandler.showErrorMessage(context,'Error Inesperado');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.blue.shade600, width: 2),
      ),
      backgroundColor: Colors.grey.shade900,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextSubTitle(
                      text: 'Editar Usuario',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      isUnderlined: true,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                LabelAboveWidget(
                  label: 'Nombre',
                  child: TextInputField(
                    hintText: 'Ingrese el nombre',
                    controller: nameController,
                    prefixIcon: const Icon(Icons.person, color: Colors.blue),
                    borderColor: Colors.blue.shade400,
                    backgroundColor: Colors.white,
                    textColor: Colors.black87,
                    validationType: TypeText.string,
                  ),
                ),
                const SizedBox(height: 12),

                LabelAboveWidget(
                  label: 'Apellido',
                  child: TextInputField(
                    hintText: 'Ingrese el apellido',
                    controller: lastNameController,
                    prefixIcon: const Icon(Icons.person_outline, color: Colors.blue),
                    borderColor: Colors.blue.shade400,
                    backgroundColor: Colors.white,
                    textColor: Colors.black87,
                    validationType: TypeText.string,
                  ),
                ),
                const SizedBox(height: 12),

                LabelAboveWidget(
                  label: 'Nueva Contraseña',
                  child: PasswordVerificationField(
                    passwordController: passwordController,
                    isDoubleField: false,
                    textColor: Colors.black,
                    backgroundColor: Colors.white,
                    borderColor: Colors.blue.shade400,
                    prefixIcon: const Icon(Icons.security_rounded, color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      buttonText: 'Cancelar',
                      onPressed: () => Navigator.pop(context, false),
                      buttonColor: Colors.red.shade400,
                      textColor: Colors.white,
                    ),
                    const SizedBox(width: 16),
                    CustomButton(
                      buttonText: 'Guardar',
                      onPressed: _guardarDatos,
                      buttonColor: Colors.blue.shade400,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
