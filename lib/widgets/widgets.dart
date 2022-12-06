import 'package:flutter/material.dart';

import '../shared/constants.dart';

InputDecoration inputDecoration = InputDecoration(
  labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Constant.primaryColor), gapPadding: 2),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Constant.primaryColor), gapPadding: 2),
  errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Constant.primaryColor), gapPadding: 2),
);

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void showSnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 14),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {},
        textColor: Colors.white,
      ),
    ),
  );
}
