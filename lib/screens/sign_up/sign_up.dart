import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hdfc/screens/login/login.dart';
import 'package:hdfc/services/network_manager.dart';
import 'package:hdfc/utils/extensions/extension.dart';
import 'package:hdfc/utils/utils.dart';
import 'package:hdfc/widgets/textfield.dart';

import '../../utils/color/color_constant.dart';
import '../../utils/styles.dart';
import '../../widgets/alert_dialog.dart';
import '../../widgets/button.dart';
import '../home/home_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confrimPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _confirmObscurePassword = true;

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
                  "Let's Get\nStarted!",
                  style: Styles.style,
                ),
                const Text(
                  'Create your account.',
                  style: Styles.style1,
                ),
                const SizedBox(height: 60),
                const Text('Username*', style: Styles.textField),
                formField(
                    controller: _nameController,
                    inputType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Invalid Name";
                      } else if (val.length < 3) {
                        return "Invalid name";
                      }
                      return null;
                    },
                    hintText: 'Enter username'),
                const SizedBox(height: 10),
                const Text('Email Address*', style: Styles.textField),
                formField(
                    controller: _emailController,
                    inputType: TextInputType.emailAddress,
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
                    controller: _passwordController,
                    hintText: 'Enter Password',
                    suffix: true,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Invalid password";
                      } else if (val.length < 8 &&
                          _confrimPasswordController.value.text.length < 8) {
                        log('${val.length}/${_confrimPasswordController.value.text.length}');
                        return "Password must greater than 8 char";
                      }
                      return null;
                    },
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
                const SizedBox(height: 10),
                const Text(
                  'Confirm Password*',
                  style: Styles.textField,
                ),
                formField(
                    controller: _confrimPasswordController,
                    hintText: 'Enter Confirm Password',
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Invalid confirm password";
                      } else if (val != _passwordController.value.text) {
                        return "Password and confirm password didn't match";
                      }
                      return null;
                    },
                    suffix: true,
                    onVisibility: () {
                      setState(() {
                        if (_confirmObscurePassword) {
                          _confirmObscurePassword = false;
                        } else {
                          _confirmObscurePassword = true;
                        }
                      });
                    },
                    obscurePassword: _confirmObscurePassword),
                const SizedBox(height: 60),
                CustomButton.button(
                  text: 'SIGN UP',
                  bgColor: ColorConstant.primaryColor,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      loadingDialog();
                    }
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ));
                  },
                  child: Center(
                    child: RichText(
                      text: TextSpan(children: [
                        const TextSpan(
                          text: "Already have an account?",
                          style: Styles.account,
                        ),
                        TextSpan(
                          text: "SING IN",
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
    registeruser();
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

  registeruser() async {
    var response = await NetworkManager.signUp(
        _confrimPasswordController.value.text,
        _emailController.value.text,
        _nameController.value.text);
    if (response != null && response is String) {
      log(response);
      if (!mounted) return;
      Navigator.pop(context);
      showAlert(context, response);
    } else if (response != null && response is UserCredential) {
      var token = await response.user!.getIdToken();
      Utils.addStringToSF('name', _nameController.value.text);
      Utils.addStringToSF('email', _emailController.value.text);
      Utils.addStringToSF('password', _passwordController.value.text);
      Utils.addStringToSF('Token', token ?? "Empty");
      if (!mounted) return;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
    } else if (response == null) {
      log('Some thing went wrong');
      if (!mounted) return;
      Navigator.pop(context);
      showAlert(context, "An error occured. Please try again later.");
    }
  }
}
