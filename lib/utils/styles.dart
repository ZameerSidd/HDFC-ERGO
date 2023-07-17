import 'package:flutter/material.dart';

import 'color/color_constant.dart';

class Styles {
  static TextStyle style = TextStyle(
      color: ColorConstant.primaryColor,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      fontSize: 30);
  static TextStyle singButton = TextStyle(
      decoration: TextDecoration.underline,
      color: ColorConstant.primaryColor,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
      fontSize: 17);
  static TextStyle forgotPassowrd = TextStyle(
      fontFamily: 'Poppins', fontSize: 13, color: ColorConstant.primaryColor);
  static const TextStyle account = TextStyle(
      fontFamily: 'Poppins', fontSize: 13, color: ColorConstant.balck54);
  static const TextStyle style1 = TextStyle(
      color: ColorConstant.grey,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
      fontSize: 17);
  static const TextStyle style2 = TextStyle(
      color: ColorConstant.white,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
      fontSize: 17);
  static const TextStyle textField =
      TextStyle(fontFamily: 'Poppins', color: ColorConstant.balck45);
}
