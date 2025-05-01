import 'dart:math';
import 'package:flutter/material.dart';
import 'package:particle_field/particle_field.dart';

class ParticleBackground extends StatefulWidget {
  final int minParticles;
  final int maxParticles;

  const ParticleBackground({
    Key? key,
    this.minParticles = 50,
    this.maxParticles = 100,
  }) : super(key: key);

  @override
  _ParticleBackgroundState createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground> {
  final Random random = Random();
  bool isDisposed = false;

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final SpriteSheet spriteSheet = SpriteSheet(
      image: const AssetImage('assets/images/particle.png'),
      frameWidth: 16,
      frameHeight: 16,
    );

    final List<Color> colors = [
      const Color(0xFFFB035E), // Rojo
      const Color(0xFFF8D005), // Amarillo
      const Color(0xFF07DDBE), // Turquesa
    ];

    return Container(
      width: size.width,
      height: size.height,
      color: Colors.transparent,
      child: ParticleField(
        spriteSheet: spriteSheet,
        blendMode: BlendMode.plus,
        onTick: (controller, elapsed, fieldSize) {
          if (isDisposed) return; // Detener procesamiento si está desmontado.

          List<Particle> particles = controller.particles;

          // Generar partículas hasta el máximo permitido
          while (particles.length < widget.maxParticles) {
            particles.add(
              Particle(
                color: colors[random.nextInt(colors.length)],
                x: random.nextDouble() * fieldSize.width,
                y: random.nextDouble() * fieldSize.height,
                vx: random.nextDouble() * 0.5 - 0.25, // Velocidad X lenta
                vy: random.nextDouble() * 0.5 - 0.25, // Velocidad Y lenta
                scale: random.nextDouble() * 1.5 + 0.5, // Escala aleatoria
                lifespan: random.nextInt(300) + 200, // Duración aleatoria
              ),
            );
          }

          // Actualizar y eliminar partículas fuera de los límites o expiradas
          for (int i = particles.length - 1; i >= 0; i--) {
            final particle = particles[i];
            particle.update();

            if (particle.x < 0) particle.x = fieldSize.width - 1;
            if (particle.y < 0) particle.y = fieldSize.height - 1;

            if (!fieldSize.contains(particle.toOffset()) || particle.age > particle.lifespan) {
              particles.removeAt(i);
            }
          }

          // Asegurarse de mantener el mínimo de partículas
          while (particles.length < widget.minParticles) {
            particles.add(
              Particle(
                color: colors[random.nextInt(colors.length)],
                x: random.nextDouble() * fieldSize.width,
                y: random.nextDouble() * fieldSize.height,
                vx: random.nextDouble() * 2 - 0.5, // Velocidad X lenta
                vy: random.nextDouble() * 2 - 0.5, // Velocidad Y lenta
                scale: random.nextDouble() * 1.5 + 0.5,
                lifespan: random.nextInt(300) + 200,
              ),
            );
          }
        },
      ),
    );
  }
}
