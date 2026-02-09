import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showSuccessToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      fontAsset: 'assets/fonts/DGAgnadeen-Regular.ttf',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 14.0);
}

void showfailureToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      fontAsset: 'assets/fonts/DGAgnadeen-Regular.ttf',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 14.0);
}
