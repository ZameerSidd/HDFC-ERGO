import 'package:flutter/material.dart';
import 'package:hdfc/utils/color/color_constant.dart';
import 'package:hdfc/widgets/picked_image_bootom_sheet.dart';

class SomethingWrong extends StatelessWidget {
  final void Function()? tryAhin;
  const SomethingWrong({Key? key, requirede, required this.tryAhin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/something_wrong.png',
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        const Positioned(
          bottom: 230,
          left: 160,
          child: Text(
            'Oops!',
            style: kTitleTextStyle,
          ),
        ),
        const Positioned(
          bottom: 170,
          left: 100,
          child: Text(
            'Something went wrong,\nplease try again.',
            style: kSubtitleTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Positioned(
          bottom: 100,
          left: 130,
          right: 130,
          child: TextButton(
            style: const ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(ColorConstant.balck54)),
            onPressed: tryAhin,
            child: const Text(
              'Try Again',
              style: TextStyle(color: ColorConstant.white),
            ),
          ),
        ),
      ],
    );
  }
}
