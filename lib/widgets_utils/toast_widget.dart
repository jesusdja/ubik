import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showAlert({required String text,required bool isError,int sec = 3,}){

  Color color = isError ? Colors.redAccent : Colors.green;

  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: sec,
    backgroundColor: color,
    textColor: Colors.white,
    fontSize: 16.0
  );
}