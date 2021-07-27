import 'package:expediente_clinico/models/Enterprise.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/screens/enterprise/staff/list.service.dart';
import 'package:expediente_clinico/services/services.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewServicesScreen extends StatefulWidget {
  @override
  _ViewServicesScreenState createState() => _ViewServicesScreenState();
}

class _ViewServicesScreenState extends State<ViewServicesScreen> {
  ServicesService servicesService = ServicesService();
  Enterprise enterprise;
  @override
  Widget build(BuildContext context) {
    var appProvider = Provider.of<AppProvider>(context, listen: false);
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(
              children: appProvider.role == 'Dueño' &&
                      appProvider.enterprise?.id == null
                  ? HeaderOnlyBack(
                      headerTitle: 'Servicios',
                    )
                  : HeaderWithBackAndNext(
                      headerTitle: 'Servicios',
                      nextRoute: '/services/add',
                      customIcon: Icons.add,
                    ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //   child: FutureBuilder(
            //       future: EnterpriseService().getMyEnterprises(appProvider.id),
            //       builder: (BuildContext context,
            //           AsyncSnapshot<List<Enterprise>> snapshot) {
            //         print(snapshot.data);
            //         if (snapshot.hasData) {
            //           return CustomDropDown(
            //             onChange: (value) {
            //               setState(() {
            //                 enterprise = value;
            //               });
            //             },
            //             hintText: enterprise == null
            //                 ? 'seleccione una empresa'
            //                 : enterprise.name,
            //             children: snapshot.data
            //                 .map((Enterprise e) =>
            //                     DropdownMenuItem(value: e, child: Text(e.name)))
            //                 .toList(),
            //           );
            //         } else {
            //           return Align(
            //             alignment: Alignment.center,
            //             child: CircularProgressIndicator(),
            //           );
            //         }
            //       }),
            // ),
            Expanded(
              child:
                  appProvider.role == 'Dueño' && appProvider.enterprise == null
                      ? Center(
                          child: Text(
                              'Selecciona una empresa para ver tus servicios.',
                              textAlign: TextAlign.center),
                        )
                      : ListOfServices(
                          role: appProvider.role,
                          enterpriseId: appProvider.enterpriseIdFrom,
                          servicesService: servicesService,
                          enterprise: appProvider.enterprise,
                        ),
            )
          ],
        ),
      ),
    );
  }
}
