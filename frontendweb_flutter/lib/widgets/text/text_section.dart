import 'package:flutter/material.dart';

class TextSection extends StatelessWidget {
  final String title;
  final String text;
  const TextSection({super.key,
  required this.title,
    required this.text,});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'PressStart2P',
          ),
        ),
        const SizedBox(height: 16),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
            height: 1.5,
            fontFamily: 'PressStart2P',
          ),
        ),
      ],
    );
  }
}
