import 'package:expediente_clinico/models/Expedient.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/providers/patient.dart';
import 'package:expediente_clinico/services/expedient.dart';
import 'package:expediente_clinico/style.dart';
import 'package:expediente_clinico/widgets/customListView.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ViewPatientsScreen extends StatefulWidget {
  @override
  _ViewPatientsScreenState createState() => _ViewPatientsScreenState();
}

class _ViewPatientsScreenState extends State<ViewPatientsScreen> {
  ProviderPatient providerPatient;
  List<Expedient> filteredPatients = [];
  ExpedientService expedientService = ExpedientService();
  bool isLoading = true;
  List<Expedient> patients = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPatients();
  }

  void getPatients() async {
    var appProvider = Provider.of<AppProvider>(context, listen: false);

    if (appProvider.clinic != null) {
      List<Expedient> expedients = await expedientService
          .getPatients(appProvider.clinic.id) as List<Expedient>;
      setState(() {
        isLoading = false;
        filteredPatients = expedients;
        patients = expedients;
      });
    }
  }

  onItemChange(String value) {
    List<Expedient> result = [];
    if (value.isEmpty) {
      setState(() {
        filteredPatients = patients;
      });
      return;
    } else {
      filteredPatients.forEach((element) {
        if (element.name.toLowerCase().contains(value.toLowerCase())) {
          result.add(element);
        }
      });

      setState(() {
        filteredPatients = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    providerPatient = Provider.of<ProviderPatient>(context);
    var appProvider = Provider.of<AppProvider>(context, listen: false);
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(
              children: appProvider.clinic?.id == null
                  ? HeaderOnlyBack(
                      headerTitle: 'Pacientes',
                    )
                  : HeaderWithBackAndNext(
                      customIcon: Icons.add,
                      headerTitle: 'Pacientes',
                      nextRoute: '/patient/add',
                    ),
            ),
            Expanded(
              child: appProvider.clinic?.id == null
                  ? Center(
                      child: Text(
                          'Has entrado como dueño ve a empresas, entra a una y en tus clinicas selecciona una clinica con la que quisieras ver información.',
                          textAlign: TextAlign.center),
                    )
                  : isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container(
                          padding: AppStyle.paddingApp,
                          child: Column(
                            children: [
                              searchField(),
                              SizedBox(height: 30),
                              filteredPatients.length == 0
                                  ? noData()
                                  : listOfPatients()
                            ],
                          ),
                        ),
            )
          ],
        ),
      ),
    );
  }

  Widget searchField() => Container(
        child: TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              filled: true,
              enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
              hintStyle: TextStyle(color: Colors.grey[800]),
              hintText: "Busca un paciente...",
              fillColor: Colors.grey[200]),
          onChanged: (value) => onItemChange(value),
        ),
      );

  Widget listOfPatients() => Expanded(
        child: Container(
            child: CustomListView(
          items: filteredPatients,
          itemBuilder: (BuildContext context, int index) {
            final Expedient expedient = filteredPatients[index];
            return patientItem(expedient);
          },
        )),
      );

  Widget patientItem(Expedient expedient) => GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/patient/detail',
            arguments: expedient),
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.grey[200]?.withOpacity(0.7),
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                expedient.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey[700]),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(expedient.whyVisiting ?? "Sin razon de visita"),
                  getAge(expedient)
                ],
              )
            ],
          ),
        ),
      );

  Widget getAge(Expedient expedient) {
    DateTime now = DateTime.now();
    DateTime time = DateTime.parse(expedient.dateBirthday);
    int age = now.year - time.year;
    return Text('${age.toString()} años');
  }

  Widget noData() {
    final String assetName = 'assets/nodata.svg';
    final Widget svg = SvgPicture.asset(
      assetName,
    );
    return Expanded(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: svg,
            ),
            SizedBox(height: 50),
            Text('No hemos encontrado resultados :('),
          ],
        ),
      ),
    );
  }
}
