import 'package:data_soft/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(msg, {color = Colors.red, gravity = ToastGravity.BOTTOM}) {
  return Fluttertoast.showToast(
      msg: msg.toString(),
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity,
      timeInSecForIosWeb: 2,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}

showSnackBar(BuildContext context, {required text, Color color = rejectedColor}) {
  try {
    var snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.all(20),
        backgroundColor: color,
        content: Text(text.toString()));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // ignore: empty_catches
  } catch (e) {}
}
