import 'package:flutter/material.dart';

class BoxContainer extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final String title;
  final VoidCallback? onClick;

  const BoxContainer({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    required this.title,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: width ?? MediaQuery.of(context).size.width * 0.5,
            height: height ?? MediaQuery.of(context).size.height * 0.3,
            child: Image.asset(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8.0), // Espacio entre la imagen y el título
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
