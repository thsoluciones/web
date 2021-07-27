import 'package:flutter/material.dart';

class ShowBlockOfWidgets extends StatelessWidget {
  final bool show;
  final List<Widget> children;
  ShowBlockOfWidgets({this.show, this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: show ? Column(children: children) : Container(),
    );
  }
}
