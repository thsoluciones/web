import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final Widget children;
  Header({this.children});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 70, bottom: 30, left: 30, right: 30),
        width: double.infinity,
        color: Color(0xff2667ff),
        child: children);
  }
}

//variants
class HeaderOnlyBack extends StatelessWidget {
  final String headerTitle;

  HeaderOnlyBack({this.headerTitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
        Expanded(
          child: Text(headerTitle,
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        )
      ],
    );
  }
}

class HeaderWithBackAndNext extends StatelessWidget {
  final String headerTitle;

  final String nextRoute;
  final IconData customIcon;

  HeaderWithBackAndNext({this.headerTitle, this.nextRoute, this.customIcon});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context)),
            Text(headerTitle,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, nextRoute),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.blue[900],
            ),
            child: Icon(customIcon, color: Colors.white),
          ),
        )
      ],
    );
  }
}
