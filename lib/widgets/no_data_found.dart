import 'package:flutter/material.dart';
import 'package:hdfc/utils/color/color_constant.dart';
import 'package:hdfc/utils/extensions/extension.dart';
import 'package:hdfc/utils/styles.dart';

class NoDataFound extends StatelessWidget {
  final void Function()? onpressed;
  const NoDataFound({Key? key, required this.onpressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(2.0)),
            child: Row(
              children: const [
                Text(
                  'No Pet Found',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: ColorConstant.balck54,
                  ),
                ),
              ],
            )),
        const SizedBox(height: 30),
        Image.asset(
          'assets/images/not_image_found.png',
          fit: BoxFit.fill,
        ),
        const SizedBox(height: 80),
        TextButton(
            style: ButtonStyle(
                padding: const MaterialStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                backgroundColor:
                    MaterialStatePropertyAll(ColorConstant.primaryColor)),
            onPressed: () {
              onpressed!();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.add,
                  color: ColorConstant.white,
                ),
                SizedBox(width: 20),
                Text(
                  'Add Pet',
                  style: Styles.style2,
                ),
              ],
            ))
      ],
    ).symmetric(horizontal: 20);
  }
}
