import 'package:expediente_clinico/preferences/app.dart';
import 'package:expediente_clinico/screens/auth/login.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  AppPreferences preferences = AppPreferences();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Header(
          children: HeaderOnlyBack(
            headerTitle: 'Opciones',
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Cerrar Sesión'),
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/', (Route<dynamic> route) => false);
                    preferences.logged = false;
                  })
            ],
          ),
        ),
      ],
    ));
  }
}
