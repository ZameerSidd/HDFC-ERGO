import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hdfc/constant/constant.dart';
import 'package:hdfc/screens/login/login.dart';
import 'package:hdfc/utils/utils.dart';

import '../../utils/color/color_constant.dart';

class DrawerScreen extends StatefulWidget {
  final void Function()? fun;
  final void Function()? fav;
  const DrawerScreen({super.key, required this.fun, required this.fav});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  String? username;
  @override
  void initState() {
    getUsername();
    super.initState();
  }

  getUsername() async {
    username = await Utils.getStringFromSF('name');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: ColorConstant.primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/download.png'),
              ),
              title: Text(
                username ?? 'Miroslava Savitskaya',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[200],
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              // subtitle: Text(
              //   'Active status',
              //   style: TextStyle(
              //     color: ColorConstant.white,
              //     fontWeight: FontWeight.bold,
              //     letterSpacing: .7,
              //   ),
              // ),
            ),
          ),
          Column(
            children: Constant.navList
                .map((e) => ListTile(
                      onTap: () {
                        if (e['title'] == 'Add Pet') {
                          widget.fun!();
                        } else if (e['title'] == 'Favorites') {
                          widget.fav!();
                        }
                      },
                      leading: Icon(
                        e['icon'],
                        color: ColorConstant.white,
                      ),
                      title: Text(
                        e['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorConstant.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ))
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Expanded(
                flex: 2,
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: ColorConstant.white,
                  ),
                  title: Text(
                    'Settings',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.white,
                      fontSize: 18.0,
                    ),
                  ),
                  minLeadingWidth: 10,
                ),
              ),
              Container(
                width: 1.5,
                height: 15,
                color: ColorConstant.white,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () async {
                    var response = await Utils.logOutDialog(context);
                    if (response) {
                      if (await Utils.clearSharedPreferance() ?? false) {
                        if (!mounted) return;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ));
                      }
                    } else {
                      log('no');
                    }
                  },
                  child: const Text(
                    'Log out',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
