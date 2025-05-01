import 'package:flutter/material.dart';

class TextSubTitle extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final Color? color;
  final double fontSize;
  final FontWeight fontWeight;
  final List<Shadow>? shadows;
  final bool isUnderlined;

  const TextSubTitle({
    Key? key,
    required this.text,
    this.textAlign,
    this.color = Colors.grey,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.w400,
    this.shadows,
    this.isUnderlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        shadows: shadows ??
            [
              const Shadow(
                color: Colors.black38,
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
        decoration: isUnderlined ? TextDecoration.underline : TextDecoration.none,
      ),
    );
  }
}
