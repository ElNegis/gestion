import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;

  const ImageContainer({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width ?? MediaQuery.of(context).size.width * 0.5,
        height: height ?? MediaQuery.of(context).size.height * 0.3,
        child: Image.asset(
          imageUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
