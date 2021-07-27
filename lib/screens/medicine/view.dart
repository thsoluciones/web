import 'package:expediente_clinico/models/Enterprise.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/screens/medicine/list.dart';
import 'package:expediente_clinico/services/enterprise.dart';
import 'package:expediente_clinico/services/medicine.dart';
import 'package:expediente_clinico/widgets/dropdown.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewMedicineScreen extends StatefulWidget {
  @override
  _ViewMedicineScreenState createState() => _ViewMedicineScreenState();
}

class _ViewMedicineScreenState extends State<ViewMedicineScreen> {
  MedicineService medicineService = MedicineService();
  AppProvider provider;
  Enterprise enterprise;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(
              children: provider.role == 'Dueño' && provider.enterprise == null
                  ? HeaderOnlyBack(
                      headerTitle: 'Medicinas',
                    )
                  : HeaderWithBackAndNext(
                      headerTitle: 'Medicinas',
                      nextRoute: '/medicine/add',
                      customIcon: Icons.add,
                    ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //   child: FutureBuilder(
            //       future: EnterpriseService().getMyEnterprises(provider.id),
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
              child: provider.role == 'Dueño' && provider.enterprise == null
                  ? Center(
                      child: Text(
                          'Selecciona una empresa para ver tus medicinas.',
                          textAlign: TextAlign.center),
                    )
                  : ListOfMedicine(
                      role: provider.role,
                      enterpriseId: provider.enterpriseIdFrom,
                      medicineService: medicineService,
                      idClinic: provider.enterprise?.id,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
