import 'package:flutter/material.dart';
import 'package:frontendweb_flutter/widgets/LabelAboveWidget.dart';
import '../../service/CortePlegado/CortePlegadoService.dart';
import '../../widgets/text/CustomSnackBar.dart';
import'../../widgets/text/text_input_field.dart';
import '../../widgets/botones/CustomButton.dart';
import'../../widgets/images/image_container.dart';
import '../../model/AuthHandler.dart';
import '../../widgets/text/type_text_enum.dart';

class CortePlegadoScreenAdd extends StatelessWidget {
  final AuthHandler authHandler;

  const CortePlegadoScreenAdd({Key? key, required this.authHandler}) : super(key: key);

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
                        aspectRatio: 1,
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
                      aspectRatio: 1,
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
    final TextEditingController espesorController = TextEditingController();
    final TextEditingController largoController = TextEditingController();
    final TextEditingController precioController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "CORTE PLEGADO",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        LabelAboveWidget(label: 'Espesor',
            child:
            TextInputField(
              hintText: "Ingresa el espesor",
              controller: espesorController,
              validationType: TypeText.decimal ,
              prefixIcon: const Icon(Icons.density_small_sharp, color: Colors.green,),
            ))
        ,
        const SizedBox(height: 16),
        LabelAboveWidget(label: 'Largo', 
            child:TextInputField(
              hintText: "Ingresa el largo",
              controller: largoController,
              validationType: TypeText.decimal ,
              prefixIcon: const Icon(Icons.density_large_sharp, color: Colors.green,),
  
            ), ),
        
        const SizedBox(height: 16),
        LabelAboveWidget(label: 'Precio',
            child: TextInputField(
              hintText: "Ingresa el precio",
              controller: precioController,
              validationType: TypeText.decimal ,
              prefixIcon: const Icon(Icons.monetization_on_outlined, color: Colors.green,),

            ),
        ),
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
              onPressed: () => _agregarCortePlegado(
                context,
                espesorController.text,
                largoController.text,
                precioController.text,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _agregarCortePlegado(
      BuildContext context,
      String espesor,
      String largo,
      String precio,
      ) async {
    if (espesor.isEmpty || largo.isEmpty || precio.isEmpty) {
      CustomSnackbar.show(
        context,
        message: '¡Complete todos los campos!',
        fontSize: 18.0,
        icon: Icons.error,
      );
      return;
    }

    final double? espesorNum = double.tryParse(espesor);
    final double? largoNum = double.tryParse(largo);
    final double? precioNum = double.tryParse(precio);

    if (espesorNum == null || largoNum == null || precioNum == null) {
      CustomSnackbar.show(
        context,
        message: 'Por favor ingrese valores numéricos válidos.',
        fontSize: 18.0,
        icon: Icons.error,
      );
      return;
    }

    try {
      final success = await CortePlegadoService.crearCortePlegado(
        authHandler,
        {
          'espesor': espesorNum,
          'largo': largoNum,
          'precio': precioNum,
        },
      );

      if (success) {
        CustomSnackbar.show(
          context,
          message: 'Corte plegado creado correctamente',
          fontSize: 18.0,
          icon: Icons.check,
          textColor: Colors.green,
        );
      }
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
