import 'dart:convert';
import 'dart:io';
//import 'package:expediente_clinico/helpers/permissionHandler.dart';
import 'package:expediente_clinico/models/Expedient.dart';
import 'package:expediente_clinico/models/Staff.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/services/date.dart';
import 'package:expediente_clinico/services/expedient.dart';
import 'package:expediente_clinico/services/staff.dart';
import 'package:expediente_clinico/style.dart';
import 'package:expediente_clinico/utils/firebase.dart';
import 'package:expediente_clinico/widgets/dropdown.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AddDateScreen extends StatefulWidget {
  @override
  _AddDateScreenState createState() => _AddDateScreenState();
}

class _AddDateScreenState extends State<AddDateScreen> {
  TextEditingController dateInputController = TextEditingController();
  TextEditingController hourInputController = TextEditingController();
  FirebaseUtil firebaseUtil = FirebaseUtil();
  StaffService staffService = StaffService();
  DateService dateService = DateService();
  DateTime _selectedDate;
  Staff selectedStaff;
  bool isLoadingRequest = false;
  List<String> items = ['Servicio 1', 'Servicio 2', 'Servicio 3', 'Servicio 4'];
  String selectedService;
  Expedient selectedExpedient;

  bool isLoadingDoctors = true;

  TimeOfDay picked;
  String hour;
  String dateOfDate;

  bool isLoading = true;
  List<Expedient> patients = [];

  ExpedientService expedientService = ExpedientService();

  List<Expedient> filteredPatients = [];
  List<Staff> staffList = [];

