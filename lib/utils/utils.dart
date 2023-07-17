import 'package:flutter/material.dart';
import 'package:hdfc/utils/color/color_constant.dart';
import 'package:hdfc/utils/extensions/extension.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

import '../screens/login/login.dart';

class Utils {
  static SimpleFontelicoProgressDialog? _dialog;

  static Future addStringToSF(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getStringFromSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString(key);
    return stringValue;
  }

  static Future<bool?> clearSharedPreferance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }

  static Future<bool?> removeStringFromSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }

  static hideProgressDialog() async {
    if (_dialog != null) {
      _dialog!.hide();
    }
  }

  static Future<XFile?> pickedImageFromCamera() async {
    XFile? imageFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      return imageFile;
    } else {
      return null;
    }
  }

  static Future<bool> logOutDialog(BuildContext context, {bool? delete}) async {
    bool val = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text((delete != null && delete) ? "Delete" : 'Logout'),
          content: Text((delete != null && delete)
              ? "Are you sure you want to delete?"
              : "Are you sure you want to logout?"),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                val = true;
              },
            ),
            TextButton(
              child: Text((delete != null && delete) ? "Delete" : 'Logout'),
              onPressed: () async {
                Navigator.pop(context);
                val = true;
              },
            ),
          ],
        );
      },
    );
    return val;
  }

  static Future<bool> simpleDialog(BuildContext context,
      {String? title, String? buttonName, String? subTitle}) async {
    bool val = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? "Title"),
          content: Text(subTitle ?? "Subtitle"),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                val = false;
              },
            ),
            TextButton(
              child: Text(buttonName ?? "Press"),
              onPressed: () async {
                Navigator.pop(context);
                val = true;
              },
            ),
          ],
        );
      },
    );
    return val;
  }

  static String checkNullString(String? inputString) {
    if (inputString != null) {
      if (inputString.trim().isNotEmpty) {
        return inputString;
      } else {
        return 'N/A.';
      }
    } else {
      return "N/A";
    }
  }

  static showSimpleSnacbar(BuildContext context, msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        backgroundColor: ColorConstant.primaryColor_,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 3000),
        elevation: 2,
        // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        content: Text(
          msg,
          style: const TextStyle(color: ColorConstant.white),
        )));
  }

  static showProgressDialog(BuildContext context) async {
    _dialog = SimpleFontelicoProgressDialog(
        context: context, barrierDimisable: false);
    _dialog!.show(
        message: "Please wait...",
        textStyle: const TextStyle(fontSize: 18),
        horizontal: true,
        type: SimpleFontelicoProgressDialogType.normal,
        width: 200.0,
        height: 75.0,
        loadingIndicator: const Text(
          'C',
          style: TextStyle(fontSize: 24.0),
        ));
  }

  static Future<List<XFile?>?> pickedImageFromGallery() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickMultiImage();
    if (imageFile.isNotEmpty) {
      return imageFile;
    } else {
      return null;
    }
  }
}
