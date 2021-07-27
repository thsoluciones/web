import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String titleButton;

  CustomButton({this.onPressed, this.titleButton});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        color: Color(0xff2667ff),
        textColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Text(titleButton, style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: onPressed);
  }
}
