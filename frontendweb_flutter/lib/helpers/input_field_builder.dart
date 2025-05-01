import 'package:flutter/material.dart';
import '../widgets/text/text_input_field.dart';

class InputFieldBuilder {
  static Widget buildInputField(
      String label,
      String hint,
      TextEditingController controller, {
        double? width,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextInputField(
          hintText: hint,
          controller: controller,
          width: width,
        ),
      ],
    );
  }
}
