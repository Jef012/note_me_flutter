import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message, backgroundColor: Colors.yellow, textColor: Colors.black);
  }

  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          message: message,
          borderRadius: BorderRadius.circular(25),
          backgroundColor: Colors.black45,
          titleColor: Colors.yellow,
          duration: const Duration(seconds: 2),
          animationDuration: const Duration(seconds: 1),
          margin: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
        )..show(context));
  }

  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextfocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextfocus);
  }
}
