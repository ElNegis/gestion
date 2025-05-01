import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  final String imagePath;
  final double height;
  final double width;

  const BannerWidget({
    Key? key,
    required this.imagePath,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: (width*height)/2,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
