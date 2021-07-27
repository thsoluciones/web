import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final Function onChange;
  final String hint;
  final bool isReadOnly;
  final dynamic value;
  final TextEditingController controller;
  final VoidCallback onTap;
  final IconData iconOnLeft;
  final IconData iconOnRight;
  final bool needHideText;
  final String helperText;
  final TextInputType keyboardType;
  final int maxLenght;
  final int rows;

  CustomTextField(
      {this.onChange,
      this.hint,
      this.isReadOnly = false,
      this.value,
      this.controller,
      this.rows = 1,
      this.onTap,
      this.iconOnLeft,
      this.iconOnRight,
      this.needHideText = false,
      this.helperText,
      this.keyboardType,
      this.maxLenght});

  /*
    Custom style for text field (globally) and passing 
    String as parameter for hint Text/placeholder in textfield
  */
  InputDecoration style({String hint, String helperText}) => InputDecoration(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
      ),
      hintText: hint,
      helperText: helperText,
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      prefixIcon: iconOnRight == null ? null : Icon(iconOnRight));

  @override
  Widget build(BuildContext context) {
    return value == null
        ? TextField(
            keyboardType: keyboardType,
            obscureText: needHideText,
            onTap: onTap,
            maxLength: maxLenght,
            readOnly: isReadOnly,
            maxLines: rows,
            controller: controller,
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            enableSuggestions: false,
            onChanged: onChange,
            decoration: style(hint: hint, helperText: helperText),
          )
        : TextFormField(
            autocorrect: false,
            obscureText: needHideText,
            textCapitalization: TextCapitalization.none,
            enableSuggestions: false,
            onChanged: onChange,
            decoration: style(hint: hint),
            initialValue: value,
          );
  }
}
