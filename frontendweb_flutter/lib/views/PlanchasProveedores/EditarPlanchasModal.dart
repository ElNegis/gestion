import 'package:flutter/material.dart';
import '../../widgets/LabelAboveWidget.dart';
import '../../widgets/botones/CustomButton.dart';
import '../../widgets/botones/dropdown_input_field.dart';
import '../../widgets/text/text_input_field.dart';
import '../../widgets/text/TextSubTitle.dart';
import '../../helpers/InputValidator.dart';
import '../../model/messageHandler.dart';
import '../../widgets/dialogs/ConfirmationDialog.dart';
import '../../widgets/text/type_text_enum.dart';
import '../../controllers/proveedor_controller.dart';


class EditarPlanchasModal extends StatefulWidget {
  final Map<String, dynamic> plancha;
  final ProveedorController proveedorController;
  final Future<bool> Function(Map<String, dynamic>) onGuardar;

  const EditarPlanchasModal({
    Key? key,
    required this.plancha,
    required this.proveedorController,
    required this.onGuardar,
  }) : super(key: key);

  @override
  _EditarPlanchasModalState createState() => _EditarPlanchasModalState();
}

class _EditarPlanchasModalState extends State<EditarPlanchasModal> {
  late TextEditingController espesorController;
  late TextEditingController largoController;
  late TextEditingController anchoController;
  late TextEditingController precioController;
  int? proveedorSeleccionado;
  List<Map<String, dynamic>> proveedores = [];

  @override
  void initState() {
    super.initState();
    espesorController = TextEditingController(text: widget.plancha['espesor'].toString());
    largoController = TextEditingController(text: widget.plancha['largo'].toString());
    anchoController = TextEditingController(text: widget.plancha['ancho'].toString());
    precioController = TextEditingController(text: widget.plancha['precio'].toString());
    proveedorSeleccionado = widget.plancha['proveedor']['id'];

    _cargarProveedores();
  }

  Future<void> _cargarProveedores() async {
    await widget.proveedorController.fetchProveedores();
    setState(() {
      proveedores = widget.proveedorController.proveedores;
    });
  }

  @override
  void dispose() {
    espesorController.dispose();
    largoController.dispose();
    anchoController.dispose();
    precioController.dispose();
    super.dispose();
  }

  void _guardarDatos() async {
    final espesor = double.tryParse(espesorController.text.trim()) ?? 0.0;
    final largo = int.tryParse(largoController.text.trim()) ?? 0;
    final ancho = int.tryParse(anchoController.text.trim()) ?? 0;
    final precio = double.tryParse(precioController.text.trim()) ?? 0.0;

    if (!InputValidator.validateField(context: context, value: espesor.toString(), fieldName: 'Espesor', validationType: TypeText.decimal) ||
        !InputValidator.validateField(context: context, value: largo.toString(), fieldName: 'Largo', validationType: TypeText.number) ||
        !InputValidator.validateField(context: context, value: ancho.toString(), fieldName: 'Ancho', validationType: TypeText.number) ||
        !InputValidator.validateField(context: context, value: precio.toString(), fieldName: 'Precio', validationType: TypeText.decimal)) {
      return;
    }

    if (proveedorSeleccionado == null) {
      MessageHandler.showErrorMessage(context, 'Debe seleccionar un proveedor');
      return;
    }

    ConfirmationDialog.show(
      context: context,
      onConfirm: () async {
        final datos = {
          'espesor': espesor,
          'largo': largo,
          'ancho': ancho,
          'precio_valor': precio,
          'proveedor_id': proveedorSeleccionado,
        };

        final success = await widget.onGuardar(datos);
        if (success) {
          Navigator.pop(context, true);
        } else {
          MessageHandler.showErrorMessage(context, 'Error al guardar');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.grey.shade900,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextSubTitle(
                text: 'Editar Plancha',
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                isUnderlined: true,
              ),
              const SizedBox(height: 12),

              LabelAboveWidget(
                label: 'Espesor',
                child: TextInputField(
                  hintText: 'Ingrese el espesor',
                  controller: espesorController,
                  keyboardType: TextInputType.number,
                  validationType: TypeText.decimal,
                  textColor: Colors.white,
                  backgroundColor: Colors.grey.shade800,
                  borderColor: Colors.blue.shade400,
                ),
              ),
              const SizedBox(height: 10),

              LabelAboveWidget(
                label: 'Largo',
                child: TextInputField(
                  hintText: 'Ingrese el largo',
                  controller: largoController,
                  keyboardType: TextInputType.number,
                  validationType: TypeText.number,
                  textColor: Colors.white,
                  backgroundColor: Colors.grey.shade800,
                  borderColor: Colors.blue.shade400,
                ),
              ),
              const SizedBox(height: 10),

              LabelAboveWidget(
                label: 'Ancho',
                child: TextInputField(
                  hintText: 'Ingrese el ancho',
                  controller: anchoController,
                  keyboardType: TextInputType.number,
                  validationType: TypeText.number,
                  textColor: Colors.white,
                  backgroundColor: Colors.grey.shade800,
                  borderColor: Colors.blue.shade400,
                ),
              ),
              const SizedBox(height: 10),

              LabelAboveWidget(
                label: 'Precio',
                child: TextInputField(
                  hintText: 'Ingrese el precio',
                  controller: precioController,
                  keyboardType: TextInputType.number,
                  validationType: TypeText.decimal,
                  textColor: Colors.white,
                  backgroundColor: Colors.grey.shade800,
                  borderColor: Colors.blue.shade400,
                ),
              ),
              const SizedBox(height: 10),

              LabelAboveWidget(
                label: 'Proveedor',
                child: DropdownInputField(
                  label: 'Seleccione un proveedor',
                  items: proveedores,
                  selectedValue: proveedorSeleccionado,
                  onChanged: (value) => setState(() => proveedorSeleccionado = value),
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
    );
  }
}
