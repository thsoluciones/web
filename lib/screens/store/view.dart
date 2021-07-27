import 'package:expediente_clinico/widgets/header.dart';
import 'package:flutter/material.dart';

class ViewStores extends StatefulWidget {
  @override
  _ViewStoresState createState() => _ViewStoresState();
}

class _ViewStoresState extends State<ViewStores> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Header(
          children: HeaderWithBackAndNext(
            customIcon: null,
            headerTitle: 'Añadir empleado',
            nextRoute: '/employee/add',
          ),
        ),
      ],
    ));
  }
}
