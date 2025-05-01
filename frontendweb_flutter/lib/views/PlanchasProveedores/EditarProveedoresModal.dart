import 'package:flutter/material.dart';
import '../../widgets/LabelAboveWidget.dart';
import '../../widgets/botones/CustomButton.dart';
import '../../widgets/text/text_input_field.dart';
import '../../widgets/text/TextSubTitle.dart';
import '../../helpers/InputValidator.dart';
import '../../model/messageHandler.dart';
import '../../widgets/dialogs/ConfirmationDialog.dart';
import '../../widgets/text/type_text_enum.dart';

class EditarProveedoresModal extends StatefulWidget {
  final Map<String, dynamic> proveedor;
  final Future<bool> Function(Map<String, dynamic>) onGuardar;

  const EditarProveedoresModal({
    Key? key,
    required this.proveedor,
    required this.onGuardar,
  }) : super(key: key);

  @override
  _EditarProveedoresModalState createState() => _EditarProveedoresModalState();
}

class _EditarProveedoresModalState extends State<EditarProveedoresModal> {
  late TextEditingController nombreController;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.proveedor['nombre']);
  }

  @override
  void dispose() {
    nombreController.dispose();
    super.dispose();
  }

  void _guardarDatos() async {
    final nombre = nombreController.text.trim();

    // Validación de nombre
    if (!InputValidator.validateField(
      context: context,
      value: nombre,
      fieldName: 'Nombre del Proveedor',
      validationType: TypeText.none,
    )) return;

    ConfirmationDialog.show(
      context: context,
      onConfirm: () async {
        try {
          final datos = {
            'id': widget.proveedor['id'],
            'nombre': nombre,
          };

          final success = await widget.onGuardar(datos);
          if (success) {
            Navigator.pop(context, true); // Cierra el modal
          } else {
            MessageHandler.showErrorMessage(context, 'error al guardar'); // Error al guardar
          }
        } catch (e) {
          MessageHandler.showErrorMessage(context, 'Error Inesperado'); // Error inesperado
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
                      text: 'Editar Proveedor',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      isUnderlined: true,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                LabelAboveWidget(
                  label: 'Nombre del Proveedor',
                  child: TextInputField(
                    hintText: 'Ingrese el nombre del proveedor',
                    controller: nombreController,
                    prefixIcon: const Icon(Icons.business, color: Colors.blue),
                    borderColor: Colors.blue.shade400,
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
