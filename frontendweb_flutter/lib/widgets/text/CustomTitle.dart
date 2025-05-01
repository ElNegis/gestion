import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isBold;
  final double? titleFontSize;
  final double? subtitleFontSize;

  const CustomTitle({
    Key? key,
    required this.title,
    this.subtitle,
    this.isBold = true,
    this.titleFontSize = 24,
    this.subtitleFontSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.white,
            fontFamily: 'PressStart2P', // Personalización de fuente
            letterSpacing: 1.5,
          ),
        ),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              subtitle!,
              style: TextStyle(
                fontSize: subtitleFontSize,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: Colors.grey.shade400,
                fontFamily: 'PressStart2P',
                letterSpacing: 1.2,
              ),
            ),
          ),
      ],
    );
  }
}
