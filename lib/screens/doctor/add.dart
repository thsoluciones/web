import 'package:expediente_clinico/style.dart';
import 'package:expediente_clinico/widgets/button.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/textfield.dart';
import 'package:flutter/material.dart';

class AddDoctorScreen extends StatefulWidget {
  @override
  _AddDoctorScreenState createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  String name = "";
  String cellphone = "";
  String direction = "";
  String biography = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(
                children: HeaderOnlyBack(
              headerTitle: 'Agregar Doctor',
            )),
          ],
        ),
      ),
    );
  }

  Widget nameField() => CustomTextField(
      onTap: () {},
      iconOnLeft: null,
      iconOnRight: null,
      value: null,
      controller: null,
      helperText: "",
      keyboardType: TextInputType.text,
      maxLenght: 100,
      onChange: (value) {
        setState(() {
          name = value;
        });
      },
      hint: 'Nombre');

  Widget telephoneField() => CustomTextField(
        onTap: () {},
        iconOnLeft: null,
        iconOnRight: null,
        value: null,
        controller: null,
        helperText: "",
        keyboardType: TextInputType.text,
        maxLenght: 100,
        onChange: (value) => setState(() => cellphone = value),
        hint: 'Telefono',
      );

  Widget directionField() => CustomTextField(
        onTap: () {},
        iconOnLeft: null,
        iconOnRight: null,
        value: null,
        controller: null,
        helperText: "",
        keyboardType: TextInputType.text,
        maxLenght: 100,
        onChange: (value) => setState(() => cellphone = value),
        hint: 'Dirección de vivienda',
      );

  Widget biographyField() => CustomTextField(
        onTap: () {},
        iconOnLeft: null,
        iconOnRight: null,
        value: null,
        controller: null,
        helperText: "",
        keyboardType: TextInputType.text,
        maxLenght: 100,
        onChange: (value) => setState(() => cellphone = value),
        hint: 'Biografia',
      );

  Widget especialityField() => CustomTextField(
        onTap: () {},
        iconOnLeft: null,
        iconOnRight: null,
        value: null,
        controller: null,
        helperText: "",
        keyboardType: TextInputType.text,
        maxLenght: 100,
        onChange: (value) => setState(() => {}),
        hint: 'Especialidad',
      );
}
