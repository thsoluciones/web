import 'dart:convert';

import 'package:expediente_clinico/models/Option.dart';
import 'package:expediente_clinico/models/Staff.dart';
import 'package:expediente_clinico/providers/option.dart';
import 'package:expediente_clinico/services/staff.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PermissionsEmployeeScreen extends StatefulWidget {
  @override
  _PermissionsEmployeeScreenState createState() =>
      _PermissionsEmployeeScreenState();
}

class _PermissionsEmployeeScreenState extends State<PermissionsEmployeeScreen> {
  ProviderOption providerOption;
  List<Map<String, dynamic>> selectedOptions = [];
  StaffService staffService = StaffService();
  Staff staff;

  @override
  Widget build(BuildContext context) {
    staff = ModalRoute.of(context)?.settings.arguments as Staff;
    return Scaffold(
        body: Column(
      children: [
        Header(
          children: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('Permisos (${staff.options.length})',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  IconButton(
                      onPressed: () {
                        staff.options.clear();
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ))
                ],
              ),
              IconButton(
                  onPressed: () async {
                    var res = await staffService.updatePermissions(
                        staff.options, staff.id);
                    if (res['status']) {
                      Navigator.popAndPushNamed(context, '/admin');
                    } else {}
                  },
                  icon: Icon(
                    Icons.save,
                    color: Colors.white,
                  ))
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: Option.generalOptions.length,
            itemBuilder: (BuildContext context, int index) {
              Option option = Option.generalOptions[index];
              return ListTile(
                  onTap: () {
                    print(option.toJson());
                    if (!staff.options
                        .any((element) => element.id == option.id)) {
                      staff.options.add(option);
                    }

                    setState(() {});
                  },
                  title: Text(Option.generalOptions[index].option),
                  trailing:
                      staff.options.any((element) => element.id == option.id)
                          ? IconButton(
                              onPressed: () {
                                staff.options.removeWhere(
                                    (element) => element.id == option.id);
                                //selectedOptions.remove(option);
                                setState(() {});
                              },
                              icon: Icon(Icons.close))
                          : Icon(Icons.check));
            },
          ),
        )
      ],
    ));
  }
}
