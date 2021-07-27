import 'package:expediente_clinico/widgets/header.dart';
import 'package:flutter/material.dart';

class AddStoreScreen extends StatefulWidget {
  @override
  _AddStoreScreenState createState() => _AddStoreScreenState();
}

class _AddStoreScreenState extends State<AddStoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Header(
          children: HeaderOnlyBack(
            headerTitle: 'Añadir ',
          ),
        ),
      ],
    ));
  }
}
