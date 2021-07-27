import 'package:expediente_clinico/models/Enterprise.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/screens/employee/list.dart';
import 'package:expediente_clinico/services/enterprise.dart';
import 'package:expediente_clinico/services/staff.dart';
import 'package:expediente_clinico/widgets/dropdown.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewEmployeesScreen extends StatefulWidget {
  @override
  _ViewEmployeesScreenState createState() => _ViewEmployeesScreenState();
}

class _ViewEmployeesScreenState extends State<ViewEmployeesScreen> {
  EnterpriseService service = EnterpriseService();
  StaffService staffService = StaffService();
  bool isLoadingEnterprises = true;
  AppProvider provider;
  List<Enterprise> enterprises = [];
  Enterprise selectedEnterprise;
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
            children: HeaderWithBackAndNext(
              headerTitle: 'Empleados',
              nextRoute: '/employees/add',
              customIcon: Icons.add,
            ),
          ),
          !isLoadingEnterprises
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: CustomDropDown(
                    hintText: 'Seleccione una empresa',
                    actualValue: selectedEnterprise,
                    children: enterprises
                        .map((enterprise) => DropdownMenuItem(
                              value: enterprise,
                              child: Text(enterprise.name),
                            ))
                        .toList(),
                    onChange: (e) {
                      print(e);
                      setState(() {
                        selectedEnterprise = e;
                      });
                      print(selectedEnterprise.id);
                    },
                  ),
                )
              : Container(),
          Expanded(
              child: isLoadingEnterprises
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : selectedEnterprise == null
                      ? Text('No has seleccionado una empresa')
                      : ListOfStaff(
                          enterpriseId: selectedEnterprise.id,
                          staffService: staffService))
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
}
