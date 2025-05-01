import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const MenuItem({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white, width: 1),
          ),
          color: isSelected ? Colors.black45 : Colors.transparent,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center, // Centra el texto en el contenedor
          softWrap: true,
          overflow: TextOverflow.visible,
          maxLines: 2,
          style: TextStyle(
            color: isSelected ? const Color(0xFFFB035E) : Colors.grey.shade400,
            fontSize: 18,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}
