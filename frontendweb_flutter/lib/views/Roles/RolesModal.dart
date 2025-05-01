import 'package:flutter/material.dart';
import '../../widgets/botones/CustomButton.dart';
import '../../widgets/text/long_text_input_field.dart';
import '../../widgets/text/text_input_field.dart';
import '../../widgets/text/TextSubTitle.dart';
import '../../widgets/LabelAboveWidget.dart';
import '../../helpers/InputValidator.dart';
import '../../model/messageHandler.dart';
import '../../widgets/dialogs/ConfirmationDialog.dart';
import '../../widgets/text/type_text_enum.dart';

class EditarRolesModal extends StatefulWidget {
  final Map<String, dynamic> rol;
  final Future<bool> Function(Map<String, dynamic>) onGuardar;

  const EditarRolesModal({
    Key? key,
    required this.rol,
    required this.onGuardar,
  }) : super(key: key);

  @override
  _EditarRolesModalState createState() => _EditarRolesModalState();
}

class _EditarRolesModalState extends State<EditarRolesModal> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.rol['name']);
    descriptionController = TextEditingController(text: widget.rol['description']);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _guardarDatos() async {
    final name = nameController.text.trim();
    final description = descriptionController.text.trim();

    // Validación de campos
    if (!InputValidator.validateField(
      context: context,
      value: name,
      fieldName: 'Nombre del Rol',
      validationType: TypeText.none,
    )) return;

    if (!InputValidator.validateField(
      context: context,
      value: description,
      fieldName: 'Descripción del Rol',
      validationType: TypeText.none,
    )) return;

    // Mostrar el diálogo de confirmación
    ConfirmationDialog.show(
      context: context,
      onConfirm: () async {
        try {
          final datos = {
            'id': widget.rol['id'],
            'name': name,
            'description': description,
          };

          final success = await widget.onGuardar(datos);
          if (success) {
            Navigator.pop(context, true); // Cierra el modal
          } else {
            MessageHandler.showErrorMessage(context, 'error al guardar'); // Error al guardar
          }
        } catch (e) {
          MessageHandler.showErrorMessage(context,'Error Inesperado'); // Error inesperado
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.green.shade600, width: 2),
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
                      text: 'Editar Rol',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      isUnderlined: true,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                LabelAboveWidget(
                  label: 'Nombre del Rol',
                  child: TextInputField(
                    hintText: 'Ingrese el nombre del rol',
                    controller: nameController,
                    prefixIcon: const Icon(Icons.person, color: Colors.green),
                    borderColor: Colors.green.shade400,
                    backgroundColor: Colors.white,
                    textColor: Colors.black87,
                    validationType: TypeText.none,
                  ),
                ),
                const SizedBox(height: 12),

                LabelAboveWidget(
                  label: 'Descripción del Rol',
                  child: LongTextInputField(
                    hintText: 'Ingrese una descripción detallada',
                    controller: descriptionController,
                    borderColor: Colors.green.shade400,
                    backgroundColor: Colors.white,
                    textColor: Colors.black87,
                    validationType: TypeText.none,
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
                      buttonColor: Colors.green.shade400,
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
