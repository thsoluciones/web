import 'package:flutter/material.dart';

class NavigatorUtil {
  void navigateToScreen(
      BuildContext context, Function onGoBack, Widget screen) {
    Route route = MaterialPageRoute(builder: (context) => screen);
    Navigator.push(context, route).then((value) => onGoBack());
  }

  static void navigateToAndClear(BuildContext context, String route) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(route, (Route<dynamic> route) => false);
  }
}
