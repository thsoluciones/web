import 'dart:convert';

import 'package:expediente_clinico/models/Clinic.dart';
import 'package:expediente_clinico/models/Enterprise.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/services/enterprise.dart';
import 'package:expediente_clinico/services/staff.dart';
import 'package:expediente_clinico/widgets/button.dart';
import 'package:expediente_clinico/widgets/dropdown.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditStaffScreen extends StatefulWidget {
  @override
  _EditStaffScreenState createState() => _EditStaffScreenState();
}

class _EditStaffScreenState extends State<EditStaffScreen> {
  EnterpriseService service = EnterpriseService();
  StaffService staffService = StaffService();
  AppProvider provider;

  bool isLoadingEnterprises = true;
  List<Enterprise> enterprises = [];

  bool hasPermissionToViewAll = false;

  String name;
  String lastname;
  String email;
  String password;
  String dui;
  String location;
  String selectedRole;
  Enterprise selectedEnterprise;
  Clinic selectedClinic;

  List<String> roles = ['Doctor', 'Asistente', 'Secretaria'];

  @override
  void initState() {
    super.initState();
    getEnterprises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(
            children: HeaderOnlyBack(
              headerTitle: 'Editar Staff',
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              children: [
                CustomTextField(
                  keyboardType: TextInputType.text,
                  value: null,
                  iconOnLeft: null,
                  iconOnRight: null,
                  helperText: "",
                  maxLenght: 100,
                  controller: null,
                  hint: 'Nombre',
                  onChange: (event) {},
                ),
                SizedBox(height: 20),
                CustomTextField(
                  keyboardType: TextInputType.text,
                  value: null,
                  iconOnLeft: null,
                  iconOnRight: null,
                  helperText: "",
                  maxLenght: 100,
                  controller: null,
                  hint: 'Apellido',
                  onChange: (event) {},
                ),
                SizedBox(height: 20),
                CustomTextField(
                  keyboardType: TextInputType.text,
                  value: null,
                  iconOnLeft: null,
                  iconOnRight: null,
                  helperText: "",
                  maxLenght: 100,
                  controller: null,
                  hint: 'Correo',
                  onChange: (event) {},
                ),
                SizedBox(height: 20),
                CustomTextField(
                  onChange: (value) {
                    setState(() {});
                  },
                  keyboardType: TextInputType.text,
                  value: null,
                  iconOnLeft: null,
                  iconOnRight: null,
                  helperText: "",
                  maxLenght: 100,
                  controller: null,
                  hint: 'Dirección',
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                        value: hasPermissionToViewAll,
                        onChanged: (dynamic value) {
                          setState(() {
                            hasPermissionToViewAll = value;
                          });
                        }),
                    Text('Tiene permiso como administrador.'),
                  ],
                ),
                SizedBox(height: 20),
                Text('Empresas.'),
                SizedBox(height: 20),
                !hasPermissionToViewAll
                    ? isLoadingEnterprises
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [CircularProgressIndicator()],
                          )
                        : CustomDropDown(
                            hintText: 'Seleccione una empresa',
                            actualValue: selectedEnterprise,
                            children: enterprises
                                .map((Enterprise enterprise) =>
                                    DropdownMenuItem(
                                        value: enterprise,
                                        child: Text(enterprise.name)))
                                .toList(),
                            onChange: (value) {
                              setState(() {
                                print(value.clinics);
                                selectedEnterprise = value;
                              });
                            },
                          )
                    : Container(),
                SizedBox(height: 20),
                Text('Sucursales clinicas.'),
                SizedBox(height: 20),
                !hasPermissionToViewAll
                    ? selectedEnterprise == null
                        ? Container()
                        : selectedEnterprise.clinics.length == 0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text('No hay clinicas añadidas')],
                              )
                            : CustomDropDown(
                                hintText: 'Seleccione una clinica',
                                actualValue: selectedClinic,
                                children: selectedEnterprise.clinics
                                    .map((Clinic clinic) => DropdownMenuItem(
                                        value: clinic,
                                        child: Text(clinic.name)))
                                    .toList(),
                                onChange: (value) {
                                  setState(() {
                                    selectedClinic = value;
                                  });
                                },
                              )
                    : Container(),
                SizedBox(height: 20),
                CustomButton(
                    titleButton: 'Añadir', onPressed: () => addEmployee())
              ],
            ),
          )
        ],
      ),
    );
  }

  void getEnterprises() async {
    provider = Provider.of<AppProvider>(context, listen: false);
    var res = await service.getMyEnterprises(provider.id);
    setState(() {
      enterprises = res;
      isLoadingEnterprises = false;
    });
  }

  void addEmployee() async {
    var data = jsonEncode({
      "name": name,
      "lastname": lastname,
      "email": email,
      "password": password,
      "dui": dui,
      "direction": location,
      "role": selectedRole,
      "clinic": selectedClinic.id,
      "enterprise": selectedEnterprise.id,
      "hasPermissionViewClinics": hasPermissionToViewAll
    });

    var res = await staffService.addStaff(data);

    if (res['success']) {
      Navigator.popAndPushNamed(context, '/admin');
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('No se puede agregar el staff'),
            );
          });
    }
  }
}
