import 'package:flutter/material.dart';

void requestFields(BuildContext context, Widget title, Widget body) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(title: title, content: body);
      });
}
