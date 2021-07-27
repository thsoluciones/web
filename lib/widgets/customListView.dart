import 'package:flutter/material.dart';

class CustomListView extends StatelessWidget {
  final dynamic itemBuilder;
  final List<dynamic> items;
  final Axis direction;
  CustomListView(
      {this.itemBuilder, this.items, this.direction = Axis.vertical});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemBuilder: itemBuilder,
        itemCount: items.length,
        scrollDirection: direction);
  }
}
