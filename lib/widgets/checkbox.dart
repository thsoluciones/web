import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  final bool selected;
  final void Function() onChange;
  CustomCheckBox({this.selected = false, this.onChange});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChange,
      child: Container(
        height: 17,
        width: 17,
        decoration: BoxDecoration(
            color: selected ? Colors.blue[800] : Colors.white,
            border: Border.all(color: Colors.blue[700]),
            borderRadius: BorderRadius.circular(5)),
        child: selected
            ? Icon(
                Icons.check,
                size: 15,
                color: Colors.white,
              )
            : Container(),
      ),
    );
  }
}
