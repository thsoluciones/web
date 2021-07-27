import 'package:expediente_clinico/models/Bill.dart';
import 'package:expediente_clinico/models/Expedient.dart';
import 'package:expediente_clinico/models/Inquirie.dart';
import 'package:expediente_clinico/models/Recetary.dart';
import 'package:expediente_clinico/models/Treatment.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/services/bill.dart';
import 'package:expediente_clinico/services/expedient.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPatientScreen extends StatefulWidget {
  @override
  _DetailPatientScreenState createState() => _DetailPatientScreenState();
}

class _DetailPatientScreenState extends State<DetailPatientScreen>
    with SingleTickerProviderStateMixin {
  //tabs config
  int currentIndex = 0;
  TabController _controller;
  Expedient expedient;

  TextEditingController dateInputController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  ExpedientService expedientService = ExpedientService();
  AppProvider appProvider;
  BillService billService = BillService();

  @override
  void initState() {
    _controller = TabController(length: 4, vsync: this);

    _controller.addListener(() {
      setState(() {
        currentIndex = _controller.index;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  //screen patient detail state
  DateTime _selectedDate;
  String dateOfDate;
  String message;
  bool loadingMessage = false;

  @override
  Widget build(BuildContext context) {
    expedient = ModalRoute.of(context)?.settings.arguments as Expedient;
    appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(
              children: HeaderOnlyBack(
                headerTitle: 'Detalle paciente',
              ),
            ),
            tabController(),
            Expanded(
              child: tabBarView(),
            )
          ],
        ),
      ),
    );
  }

  Widget tabController() {
    return DefaultTabController(
      length: 4,
      child: TabBar(
        controller: _controller,
        indicatorColor: Color(0xff4361ee),
        unselectedLabelColor: Colors.grey[400],
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 2,
        labelPadding: EdgeInsets.symmetric(vertical: 15),
        labelColor: Color(0xff4361ee),
        onTap: (index) {
          FocusScope.of(context).unfocus();
          setState(() {
            currentIndex = index;
          });
        },
        tabs: [
          Column(
            children: [
              Text(
                'Detalle paciente',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Column(
            children: [
              Text(
                'Historial de paciente',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Column(
            children: [
              Text(
                'Historial clinico',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Column(
            children: [
              Text(
                'Historial de pagos',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget tabBarView() {
    return TabBarView(
      controller: _controller,
      children: [
        ListView(
          padding: EdgeInsets.zero,
          children: [detailPatient()],
        ),
        historyPatient(expedient.history),
        listOfInquiries(),
        listOfBills()
      ],
    );
  }

  Widget detailPatient() => Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  Image(
                    height: 80,
                    width: 80,
                    image: AssetImage('assets/profile-patient.png'),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(expedient.name),
                          SizedBox(width: 5),
                          Text(expedient.lastname == null
                              ? 'sin apellido'
                              : expedient.lastname),
                        ],
                      ),
                      SizedBox(height: 5),
                      getAge(expedient)
                    ],
                  ),
                ],
              ),
            ),
            if (expedient.isAChild) isChildInfo(expedient) else Container(),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dirección de vivienda'),
                SizedBox(height: 5),
                Text(expedient.direction),
                SizedBox(height: 5),
                Text('Razon de visita'),
                SizedBox(height: 5),
                Text(expedient.whyVisiting ?? "Sin razon de visita"),
                SizedBox(height: 5),
                Text('Malestar'),
                SizedBox(height: 5),
                Text(expedient.badFor ?? "Sin registro de malestar"),
                SizedBox(height: 5),
                Text('Ultima clinica visitada'),
                SizedBox(height: 5),
                Text(expedient.lastClinicVisiting ?? "Sin clinica previa"),
                SizedBox(height: 5),
                Text('Ultima clinica odontologica visitada'),
                SizedBox(height: 5),
                Text(
                    expedient.odontologyLastArchive ?? "Sin odontologia previa")
              ],
            )
          ],
        ),
      );
  Widget historyPatient(List<dynamic> history) => Container(
          child: Column(
        children: [
          Expanded(
            child: history.length == 0
                ? Center(
                    child: Text('Sin historial de paciente.'),
                  )
                : ListView.builder(
                    itemCount: history.length,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(history[index]['title'] ?? "Sin titulo"),
                        subtitle: Text(history[index]['date'] ?? "sin fecha"),
                      );
                    },
                  ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () => _pickDateDialog(),
                      icon: Icon(Icons.calendar_today)),
                  Expanded(
                    child: CustomTextField(
                      keyboardType: TextInputType.text,
                      rows: 1,
                      controller: messageController,
                      hint: 'Escribe algo',
                      onChange: (String value) {
                        setState(() {
                          message = value;
                        });
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        if (message == null ||
                            message.isEmpty ||
                            dateOfDate == null) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text(
                                      'No se puede enviar el historial, se necesita fecha y mensaje.'),
                                );
                              });
                        } else {
                          sendHistory();
                        }
                      },
                      icon: loadingMessage
                          ? CircularProgressIndicator(
                              strokeWidth: 2,
                            )
                          : Icon(Icons.send)),
                ],
              ))
        ],
      ));

  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1850),
            lastDate: DateTime.now())
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

  Widget isChildInfo(Expedient expedient) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Perfil del niño/a'),
            SizedBox(height: 10),
            Text('Colegio'),
            SizedBox(height: 10),
            Text(expedient.child['school']),
            SizedBox(height: 10),
            Text('Padres de familia'),
            SizedBox(height: 10),
            Text(
                'Padre: ${expedient.child['fatherName']} Madre:${expedient.child['motherName']}')
          ],
        ),
      );
  Widget getAge(Expedient expedient) {
    DateTime now = DateTime.now();
    DateTime time = DateTime.parse(expedient.dateBirthday);
    int age = now.year - time.year;
    return Text('${age.toString()} años');
  }

  //Inquiries view
  Widget listOfInquiries() => FutureBuilder(
      future: expedientService.getHistoryClinic(
          expedient.id, appProvider.clinic.id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: (snapshot.data as List<Inquirie>).length,
              itemBuilder: (BuildContext context, int index) {
                Inquirie inquirie = snapshot.data[index];
                return itemInquirie(inquirie);
              });
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      });

  Widget itemInquirie(Inquirie inquirie) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              margin: EdgeInsets.only(left: 20, right: 20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Servicio ${inquirie.service}'),
                  Text('Precio: ${inquirie.baseprice}'),
                  SizedBox(height: 30),
                  InkWell(
                      onTap: () => showRecetary(inquirie.recetaries),
                      child: Text('Ver recetario',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ))),
                  SizedBox(height: 20),
                  InkWell(
                      onTap: () => showTreatments(inquirie.treatments),
                      child: Text('Ver Tratamientos',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          )))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 28),
              color: Colors.grey,
              width: 2,
              height: 40,
            )
          ],
        ),
      );

  //Bills view
  Widget listOfBills() => FutureBuilder(
      future: billService.getBillsByPatient(expedient.id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: (snapshot.data as List<Bill>).length,
              itemBuilder: (BuildContext context, int index) {
                if (snapshot.data.length == 0) {
                  return Center(
                    child: Text('No hay informacion'),
                  );
                } else {
                  Bill bill = snapshot.data[index];
                  return itemBill(bill);
                }
              });
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      });

  Widget itemBill(Bill bill) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              margin: EdgeInsets.only(left: 20, right: 20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${bill.title}'),
                  SizedBox(height: 30),
                  InkWell(
                      onTap: () => _launchURL(bill.url),
                      child: Text('Ver factura',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          )))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 28),
              color: Colors.grey,
              width: 2,
              height: 40,
            )
          ],
        ),
      );

  void showRecetary(List<dynamic> list) {
    print(list);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Recetario'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: list
                    .map((e) => ListTile(
                          title: Text(e['medicine'] ?? 'Sin medicina'),
                          subtitle: Text(e['indication'] ?? 'Sin indicación'),
                        ))
                    .toList(),
              ),
            ),
          );
        });
  }

  void showTreatments(List<dynamic> list) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Tratamientos'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: list
                    .map((e) => ListTile(
                          title: Text(e['nameTreatment'] ?? 'Sin tratamiento'),
                          subtitle: Text(e['description'] ?? 'Sin descripción'),
                        ))
                    .toList(),
              ),
            ),
          );
        });
  }

  void showHistory(List<dynamic> list) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Historial de pagos'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: list
                    .map((e) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                              ' ${e['date'] ?? 'Sin fecha'} - ${e['methodPayment']}'),
                          subtitle: Text('Abonado: ${e['count'].toString()}'),
                        ))
                    .toList(),
              ),
            ),
          );
        });
  }

  void sendHistory() async {
    setState(() => loadingMessage = true);
    try {
      var data = {'title': message, 'date': dateOfDate};
      var res = await expedientService.addHistory(data, expedient.id);
      if (res['status']) {
        expedient.history.add(data);
        loadingMessage = false;
        message = "";
        messageController.text = "";
        setState(() {});
      } else {
        loadingMessage = false;
        setState(() {});
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text(
                    'No se puede enviar el historial, escriba un mensaje.'),
              );
            });
      }
    } catch (e) {
      print(e);
    }
  }

  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}