  AppProvider appProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPatients();
    getStaff();
  }

  void getPatients() async {
    appProvider = Provider.of<AppProvider>(context, listen: false);

    List<Expedient> expedients = await expedientService
        .getPatients(appProvider.clinic.id) as List<Expedient>;

    setState(() {
      isLoading = false;
      filteredPatients = expedients;
      patients = expedients;
    });
  }

  void getStaff() async {
    appProvider = Provider.of<AppProvider>(context, listen: false);
    var res =
        await staffService.getStaffByEnteprise(appProvider.clinic.enterprise);
    setState(() {
      isLoadingDoctors = false;
      staffList = res.where((element) => element.role == 'Doctor').toList()
          as List<Staff>;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appProvider = Provider.of<AppProvider>(context, listen: false);
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(
              children: HeaderOnlyBack(
                headerTitle: 'Crear Cita',
              ),
            ),
            appProvider.clinic.id == null
                ? Expanded(
                    child: Center(
                      child: Text(
                          'Has entrado como dueño ve a empresas, entra a una y en tus clinicas selecciona una clinica con la que quisieras ver información.',
                          textAlign: TextAlign.center),
                    ),
                  )
                : isLoading
                    ? Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : selectedExpedient == null
                        ? Expanded(
                            child: Container(
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
                        : formAddInquirie()
          ],
        ),
      ),
    );
  }

  Widget formAddInquirie() => Expanded(
        child: Container(
          padding: AppStyle.paddingApp,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Expediente Seleccionado: ',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  GestureDetector(
                    onTap: () => setState(() => selectedExpedient),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.red[400]?.withOpacity(0.5),
                      ),
                      child: Icon(Icons.close, color: Colors.red[900]),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              itemSelectedExpedient(),
              SizedBox(height: 30),
              CustomTextField(
                iconOnRight: Icons.calendar_today,
                onTap: _pickDateDialog,
                controller: dateInputController,
                hint: 'Seleccione fecha de cita',
                isReadOnly: true,
              ),
              SizedBox(height: 20),
              CustomTextField(
                iconOnRight: Icons.lock_clock,
                onTap: hourDialog,
                controller: hourInputController,
                hint: 'Seleccione hora de cita',
                isReadOnly: true,
              ),
              SizedBox(height: 20),
              appProvider.role == 'Doctor'
                  ? Container()
                  : isLoadingDoctors
                      ? Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        )
                      : CustomDropDown(
                          hintText: 'Seleccione un doctor',
                          actualValue: selectedStaff,
                          children: staffList
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ))
                              .toList(),
                          onChange: (value) {
                            setState(() {
                              selectedStaff = value;
                            });
                          },
                        ),
              SizedBox(height: 30),
              RaisedButton(
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  color: Color(0xff2667ff),
                  textColor: Colors.white,
                  onPressed: () {
                    addDate();
                  },
                  child: Text('Crear Cita'))
            ],
          ),
        ),
      );

  Widget comboServices() => Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.5, style: BorderStyle.solid),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
        ),
        child: CustomDropDown(
          hintText: 'Seleccione un servicio',
          actualValue: selectedService,
          onChange: (value) {
            setState(() {
              selectedService = value;
            });
          },
          children: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
        ),
      );

  Widget doctorView() => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.grey[200]),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            Image(
              fit: BoxFit.cover,
              height: 60,
              width: 60,
              image: AssetImage('assets/doctor.png'),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Alejandro Gonzalez',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                SizedBox(height: 3),
                Text('Doctor - cirujano',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
              ],
            )
          ],
        ),
      );

  Widget treatmentsView() => Container(
      padding: EdgeInsets.symmetric(
        vertical: 20,
      ),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('11 Tratamientos creados', style: AppStyle.labelInputStyle),
          GestureDetector(
              child: Row(
            children: [
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, '/inquirie/treatment/all'),
                child: Text('Ver todos',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color(0xff2667ff),
                        fontWeight: FontWeight.bold)),
              ),
              Icon(Icons.keyboard_arrow_right, color: Color(0xff2667ff))
            ],
          ))
        ],
      ));

  Widget itemSelectedExpedient() => Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        decoration: BoxDecoration(
            color: Colors.grey[200]?.withOpacity(0.7),
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedExpedient.name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey[700]),
            ),
            SizedBox(height: 15),
            Text(selectedExpedient.badFor != null
                ? 'Malestar: ${selectedExpedient.badFor}'
                : "Sin registro de malestar"),
            SizedBox(height: 15),
            Text(selectedExpedient.whyVisiting != null
                ? 'Motivo: ${selectedExpedient.whyVisiting}'
                : "Sin registro de visita"),
            SizedBox(height: 15),
            getAge(selectedExpedient)
          ],
        ),
      );

  Widget getAge(Expedient expedient) {
    DateTime now = DateTime.now();
    DateTime time = DateTime.parse(expedient.dateBirthday);
    int age = now.year - time.year;
    return Text('${age.toString()} años');
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

  Widget listOfPatients() => Expanded(
        child: Container(
          child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: filteredPatients.length,
              itemBuilder: (BuildContext context, int index) {
                final Expedient expedient = filteredPatients[index];
                return GestureDetector(
                    onTap: () =>
                        {setState(() => selectedExpedient = expedient)},
                    child: patientItem(expedient));
              }),
        ),
      );

  Widget patientItem(Expedient expedient) => Container(
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
                Text(expedient.whyVisiting ?? "Sin motivo de visita"),
                getAge(expedient)
              ],
            )
          ],
        ),
      );

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

  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(Duration(days: 0)),
            lastDate: DateTime(
                2100)) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _selectedDate = pickedDate;
        dateInputController.text =
            '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
        dateOfDate =
            '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
      });
    });
  }

  void addDate() async {
    setState(() {
      isLoadingRequest = true;
    });
    if (appProvider.role != 'Doctor' && selectedStaff == null) {
      setState(() {
        isLoadingRequest = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Se necesita seleccionar un doctor'),
            );
          });
    } else {
      if (dateOfDate != null && hour != null) {
        var res = await createPDF();

        if (res['state'] == 'success') {
          var data = jsonEncode({
            'patient': selectedExpedient.id,
            'date': dateOfDate,
            'hour': hour,
            'urlDocument': res['url'],
            'doctor': appProvider.role == 'Doctor'
                ? appProvider.id
                : selectedStaff.id,
            'clinic': appProvider.clinic.id
          });

          var dateRes = await dateService.addDate(data);

          if (dateRes['success']) {
            Navigator.popAndPushNamed(context, appProvider.homeRoute);
          } else {
            setState(() {
              isLoadingRequest = false;
            });
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text(res['message']),
                  );
                });
          }
        } else {}
      } else {
        setState(() {
          isLoadingRequest = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content:
                    Text('Se necesita una fecha y hora para crear la cita'),
              );
            });
      }
    }
  }

  Future<Map<String, dynamic>> createPDF() async {
    // Directory appDocumentsDirectory;
    // String route;
    // if (Platform.isAndroid) {
    //   PermissionHandlerApp permissionHandlerApp = PermissionHandlerApp();
    //   var res = await permissionHandlerApp.request();
    //   if (res.isGranted) {
    //     route = "/storage/emulated/0/Download";
    //     //android
    //     appDocumentsDirectory = await getExternalStorageDirectory();
    //   } else {
    //     await permissionHandlerApp.request();
    //   }
    // } else {
    //   //ios
    //   appDocumentsDirectory = await getApplicationDocumentsDirectory();
    //   route = "$appDocumentsDirectory";
    // }

    // // final file = File(
    // //     "$route/Cita-${_selectedDate.day.toString().padLeft(2, '0')}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.year.toString().padLeft(2, '0')}.pdf");

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/cita.pdf");

    var res = await processPdf(file);

    return res;
  }

  Future<Map<String, dynamic>> processPdf(File file) async {
    pw.Document pdf = pw.Document();

    pdf.addPage(pw.Page(
        orientation: pw.PageOrientation.portrait,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Text('Test');
        }));

    await file.writeAsBytes(await pdf.save());

    var res = await firebaseUtil.uploadFileOrDocument(
        file, 'citas', 'Cita-$dateOfDate');
    return res;
  }

  void hourDialog() async {
    picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child as Widget,
        );
      },
    ) as TimeOfDay;

    if (picked != null) {
      setState(() {
        hourInputController.text =
            '${picked.hour}:${picked.minute} ${picked.period.index == 0 ? 'am' : 'pm'}';
        hour =
            '${picked.hour}:${picked.minute} ${picked.period.index == 0 ? 'am' : 'pm'}';
      });
    }
  }
}
