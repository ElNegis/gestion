import 'package:flutter/material.dart';
import '../../model/AuthHandler.dart';
import '../../widgets/botones/CustomButton.dart';
import '../../widgets/text/CustomTitle.dart';
import '../../widgets/proveedor_dropdown.dart';
import '../../widgets/text/text_input_field.dart';

class EditPlanchaModal extends StatelessWidget {
  final TextEditingController espesorController;
  final TextEditingController largoController;
  final TextEditingController anchoController;
  final TextEditingController precioController;
  final int? proveedorSeleccionado;
  final AuthHandler authHandler; // Para manejar autenticación
  final Function(int?) onProveedorChanged; // Callback al seleccionar proveedor
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const EditPlanchaModal({
    Key? key,
    required this.espesorController,
    required this.largoController,
    required this.anchoController,
    required this.precioController,
    required this.proveedorSeleccionado,
    required this.authHandler,
    required this.onProveedorChanged,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('=== EditPlanchaModal.build() invocado ===');
    print('espesorController.text: ${espesorController.text}');
    print('largoController.text: ${largoController.text}');
    print('anchoController.text: ${anchoController.text}');
    print('precioController.text: ${precioController.text}');
    print('proveedorSeleccionado: $proveedorSeleccionado');

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: const Color(0xFF2D2D3C),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Ajusta el tamaño para contener únicamente sus hijos
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTitle(
              title: 'Editar Plancha',
              subtitle: 'Modifica los campos necesarios.',
            ),
            const SizedBox(height: 16),
            TextInputField(
              hintText: 'Espesor',
              controller: espesorController,
            ),
            const SizedBox(height: 16),
            TextInputField(
              hintText: 'Largo',
              controller: largoController,
            ),
            const SizedBox(height: 16),
            TextInputField(
              hintText: 'Ancho',
              controller: anchoController,
            ),
            const SizedBox(height: 16),
            TextInputField(
              hintText: 'Precio Valor',
              controller: precioController,
            ),
            const SizedBox(height: 16),
            ProveedorDropdown(
              authHandler: authHandler,
              idProveedorSeleccionado: proveedorSeleccionado,
              onChanged: (nuevoValor) {
                print('ProveedorDropdown.onChanged => nuevoValor: $nuevoValor');
                onProveedorChanged(nuevoValor);
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  buttonText: 'Guardar',
                  buttonColor: Colors.green,
                  onPressed: onSave,
                ),
                CustomButton(
                  buttonText: 'Cancelar',
                  buttonColor: Colors.red,
                  onPressed: onCancel,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
