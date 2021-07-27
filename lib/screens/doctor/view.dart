import 'package:expediente_clinico/widgets/header.dart';
import 'package:flutter/material.dart';

class DoctorsScreen extends StatefulWidget {
  @override
  _DoctorsScreenState createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(
                children: HeaderWithBackAndNext(
              customIcon: null,
              headerTitle: 'Doctores',
              nextRoute: '/doctors/add',
            ))
          ],
        ),
      ),
    );
  }
}
