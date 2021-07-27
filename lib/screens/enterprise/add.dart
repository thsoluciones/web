import 'dart:convert';

import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/services/enterprise.dart';
import 'package:expediente_clinico/utils/navigation.dart';
import 'package:expediente_clinico/widgets/button.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEnterprise extends StatefulWidget {
  @override
  _AddEnterpriseState createState() => _AddEnterpriseState();
}

class _AddEnterpriseState extends State<AddEnterprise> {
  AppProvider provider;
  EnterpriseService service = EnterpriseService();

  String name = "";
  String socialReason = "";
  String direction = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(
            children: HeaderOnlyBack(
              headerTitle: 'Agregar Empresa',
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  hint: 'Nombre',
                  onChange: (text) {
                    setState(() {
                      name = text;
                    });
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hint: 'Razon social',
                  onChange: (text) {
                    setState(() {
                      socialReason = text;
                    });
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hint: 'Dirección',
                  onChange: (text) {
                    setState(() {
                      direction = text;
                    });
                  },
                ),
                SizedBox(height: 20),
                CustomButton(
                  onPressed: isLoading ? null : () => addEnterprise(),
                  titleButton: 'Añadir',
                )
              ],
            ),
          )
        ],
      )),
    );
  }

  void addEnterprise() async {
    setState(() {
      isLoading = true;
    });
    if (name.isEmpty || socialReason.isEmpty || direction.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text('Error'),
                content: Text('Rellene los datos porfavor'));
          });
    }
    var data = jsonEncode({
      'name': name,
      'socialReason': socialReason,
      'direction': direction,
      'doctor':
          provider.role != 'Dueño' ? provider.enterpriseOwnerId : provider.id
    });

    var res = await service.addEnterprise(data);

    if (res['success']) {
      provider.role != 'Dueño'
          ? NavigatorUtil.navigateToAndClear(
              context,
              provider
                  .homeRoute) //Navigator.popAndPushNamed(context, provider.homeRoute)
          : NavigatorUtil.navigateToAndClear(context,
              '/admin'); //Navigator.popAndPushNamed(context, '/admin');
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('No se puede agregar la empresa'),
            );
          });
    }
  }
}
