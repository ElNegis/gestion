import 'package:flutter/material.dart';

class CenteredOptionList extends StatelessWidget {
  final List<dynamic> options;
  final Function(int) onSelected;

  const CenteredOptionList({
    Key? key,
    required this.options,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((option) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: GestureDetector(
            onTap: () {
              onSelected(option['id']);
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF3D3D4E), // Fondo oscuro para el botón
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Colors.green.shade400, // Borde verde
                  width: 2.0,
                ),
              ),
              child: Center(
                child: Text(
                  option['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
