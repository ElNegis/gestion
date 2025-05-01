import 'package:flutter/material.dart';
import 'images/image_container.dart';
import 'MenuItem.dart';

class NavigationMenu extends StatelessWidget {
  final List<String> menuItems;
  final int currentIndex;
  final Function(int) onItemSelected;

  const NavigationMenu({
    super.key,
    required this.menuItems,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth > 600 ? 250 : constraints.maxWidth * 0.7, // Responsividad
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.white, width: 1), // Marco principal blanco
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Imagen centrada arriba
              const Center(
                child: ImageContainer(
                  imageUrl: 'assets/images/SmilingFace.jpg',height: 110,width: 80,
                ),
              ),
              const SizedBox(height: 20),

              // Opciones de menú
              Expanded(
                child: Column(
                  children: List.generate(menuItems.length, (index) {
                    return MenuItem(
                      title: menuItems[index],
                      isSelected: index == currentIndex,
                      onTap: () => onItemSelected(index),
                    );
                  }),
                ),
              ),

              // Sección de usuarios
              const Divider(color: Colors.white, height: 1),

            ],
          ),
        );
      },
    );
  }
}