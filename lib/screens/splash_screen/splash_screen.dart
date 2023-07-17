import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hdfc/screens/home/home_screen.dart';
import 'package:hdfc/screens/welcone/welcone_screen.dart';
import 'package:hdfc/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double width = 50;
  String? name = '';

  @override
  void initState() {
    getData();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        width = 400;
      });
    });
    super.initState();
  }

  getData() async {
    name = await Utils.getStringFromSF('name');
    log("token :$name");
    if (name != null && name!.isNotEmpty && name != 'Empty') {
      Future.delayed(const Duration(milliseconds: 1500), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      });
    } else {
      Future.delayed(const Duration(milliseconds: 1500), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Welcome()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
                width: width,
                duration: const Duration(seconds: 2),
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        width == 100 ? width = 400 : width = 100;
                      });
                    },
                    child: Image.asset('assets/images/logo2.png'))),
          ],
        ),
      ),
    );
  }
}
