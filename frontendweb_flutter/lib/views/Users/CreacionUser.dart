import 'package:flutter/material.dart';
import 'package:frontendweb_flutter/widgets/LabelAboveWidget.dart';
import '../../controllers/UserController.dart';
import '../../model/AuthHandler.dart';
import '../../widgets/botones/CustomButton.dart';
import '../../widgets/text/CustomSnackBar.dart';
import '../../widgets/text/PasswordVerificationField.dart';
import '../../widgets/text/text_input_field.dart';

class UserCreationScreen extends StatefulWidget {
  final AuthHandler authHandler;

  const UserCreationScreen({Key? key, required this.authHandler}) : super(key: key);

  @override
  _UserCreationScreenState createState() => _UserCreationScreenState();
}

class _UserCreationScreenState extends State<UserCreationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  late final UserController userController; // 🔹 Instancia del UserController
  Map<String, dynamic>? createdUser;

  @override
  void initState() {
    super.initState();
    userController = UserController(authHandler: widget.authHandler); // 🔹 Inicializamos el controlador
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildForm(context),
                ),
              ),
            ),
          ),
          if (createdUser != null)
            Expanded(
              flex: 2,
              child: Center(
                child: Container(
                  width: 300.0,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.pinkAccent, width: 4.0),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.6),
                        blurRadius: 15,
                        spreadRadius: 5,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "¡USUARIO CREADO!",
                        style: TextStyle(
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          fontFamily: 'PressStart2P',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "USERNAME:\n${createdUser!['username']}\n\n"
                            "NOMBRE:\n${createdUser!['nombre']}\n\n"
                            "APELLIDO:\n${createdUser!['apellido']}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 3,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.cyanAccent,
                              Colors.yellowAccent,
                            ],
                            stops: const [0.3, 0.6, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "CREACIÓN DE USUARIO",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        TextInputField(
          hintText: 'Nombre',
          controller: nameController,
        ),
        const SizedBox(height: 16),
        TextInputField(
          hintText: 'Apellido',
          controller: lastNameController,
        ),
        const SizedBox(height: 16),
        LabelAboveWidget(
          label: "Contraseña",
          child: PasswordVerificationField(
            passwordController: passwordController,
            confirmPasswordController: confirmPasswordController,
            isDoubleField: true,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              buttonText: "CANCELAR",
              buttonColor: const Color(0xFFB35A58),
              textColor: Colors.white,
              onPressed: _resetForm,
            ),
            const SizedBox(width: 16),
            CustomButton(
              buttonText: "CONFIRMAR",
              buttonColor: const Color(0xFF2E8B57),
              textColor: Colors.white,
              onPressed: () => _createUser(context),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _createUser(BuildContext context) async {
    if (nameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      return _showError('¡Complete todos los campos!');
    }

    if (passwordController.text != confirmPasswordController.text) {
      return _showError('Las contraseñas no coinciden');
    }

    final response = await userController.createUser(
      context,
      nameController.text,
      lastNameController.text,
      passwordController.text,
    );

    if (response != null && response is Map<String, dynamic>) {
      setState(() {
        createdUser = {
          'username': response['username'],  // Ahora usa el username real
          'nombre': response['nombre'],
          'apellido': response['apellido'],
        };
      });
      _resetForm();
    }
  }


  void _showError(String message) {
    CustomSnackbar.show(
      context,
      message: message,
      fontSize: 18.0,
      icon: Icons.error,
    );
  }

  void _resetForm() {
    nameController.clear();
    lastNameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }
}
