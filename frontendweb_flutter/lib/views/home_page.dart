import 'package:flutter/material.dart';
import 'package:frontendweb_flutter/widgets/Modals/LoginModal.dart';
import '../widgets/botones/login_button.dart';
import '../widgets/images/image_container.dart';
import '../widgets/text/text_section.dart';
import '../widgets/particle_background.dart';
import '../model/AuthHandler.dart';
import '../model/RequestHandler.dart';

class HomePage extends StatelessWidget {
  final String imageUrl;

  const HomePage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    // Inicializar AuthHandler
    final authHandler = AuthHandler(requestHandler: RequestHandler());

    return Scaffold(
      body: Container(
        color: const Color(0xFF1F0119), // Establece el color de fondo aquí
        child: Stack(
          children: [
            const ParticleBackground(
              minParticles: 30,
              maxParticles: 60,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: ImageContainer(
                          imageUrl: imageUrl,
                          height: 650,
                          width: 900,
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: LoginButton(
                          imagePath: 'assets/images/SmilingFace.jpg',
                          buttonText: 'Iniciar Sesión',
                          onPressed: () async {
                            // Inicializar tokens al cargar la página
                            await authHandler.initialize();

                            showDialog(
                              context: context,
                              builder: (context) => LoginModal(
                                bannerImagePath: 'assets/images/Metalize_banner.png',
                                width: 800,
                                authHandler: authHandler, // Pasar AuthHandler al modal
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 20.0),
                    child: TextSection(
                      title: 'TÍTULO DUMMY',
                      text:
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s.',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
