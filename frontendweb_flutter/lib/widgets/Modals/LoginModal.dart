import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontendweb_flutter/views/ManagerScren.dart';
import '../../model/AuthHandler.dart';
import '../../controllers/UserPermissionController.dart';
import '../images/BannerWidget.dart';
import '../botones/CustomButton.dart';
import '../text/CustomSnackBar.dart';
import '../text/text_input_field.dart';

class LoginModal extends StatefulWidget {
  final String bannerImagePath;
  final double? width;
  final AuthHandler authHandler;

  const LoginModal({
    Key? key,
    required this.bannerImagePath,
    this.width,
    required this.authHandler,
  }) : super(key: key);

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final modalWidth = widget.width ?? MediaQuery.of(context).size.width * 0.9;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: modalWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 24.0),
            BannerWidget(
              imagePath: widget.bannerImagePath,
              height: 150.0,
              width: modalWidth,
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextInputField(
                hintText: 'Usuario',
                controller: usernameController,
                width: modalWidth - 32.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextInputField(
                hintText: 'Contraseña',
                isPassword: true,
                controller: passwordController,
                width: modalWidth - 32.0,
              ),
            ),
            const SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomButton(
                buttonText: 'Iniciar Sesión',
                onPressed: () async {
                  final username = usernameController.text;
                  final password = passwordController.text;

                  if (username.isEmpty || password.isEmpty) {
                    CustomSnackbar.show(
                      context,
                      message: '¡Complete todos los campos!',
                      fontSize: 18.0,
                      icon: Icons.error,
                    );
                  } else {
                    final response =
                    await widget.authHandler.login(username, password);

                    if (response['success'] == true) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider(
                                create: (_) => UserPermissionController(
                                  authHandler: widget.authHandler,
                                ),
                              ),
                            ],
                            child: ManagerScreen(
                              username: username,
                              authHandler: widget.authHandler,
                            ),
                          ),
                        ),
                      );
                    } else {
                      final errorMessage = response['data']?['detail'] ??
                          response['error'] ??
                          'Inicio de sesión fallido. Verifique sus credenciales.';
                      CustomSnackbar.show(
                        context,
                        message: errorMessage,
                        fontSize: 18.0,
                        icon: Icons.error,
                      );
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}