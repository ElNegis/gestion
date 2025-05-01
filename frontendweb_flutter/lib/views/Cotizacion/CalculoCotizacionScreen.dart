import 'package:flutter/material.dart';
import 'package:frontendweb_flutter/widgets/LabelAboveWidget.dart';
import 'package:frontendweb_flutter/widgets/text/CustomSnackBar.dart';
import 'package:frontendweb_flutter/widgets/text/type_text_enum.dart';
import '../../controllers/CalculoController.dart';
import '../../widgets/botones/CustomButton.dart';
import '../../widgets/ResultadoWidget.dart';
import '../../widgets/text/text_input_field.dart';

class CalculoPiezasScreen extends StatefulWidget {
  final CalculoController calculoController;

  const CalculoPiezasScreen({Key? key, required this.calculoController}) : super(key: key);

  @override
  _CalculoPiezasScreenState createState() => _CalculoPiezasScreenState();
}

class _CalculoPiezasScreenState extends State<CalculoPiezasScreen> {
  final TextEditingController espesorController = TextEditingController();
  final TextEditingController largoController = TextEditingController();
  final TextEditingController anchoController = TextEditingController();
  final TextEditingController golpesController = TextEditingController();
  final TextEditingController piezasController = TextEditingController();

  Map<String, dynamic>? resultado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Piezas'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Ingrese los datos de la pieza para el cálculo:",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              _buildInputFields(),
              const SizedBox(height: 16),
              CustomButton(
                buttonText: 'Calcular',
                buttonColor: Colors.blue,
                textColor: Colors.white,
                onPressed: () async {
                  if (!_validarCampos()) {
                    _mostrarError('Por favor, complete todos los campos.');
                    return;
                  }

                  final datos = {
                    "espesor": double.tryParse(espesorController.text) ?? 0,
                    "largo_pieza": double.tryParse(largoController.text) ?? 0,
                    "ancho_pieza": double.tryParse(anchoController.text) ?? 0,
                    "cantidad_golpes": int.tryParse(golpesController.text) ?? 0,
                    "cantidad_piezas": int.tryParse(piezasController.text) ?? 0,
                  };

                  final success = await widget.calculoController.calcularPiezas(datos);
                  if (success) {
                    setState(() {
                      resultado = widget.calculoController.getResultado();
                    });
                  } else {
                    _mostrarError('Error al calcular las piezas. Inténtelo nuevamente.');
                  }
                },
              ),
              const SizedBox(height: 24),
              if (resultado != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ResultadoWidget(resultado: resultado!),
                ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }

  Widget _buildInputFields() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildCenteredLabelInput('Espesor', espesorController, 'Espesor (mm)', Icons.numbers_sharp),
        _buildCenteredLabelInput('Largo', largoController, 'Largo de la pieza (mm)', Icons.density_large_sharp),
        _buildCenteredLabelInput('Ancho', anchoController, 'Ancho de la pieza (mm)', Icons.density_small_sharp),
        _buildCenteredLabelInput('Golpes', golpesController, 'Cantidad de golpes', Icons.handyman),
        _buildCenteredLabelInput('Piezas', piezasController, 'Cantidad de piezas', Icons.workspaces),
      ],
    );
  }

  Widget _buildCenteredLabelInput(String label, TextEditingController controller, String hintText, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: LabelAboveWidget(
        label: label,
        child: TextInputField(
          hintText: hintText,
          controller: controller,
          keyboardType: TextInputType.number,
          validationType: TypeText.number,
          prefixIcon: Icon(icon, color: Colors.black),
        ),
      ),
    );
  }

  bool _validarCampos() {
    return espesorController.text.isNotEmpty &&
        largoController.text.isNotEmpty &&
        anchoController.text.isNotEmpty &&
        golpesController.text.isNotEmpty &&
        piezasController.text.isNotEmpty;
  }

  void _mostrarError(String mensaje) {
    CustomSnackbar.show(context, message: mensaje, icon: Icons.warning);
  }
}
