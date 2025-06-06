import 'package:flutter/material.dart';

class MyColors {
  static const colorDefault = Colors.black;
  static const primaryColor = Color(0xFFC45BAA);
  static const secondaryColor = Color(0xFFE1D89F);
  static const thirdColor = Color(0xFFCD8B76);
  static const darkColor = Color(0xFF7D387D);
  static const darkColor2 = Color(0xFF27474E);
}

TextStyle basicStyle({double fontSize = 16, Color color = MyColors.colorDefault, FontWeight fontWeight = FontWeight.normal, TextDecoration decoration = TextDecoration.none }) {
  return TextStyle(
    fontFamily: 'PTSans',
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    decoration: decoration
  );
}
