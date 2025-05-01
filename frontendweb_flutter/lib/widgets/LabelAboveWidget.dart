import 'package:flutter/material.dart';

class LabelAboveWidget extends StatelessWidget {
  final String label;
  final Widget child;

  const LabelAboveWidget({Key? key, required this.label, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}
