import 'package:flutter/material.dart';
import 'package:hdfc/utils/color/color_constant.dart';

class UnderConstruction extends StatelessWidget {
  final String title;
  const UnderConstruction({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.primaryColor_,
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: Image.asset(
          'assets/images/under_contruction.jpeg',
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
