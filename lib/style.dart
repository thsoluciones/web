import 'package:flutter/material.dart';

class AppStyle {

  static EdgeInsets get paddingApp => EdgeInsets.symmetric(
    horizontal: 25,
    vertical: 30
  );

  static TextStyle get labelInputStyle => TextStyle(
    fontSize: 15,
    color: Colors.grey[500],
    fontWeight: FontWeight.w600
  );

  static TextStyle get titleHeader => TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.white
  );

  static TextStyle get subtitleNameHeader => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Colors.white
  );

}