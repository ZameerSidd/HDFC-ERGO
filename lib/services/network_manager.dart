import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hdfc/utils/utils.dart';

class NetworkManager {
  static Future<dynamic> signUp(password, email, name) async {
    if (await checkInternetConnection()) {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await credential.user!.updateDisplayName(name);
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          log('The password provided is too weak.');
          return "The password provided is too weak.";
        } else if (e.code == 'invalid-email') {
          log('Invalid email');
          return 'Your email address appears to be malformed.';
        } else if (e.code == 'email-already-in-use') {
          log('The account already exists for that email.');
          return "The account already exists for that email.";
        }
      } catch (e) {
        log("$e *****************************");
        return null;
      }
    } else {
      return "Check your internet connection";
    }
  }

  // API to post data
  Future<dynamic> apiToPostData(BuildContext context, String url,
      Map<String, dynamic> queryParameters) async {
    String? token = await Utils.getStringFromSF('email');
    if (token != null) {
      var network = await checkInternetConnection();
      if (network) {
        var requestURI = Uri.parse(url);
        debugPrint("${(requestURI)}");

        Utils.hideProgressDialog();
        Utils.showProgressDialog(context);
        // try {
        //   response = await http
        //       .post(
        //     requestURI,
        //     headers: await getHeadersForPostApiCall(),
        //   )
        //       .timeout(const Duration(minutes: 1), onTimeout: () async {
        //     await Utils.hideProgressDialog();
        //     Utils().showAlert(context,
        //         'Timeout, Server is not reachable at this time. Please try again');
        //     return response;
        //   });

        //   if (response.statusCode > 400) {
        //     await Utils.hideProgressDialog();
        //   }
        //   Utils.hideProgressDialog();
        //   return response; // added to check
        // } catch (error) {
        //   var errorMessage = error.toString();
        //   checkInternet(context, errorMessage);
        // }
      }
    }
  }

  static Future<dynamic> signIn(password, email) async {
    if (await checkInternetConnection()) {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          log('No user found for that email.');
          return 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          log('Wrong password provided for that user.');
          return 'Your email or password is wrong.';
        } else if (e.code == 'invalid-email') {
          log('Invalid email');
          return 'Your email address appears to be malformed.';
        } else {
          log("${e.code} ********************");
          return null;
        }
      }
    } else {
      return "Check your internet connection";
    }
  }

  static Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}
