import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

Color activeInactive(String? status) {
  if (status == "Active") {
    return Color.fromARGB(255, 53, 255, 59);
  } else if (status == "Inactive") {
    return Color.fromARGB(255, 255, 17, 0);
  }
  return Colors.black;
}

class Palette {
  static const Color background = Color(0xFFEDEEF2);
  static const Color wrapperBg = Color(0xFF212121);
}
