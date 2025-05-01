import 'package:flutter/material.dart';
import '../text/CustomSnackBar.dart';

class HelpCircle extends StatelessWidget {
  final String helpText;

  const HelpCircle({Key? key, required this.helpText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CustomSnackbar.show(context, message: helpText,icon: Icons.help,isBold: true,duration: 10);
      },
      child: Container(
        height: 35, // Tamaño del círculo
        width: 35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
          border: Border.all(
            color: Colors.green,
            width: 2,
          ),
        ),
        child: const Center(
          child: Text(
            '?',
            style: TextStyle(
              color: Colors.green,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
