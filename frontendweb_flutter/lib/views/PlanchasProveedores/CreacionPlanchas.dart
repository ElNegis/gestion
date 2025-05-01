import 'package:flutter/material.dart';
import 'package:frontendweb_flutter/widgets/LabelAboveWidget.dart';
import '../../service/PlanchasService.dart';
import 'package:frontendweb_flutter/widgets/text/CustomSnackBar.dart';
import '../../service/ProoveedorService.dart';
import '../../widgets/botones/DropDownCustom.dart';
import '../../widgets/botones/CustomButton.dart';
import '../../widgets/images/image_container.dart';
import '../../widgets/text/text_input_field.dart';
import '../../model/AuthHandler.dart';
import '../../widgets/text/type_text_enum.dart';

class PlanchasScreenAdd extends StatefulWidget {
  final AuthHandler authHandler; // AuthHandler para manejar tokens

  const PlanchasScreenAdd({Key? key, required this.authHandler})
      : super(key: key);

  @override
  _PlanchasScreenAddState createState() => _PlanchasScreenAddState();
}

class _PlanchasScreenAddState extends State<PlanchasScreenAdd> {
  final TextEditingController thicknessController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  int? idProveedorSeleccionado;

  void _crearPlancha(BuildContext context) async {
    try {
      if (thicknessController.text.isEmpty ||
          lengthController.text.isEmpty ||
          widthController.text.isEmpty ||
          priceController.text.isEmpty ||
          idProveedorSeleccionado == null) {
        CustomSnackbar.show(
          context,
          message: 'Por favor, ingrese todos los datos correctamente.',
          textColor: Colors.red,
        );
        return;
      }

      final double espesor = double.parse(thicknessController.text);
      final int largo = int.parse(lengthController.text);
      final int ancho = int.parse(widthController.text);
      final double precio = double.parse(priceController.text);

      final plancha = PlanchaService(
        espesor: espesor,
        largo: largo,
        ancho: ancho,
        precioValor: precio,
        proveedorId: idProveedorSeleccionado!,
        authHandler: widget.authHandler,
      );

      await plancha.CreacionPlancha();

      CustomSnackbar.show(
        context,
        message: 'Plancha creada exitosamente',
        textColor: Colors.green,
      );
    } catch (e) {
      CustomSnackbar.show(
        context,
        message: 'Ocurrió un error inesperado: $e',
        textColor: Colors.red,
      );
    }
  }

  Widget _buildDropdown(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ProveedorService.ObtenerProveedores(widget.authHandler),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: const TextStyle(color: Colors.red),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text(
            'No se encontraron proveedores',
            style: TextStyle(color: Colors.white),
          );
        } else {
          final proveedores = snapshot.data!;
          return CustomDropdown(
            items: proveedores,
            hintText: idProveedorSeleccionado != null
                ? proveedores
                .firstWhere((p) => p['id'] == idProveedorSeleccionado)['nombre']
                : "Selecciona un proveedor",
            onChanged: (value) {
              final proveedorSeleccionado = proveedores.firstWhere(
                    (p) => p['id'] == value,
                orElse: () => {},
              );
              setState(() {
                idProveedorSeleccionado = proveedorSeleccionado['id'];
              });
            },
          );
        }
      },
    );
  }

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField("Epesor", "Ingresa el espesor", thicknessController),
        const SizedBox(height: 16),
        _buildInputField("Largo", "Ingresa el largo", lengthController),
        const SizedBox(height: 16),
        _buildInputField("Ancho", "Ingresa el ancho", widthController),
        const SizedBox(height: 16),
        const Text(
          "Proveedor",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildDropdown(context),
        const SizedBox(height: 16),
        _buildInputField("PRECIO", "Ingresa el precio", priceController),
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
              onPressed: () => _crearPlancha(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputField(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        LabelAboveWidget(label: label, 
            child:
            TextInputField(
              hintText: hint,
              controller: controller,
              validationType: TypeText.decimal ,
              prefixIcon: const Icon(Icons.numbers_rounded, color: Colors.blue,),
            ),
        ),
        
      ],
    );
  }
}
