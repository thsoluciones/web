import 'package:expediente_clinico/models/Option.dart';
import 'package:flutter/material.dart';

class ItemGridList extends StatelessWidget {
  final Option option;

  ItemGridList({this.option});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, option.route),
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color(0xff2667ff),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[400])),
          margin: EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.blue[900]?.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(10),
                child: Icon(option.icon, color: Colors.white, size: 30),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  option.option,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
              )
            ],
          )),
    );
  }
}
