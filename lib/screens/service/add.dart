import 'dart:convert';

import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/services/services.dart';
import 'package:expediente_clinico/widgets/button.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddServiceScreen extends StatefulWidget {
  @override
  _AddServiceScreenState createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  ServicesService servicesService = ServicesService();
  AppProvider provider;

  String service;
  String treatment;
  String price;
  String code;

  bool isLoadingRequest = false;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: Container(
          child: Column(
        children: [
          Header(
            children: HeaderOnlyBack(
              headerTitle: 'Añadir Servicio',
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              children: [
                SizedBox(height: 20),
                CustomTextField(
                  hint: 'Codigo de servicio',
                  helperText: 'ej: 001',
                  keyboardType: TextInputType.number,
                  onChange: (value) {
                    setState(() {
                      code = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hint: 'Servicio',
                  keyboardType: TextInputType.text,
                  onChange: (value) {
                    setState(() {
                      service = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hint: 'Tratamiento',
                  keyboardType: TextInputType.text,
                  onChange: (value) {
                    setState(() {
                      treatment = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hint: 'Precio',
                  keyboardType: TextInputType.number,
                  onChange: (value) {
                    setState(() {
                      price = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                CustomButton(
                    titleButton: 'Agregar',
                    onPressed: isLoadingRequest ? null : () => addService()),
              ],
            ),
          )
        ],
      )),
    );
  }

  void addService() async {
    setState(() {
      isLoadingRequest = true;
    });
    if (service != null &&
        treatment != null &&
        price != null &&
        code != null &&
        double.parse(price) > 0 &&
        int.parse(code) >= 0) {
      var data = jsonEncode({
        "code": code,
        "typeofservice": service,
        "typeoftreatment": treatment,
        "price": price,
        "enterprise": provider.role == 'Dueño'
            ? provider.enterprise.id
            : provider.enterpriseIdFrom
        //"clinic": provider.clinic.id
      });
      var res = await servicesService.addService(data);

      if (res['success']) {
        Navigator.popAndPushNamed(context, provider.homeRoute);
      } else {
        setState(() {
          isLoadingRequest = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('No se pudo añadir el servicio.'),
              );
            });
      }
    } else {
      setState(() {
        isLoadingRequest = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Ingresa los datos y con formatos correctos'),
            );
          });
    }
  }
}
