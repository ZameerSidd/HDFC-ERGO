import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hdfc/screens/home/home_screen.dart';
import 'package:hdfc/screens/sign_up/sign_up.dart';
import 'package:hdfc/services/network_manager.dart';
import 'package:hdfc/utils/color/color_constant.dart';
import 'package:hdfc/utils/extensions/extension.dart';
import 'package:hdfc/utils/styles.dart';
import 'package:hdfc/utils/utils.dart';
import 'package:hdfc/widgets/alert_dialog.dart';
import 'package:hdfc/widgets/button.dart';
import 'package:hdfc/widgets/textfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.grey300,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                CustomButton.backButton(onPressed: () {
                  Navigator.pop(context);
                }),
                const SizedBox(height: 30),
                Text(
                  'Welcome\nBack!',
                  style: Styles.style,
                ),
                const Text(
                  'Sign to continue.',
                  style: Styles.style1,
                ),
                const SizedBox(height: 60),
                const Text('Email Address*', style: Styles.textField),
                formField(
                    inputType: TextInputType.emailAddress,
                    controller: _controllerUsername,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Invalid Email";
                      } else if (!val.contains('@')) {
                        return "Invalid format";
                      }
                      return null;
                    },
                    hintText: 'Enter Email Address'),
                const SizedBox(height: 10),
                const Text(
                  'Password*',
                  style: Styles.textField,
                ),
                formField(
                    controller: _controllerPassword,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Invalid Email";
                      } else if (val.length < 6) {
                        return "Length must be greater then 6";
                      }
                      return null;
                    },
                    hintText: 'Enter Password',
                    suffix: true,
                    onVisibility: () {
                      setState(() {
                        if (_obscurePassword) {
                          _obscurePassword = false;
                        } else {
                          _obscurePassword = true;
                        }
                      });
                    },
                    obscurePassword: _obscurePassword),
                GestureDetector(
                  onTap: () {
                    // showAlert(context, '');
                  },
                  child: Text(
                    'Forgot your passowrd?',
                    style: Styles.forgotPassowrd,
                  ),
                ),
                const SizedBox(height: 60),
                CustomButton.button(
                  text: 'SIGN IN',
                  bgColor: ColorConstant.primaryColor,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {}
                    loadingDialog();
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUp(),
                        ));
                  },
                  child: Center(
                    child: RichText(
                      text: TextSpan(children: [
                        const TextSpan(
                          text: "Don't have an account?",
                          style: Styles.account,
                        ),
                        TextSpan(
                          text: "SING UP",
                          style: Styles.singButton,
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 30)
              ],
            ).symmetric(horizontal: 15),
          ),
        ),
      ),
    );
  }

  loadingDialog() {
    signIn();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: const [
                CircularProgressIndicator(),
                SizedBox(width: 16.0),
                Text('Loading...'),
              ],
            ),
          ),
        );
      },
    );
  }

  signIn() async {
    var response = await NetworkManager.signIn(
        _controllerPassword.value.text, _controllerUsername.value.text);
    if (response != null && response is String) {
      log(response.toString());
      if (!mounted) return;
      Navigator.pop(context);
      showAlert(context, response);
    } else if (response is UserCredential) {
      var token = await response.user!.getIdToken();
      Utils.addStringToSF('email', _controllerUsername.value.text);
      Utils.addStringToSF('name', response.user!.displayName ?? "Empty");
      Utils.addStringToSF('password', _controllerPassword.value.text);
      Utils.addStringToSF('Token', token ?? "Empty");
      if (!mounted) return;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
    } else {
      log('Something went wrong');
      if (!mounted) return;
      Navigator.pop(context);
      showAlert(context, "An error occured. Please try again later.");
    }
  }
}
