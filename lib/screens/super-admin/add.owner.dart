import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/services/auth.dart';
import 'package:expediente_clinico/widgets/button.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddOwnerScreen extends StatefulWidget {
  @override
  _AddOwnerScreenState createState() => _AddOwnerScreenState();
}

class _AddOwnerScreenState extends State<AddOwnerScreen> {
  String name;
  String lastname;
  String email;
  String password;

  AuthService authService = AuthService();
  AppProvider appProvider;

  @override
  Widget build(BuildContext context) {
    appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(
              children: HeaderOnlyBack(
                headerTitle: 'Agregar dueño',
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                children: [
                  CustomTextField(
                    onTap: () {},
                    iconOnLeft: null,
                    iconOnRight: null,
                    value: null,
                    controller: null,
                    helperText: "",
                    keyboardType: TextInputType.text,
                    maxLenght: 100,
                    hint: 'Nombre',
                    onChange: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    onTap: () {},
                    iconOnLeft: null,
                    iconOnRight: null,
                    value: null,
                    controller: null,
                    helperText: "",
                    keyboardType: TextInputType.text,
                    maxLenght: 100,
                    hint: 'Apellido',
                    onChange: (value) {
                      setState(() {
                        lastname = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    onTap: () {},
                    iconOnLeft: null,
                    iconOnRight: null,
                    value: null,
                    controller: null,
                    helperText: "",
                    keyboardType: TextInputType.text,
                    maxLenght: 100,
                    hint: 'Email',
                    onChange: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    onTap: () {},
                    iconOnLeft: null,
                    iconOnRight: null,
                    value: null,
                    controller: null,
                    helperText: "",
                    keyboardType: TextInputType.text,
                    maxLenght: 100,
                    hint: 'Contraseña',
                    needHideText: true,
                    onChange: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  CustomButton(
                    onPressed: () => addOwner(),
                    titleButton: 'Agregar',
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void addOwner() async {
    if (name == null || lastname == null || email == null || password == null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Rellene la información'),
            );
          });
    } else {
      var data = {
        "name": name,
        "lastname": lastname,
        "email": email,
        "password": password,
        "role": 'Dueño'
      };
      var res = await authService.addOwner(data);

      if (res['success']) {
        Navigator.pushReplacementNamed(context, appProvider.homeRoute);
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Error al agregar el dueño'),
              );
            });
      }
    }
  }
}
