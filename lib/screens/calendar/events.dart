import 'package:expediente_clinico/widgets/header.dart';
import 'package:flutter/material.dart';

class ViewDates extends StatefulWidget {
  @override
  _ViewDatesState createState() => _ViewDatesState();
}

class _ViewDatesState extends State<ViewDates> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(
                children: HeaderOnlyBack(
              headerTitle: 'Citas de este dia.',
            ))
          ],
        ),
      ),
    );
  }
}
