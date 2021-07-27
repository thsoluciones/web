import 'dart:convert';

import 'package:expediente_clinico/models/Service.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/services/services.dart';
import 'package:expediente_clinico/widgets/button.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditServiceScreen extends StatefulWidget {
  @override
  _EditServiceScreenState createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  ServicesService servicesService = ServicesService();
  AppProvider provider;
  Service serviceModel;
  String service;
  String treatment;
  String price;
  @override
  Widget build(BuildContext context) {
    serviceModel = ModalRoute.of(context)?.settings.arguments as Service;
    provider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          Header(
            children: HeaderOnlyBack(
              headerTitle: 'Editar Servicio',
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              children: [
                SizedBox(height: 20),
                CustomTextField(
                  iconOnLeft: null,
                  iconOnRight: null,
                  helperText: "",
                  maxLenght: 100,
                  controller: null,
                  value: serviceModel.typeOfService,
                  hint: 'Servicio',
                  keyboardType: TextInputType.text,
                  onChange: (value) {
                    setState(() {
                      serviceModel.typeOfService = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  value: null,
                  iconOnLeft: null,
                  iconOnRight: null,
                  helperText: "",
                  maxLenght: 100,
                  controller: null,
                  hint: 'Tratamiento',
                  keyboardType: TextInputType.text,
                  onChange: (value) {
                    setState(() {
                      serviceModel.typeOfTreatment = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  iconOnLeft: null,
                  iconOnRight: null,
                  helperText: "",
                  maxLenght: 100,
                  controller: null,
                  value: serviceModel.price,
                  hint: 'Precio',
                  keyboardType: TextInputType.number,
                  onChange: (value) {
                    setState(() {
                      serviceModel.price = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                CustomButton(
                    titleButton: 'Editar', onPressed: () => editService()),
              ],
            ),
          )
        ],
      ),
    );
  }

  void editService() async {
    var data = jsonEncode({
      "typeofservice": serviceModel.typeOfService,
      "typeoftreatment": serviceModel.typeOfTreatment,
      "price": serviceModel.price,
      "clinic": provider.clinic.id
    });
    var res = await servicesService.editService(data, serviceModel.id);

    if (res['success']) {
      Navigator.popAndPushNamed(context, provider.homeRoute);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('No se pudo añadir el servicio.'),
            );
          });
    }
  }
}
