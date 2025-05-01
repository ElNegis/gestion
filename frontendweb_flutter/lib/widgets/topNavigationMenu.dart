import 'package:flutter/material.dart';
import 'MenuItemTop.dart';

class TopNavigationMenu extends StatelessWidget {
  final List<String> menuItems;
  final int currentIndex;
  final Function(int) onItemSelected;
  final double? width;
  final double? height;

  const TopNavigationMenu({
    super.key,
    required this.menuItems,
    required this.currentIndex,
    required this.onItemSelected,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width,
      height: height ?? 60,
      color: const Color(0xFF0D021E), // Fondo oscuro
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(menuItems.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(left: 0), // Espaciado a la izquierda
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white, // Bordes blancos alrededor
                    width: 1.0,
                  ),
                ),
                child: SizedBox(
                  width: 220, // Ancho fijo para cada opción
                  child: MenuItem(
                    title: menuItems[index],
                    isSelected: currentIndex == index,
                    onTap: () => onItemSelected(index),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
