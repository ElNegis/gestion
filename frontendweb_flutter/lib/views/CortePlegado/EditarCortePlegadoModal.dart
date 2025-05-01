import 'package:flutter/material.dart';
import '../../widgets/botones/CustomButton.dart';
import '../../widgets/text/text_input_field.dart';
import '../../widgets/text/TextSubTitle.dart';
import '../../widgets/botones/HelpCirle.dart';
import '../../widgets/LabelAboveWidget.dart';
import '../../helpers/InputValidator.dart';
import '../../model/messageHandler.dart';
import '../../widgets/dialogs/ConfirmationDialog.dart';
import '../../widgets/text/type_text_enum.dart';

class EditarCortePlegadoModal extends StatefulWidget {
  final Map<String, dynamic> corte;
  final Future<bool> Function(Map<String, dynamic>) onGuardar;

  const EditarCortePlegadoModal({Key? key, required this.corte, required this.onGuardar})
      : super(key: key);

  @override
  _EditarCortePlegadoModalState createState() => _EditarCortePlegadoModalState();
}

class _EditarCortePlegadoModalState extends State<EditarCortePlegadoModal> {
  late TextEditingController espesorController;
  late TextEditingController largoController;
  late TextEditingController precioController;

  @override
  void initState() {
    super.initState();
    espesorController = TextEditingController(text: widget.corte['espesor'].toString());
    largoController = TextEditingController(text: widget.corte['largo'].toString());
    precioController = TextEditingController(text: widget.corte['precio'].toString());
  }

  @override
  void dispose() {
    espesorController.dispose();
    largoController.dispose();
    precioController.dispose();
    super.dispose();
  }

  void _guardarDatos() async {
    final espesor = espesorController.text.trim();
    final largo = largoController.text.trim();
    final precio = precioController.text.trim();

    // Validación de cada campo
    if (!InputValidator.validateField(
      context: context,
      value: espesor,
      fieldName: 'Espesor',
      validationType: TypeText.decimal,
    )) return;

    if (!InputValidator.validateField(
      context: context,
      value: largo,
      fieldName: 'Largo',
      validationType: TypeText.decimal,
    )) return;

    if (!InputValidator.validateField(
      context: context,
      value: precio,
      fieldName: 'Precio',
      validationType: TypeText.decimal,
    )) return;

    ConfirmationDialog.show(
      context: context,
      onConfirm: () async {
        try {
          final datos = {
            'espesor': double.tryParse(espesor) ?? 0,
            'largo': double.tryParse(largo) ?? 0,
            'precio': double.tryParse(precio) ?? 0,
          };

          final success = await widget.onGuardar(datos);
          if (success) {
            Navigator.pop(context, true); // Cierra el modal al confirmar
          } else {
            MessageHandler.showErrorMessage(context,'Error al guardar los datos'); // Mostrar error si falla el guardado
          }
        } catch (e) {
          MessageHandler.showErrorMessage(context, 'Error inesperado'); // Error inesperado
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
      backgroundColor: Colors.black,
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
                      text: 'Editar Corte Plegado',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      isUnderlined: true,
                    ),
                    SizedBox(width: 8),
                    HelpCircle(
                      helpText: 'Edita los datos del corte plegado y guarda los cambios.',
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                LabelAboveWidget(
                  label: 'Espesor',
                  child: TextInputField(
                    hintText: 'Ingrese el espesor',
                    controller: espesorController,
                    prefixIcon: const Icon(Icons.straighten, color: Colors.green),
                    borderColor: Colors.green.shade400,
                    backgroundColor: Colors.white,
                    textColor: Colors.black87,
                    validationType: TypeText.decimal,
                  ),
                ),
                const SizedBox(height: 12),

                LabelAboveWidget(
                  label: 'Largo',
                  child: TextInputField(
                    hintText: 'Ingrese el largo',
                    controller: largoController,
                    prefixIcon: const Icon(Icons.square_foot, color: Colors.green),
                    borderColor: Colors.green.shade400,
                    backgroundColor: Colors.white,
                    textColor: Colors.black87,
                    validationType: TypeText.decimal,
                  ),
                ),
                const SizedBox(height: 12),

                LabelAboveWidget(
                  label: 'Precio',
                  child: TextInputField(
                    hintText: 'Ingrese el precio',
                    controller: precioController,
                    prefixIcon: const Icon(Icons.attach_money, color: Colors.green),
                    borderColor: Colors.green.shade400,
                    backgroundColor: Colors.white,
                    textColor: Colors.black87,
                    validationType: TypeText.decimal,
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
