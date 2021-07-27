import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  final Function onChange;
  final dynamic actualValue;
  final String hintText;
  final List<DropdownMenuItem> children;

  CustomDropDown(
      {this.onChange, this.actualValue, this.hintText, this.children});

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        underline: DropdownButtonHideUnderline(child: Container()),
        isExpanded: true,
        value: actualValue,
        hint: Text(hintText),
        items: children,
        onChanged: onChange);
  }
}
