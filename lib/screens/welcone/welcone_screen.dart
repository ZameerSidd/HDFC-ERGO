import 'package:flutter/material.dart';
import 'package:hdfc/screens/login/login.dart';
import 'package:hdfc/screens/sign_up/sign_up.dart';
import 'package:hdfc/utils/color/color_constant.dart';
import 'package:hdfc/utils/extensions/extension.dart';
import 'package:hdfc/utils/styles.dart';
import 'package:hdfc/widgets/button.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    var currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: ColorConstant.grey200,
        body: SizedBox(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset("assets/images/background.png"),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome!',
                      style: Styles.style,
                    ).symmetric(horizontal: 15),
                    const Text(
                      'Explore your activity.',
                      style: Styles.style1,
                    ).symmetric(horizontal: 15),
                    const SizedBox(height: 40),
                    CustomButton.button(
                      text: 'SIGN IN',
                      bgColor: ColorConstant.primaryColor,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ));
                      },
                    ).symmetric(horizontal: 15),
                    const SizedBox(height: 20),
                    CustomButton.button(
                      text: 'SIGN UP',
                      bgColor: ColorConstant.white,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUp(),
                            ));
                      },
                    ).symmetric(horizontal: 15)
                  ],
                ),
              ),
              Positioned(
                  top: 0,
                  left: (currentWidth / 10),
                  child: Image.asset('assets/images/light-1.png')),
              Positioned(
                  top: 0,
                  left: (currentWidth / 4) * 1.8,
                  child: Image.asset('assets/images/light-2.png')),
              Positioned(
                  top: 80,
                  left: (currentWidth / 4) * 3,
                  child: Image.asset('assets/images/clock.png')),
            ],
          ),
        ));
  }
}
