import 'package:flutter/material.dart';

import '../utils/color/color_constant.dart';

class CustomButton {
  static Widget button(
      {String? text, void Function()? onPressed, Color? bgColor}) {
    return ElevatedButton(
        style: ButtonStyle(
            padding: const MaterialStatePropertyAll(
                EdgeInsets.symmetric(vertical: 12)),
            backgroundColor: MaterialStatePropertyAll(
                bgColor ?? ColorConstant.primaryColor)),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text ?? 'Press',
              style: TextStyle(
                  color: bgColor == Colors.white
                      ? ColorConstant.primaryColor
                      : ColorConstant.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 17),
            ),
          ],
        ));
  }

  static Widget backButton({void Function()? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              border: Border.all(color: ColorConstant.grey300.withOpacity(0.7)),
              color: ColorConstant.white,
              shape: BoxShape.circle),
          child: const Icon(
            Icons.arrow_back,
            color: ColorConstant.balck54,
          )),
    );
  }
}
