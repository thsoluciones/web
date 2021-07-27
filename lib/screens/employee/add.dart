import 'dart:convert';

import 'package:expediente_clinico/models/Clinic.dart';
import 'package:expediente_clinico/models/Enterprise.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/services/enterprise.dart';
import 'package:expediente_clinico/services/staff.dart';
import 'package:expediente_clinico/utils/navigation.dart';
import 'package:expediente_clinico/widgets/alerts/alertTemplate.dart';
import 'package:expediente_clinico/widgets/button.dart';
import 'package:expediente_clinico/widgets/dropdown.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEmployeeScreen extends StatefulWidget {
  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  EnterpriseService service = EnterpriseService();
  StaffService staffService = StaffService();
  AppProvider provider;

  bool isLoadingEnterprises = true;
  List<Enterprise> enterprises = [];

  bool hasPermissionToViewAll = false;

  String name = "";
  String lastname = "";
  String email = "";
  String password = "";
  String dui = "";
  String location = "";
  String selectedRole;
  Enterprise selectedEnterprise;
  Clinic selectedClinic;

  bool isLoading = false;

  List<String> roles = ['Doctor', 'Asistente', 'Secretaria'];

  @override
  void initState() {
    super.initState();
    getEnterprises();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          Header(
            children: HeaderOnlyBack(
              headerTitle: 'Añadir empleado',
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 20),
              children: [
                CustomTextField(
                  hint: 'Nombre del empleado',
                  onChange: (text) {
                    setState(() {
                      name = text;
                    });
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hint: 'Apellido del empleado',
                  onChange: (text) {
                    setState(() {
                      lastname = text;
                    });
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hint: 'Email del empleado',
                  onChange: (text) {
                    setState(() {
                      email = text;
                    });
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hint: 'Contraseña empleado',
                  needHideText: true,
                  onChange: (text) {
                    setState(() {
                      password = text;
                    });
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hint: 'Dui del empleado',
                  onChange: (text) {
                    setState(() {
                      dui = text;
                    });
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hint: 'Dirección de vivienda',
                  onChange: (text) {
                    setState(() {
                      location = text;
                    });
                  },
                ),
                SizedBox(height: 20),
                CustomDropDown(
                  hintText: 'Seleccione un rol',
                  actualValue: selectedRole,
                  children: roles
                      .map((String role) =>
                          DropdownMenuItem(value: role, child: Text(role)))
                      .toList(),
                  onChange: (value) {
                    setState(() {
                      selectedRole = value;
                    });
                  },
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
                                        child: Text(clinic.name ??
                                            "Sin nombre de clinica")))
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
                    titleButton: 'Añadir',
                    onPressed: isLoading ? null : () => addEmployee())
              ],
            ),
          )
        ],
      ),
    );
  }

  void getEnterprises() async {
    provider = Provider.of<AppProvider>(context, listen: false);
    var res = await service.getMyEnterprises(
        provider.role != 'Dueño' ? provider.enterpriseOwnerId : provider.id);
    setState(() {
      enterprises = res;
      isLoadingEnterprises = false;
    });
  }

  void addEmployee() async {
    setState(() {
      isLoading = true;
    });
    if (name.isEmpty ||
        lastname.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        dui.isEmpty ||
        location.isEmpty ||
        selectedRole == null ||
        selectedRole.isEmpty ||
        selectedClinic == null ||
        selectedEnterprise == null) {
      setState(() {
        isLoading = false;
      });
      return requestFields(
          context,
          Text('Error de ingreso'),
          Text(
              'Rellene todo el formulario y seleccione cada opción que se solicita'));
    } else {
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
      });

      var res = await staffService.addStaff(data);

      if (res['success']) {
        NavigatorUtil.navigateToAndClear(context, '/admin');
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
}
