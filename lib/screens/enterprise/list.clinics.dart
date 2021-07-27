import 'package:expediente_clinico/models/Clinic.dart';
import 'package:expediente_clinico/models/Enterprise.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/services/enterprise.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListOfClinics extends StatefulWidget {
  final EnterpriseService enterpriseService;
  final Enterprise enteprise;
  ListOfClinics({this.enterpriseService, this.enteprise});
  @override
  _ListOfClinicsState createState() => _ListOfClinicsState();
}

class _ListOfClinicsState extends State<ListOfClinics> {
  AppProvider appProvider;
  @override
  Widget build(BuildContext context) {
    appProvider = Provider.of<AppProvider>(context);
    return FutureBuilder(
        future: widget.enterpriseService
            .getClinicsByEnterprise(widget.enteprise.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: (snapshot.data).length,
              itemBuilder: (BuildContext context, int index) {
                Clinic clinic = snapshot.data[index];
                return ListTile(
                    onTap: () => appProvider.clinic = clinic,
                    title: Text(clinic.name ?? "Sin nombre de clinica"),
                    trailing: appProvider.clinic?.id == clinic.id
                        ? Icon(Icons.check)
                        : null);
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  void actionCheck(Clinic clinic) {
    if (clinic != null) {
      appProvider.clinic = clinic;
    }
  }

  Widget showCheck(Clinic clinic) {
    if (clinic == null) {
      return Container();
    } else {
      return Icon(Icons.check);
    }
  }
}
