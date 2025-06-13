import 'package:flutter/material.dart';

class CusText extends StatelessWidget {
  final String text ;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final String? fontFamily;
  final double? lineHeight ;
  final TextAlign? textAlignc;
  final TextDirection? textDirectionc;
  const CusText({super.key, required this.text, this.color, this.fontSize, this.fontWeight, this.textColor, this.fontFamily, this.lineHeight, this.textAlignc, this.textDirectionc});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlignc,
      textDirection: textDirectionc,
      style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight ,
          color:  textColor ,
          fontFamily: fontFamily,
        height: lineHeight,
        backgroundColor: color,
        decoration: TextDecoration.none
      ),
    );
  }
}
