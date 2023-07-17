import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hdfc/utils/color/color_constant.dart';

Widget formField(
    {String? hintText,
    TextEditingController? controller,
    void Function(String val)? onChanged,
    void Function(String? val)? onSaved,
    void Function()? onVisibility,
    String? Function(String? val)? validator,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? inputType,
    bool? suffix,
    bool? obscurePassword}) {
  return TextFormField(
    onChanged: onChanged,
    keyboardType: inputType,
    inputFormatters: inputFormatters,
    onSaved: onSaved,
    controller: controller,
    obscureText: obscurePassword ?? false,
    validator: validator,
    decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: ColorConstant.balck45)),
        suffixIcon: suffix == true
            ? GestureDetector(
                onTap: onVisibility,
                child: obscurePassword == true
                    ? Icon(
                        Icons.visibility_off,
                        color: ColorConstant.balck.withOpacity(0.7),
                      )
                    : const Icon(
                        Icons.visibility,
                        color: ColorConstant.balck45,
                      ))
            : null,
        hintStyle: const TextStyle(fontSize: 14),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
        filled: true,
        isCollapsed: true,
        isDense: true,
        fillColor: ColorConstant.white,
        hintText: hintText ?? 'Hint Text',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
  );
}
