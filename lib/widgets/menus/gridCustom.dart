import 'package:flutter/material.dart';

class CustomGridList extends StatelessWidget {
  final BuildContext context;
  final double itemWidth;
  final double itemHeight;
  final List<Widget> builderChildren;

  CustomGridList(
      {this.context, this.itemHeight, this.itemWidth, this.builderChildren});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      crossAxisCount: 2,
      childAspectRatio: (itemWidth / itemHeight),
      controller: ScrollController(keepScrollOffset: false),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: builderChildren,
    );
  }
}
