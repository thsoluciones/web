import 'package:expediente_clinico/models/Date.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/services/date.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewDatesScreen extends StatefulWidget {
  @override
  _ViewDatesScreenState createState() => _ViewDatesScreenState();
}

class _ViewDatesScreenState extends State<ViewDatesScreen> {
  AppProvider appProvider;
  DateService dateService = DateService();
  @override
  Widget build(BuildContext context) {
    appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(
              children: appProvider.clinic?.id == null
                  ? HeaderOnlyBack(
                      headerTitle: 'Citas',
                    )
                  : HeaderWithBackAndNext(
                      headerTitle: 'Citas',
                      nextRoute: '/dates/add',
                      customIcon: Icons.add,
                    ),
            ),
            Expanded(
              child: appProvider.clinic?.id == null
                  ? Center(
                      child: Text(
                          'Has entrado como dueño ve a empresas, entra a una y en tus clinicas selecciona una clinica con la que quisieras ver información.',
                          textAlign: TextAlign.center))
                  : FutureBuilder(
                      future:
                          dateService.getDatesByClinic(appProvider.clinic.id),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: (snapshot.data as List<Date>).length,
                            itemBuilder: (BuildContext context, int index) {
                              Date date = snapshot.data[index];
                              return Container(
                                padding: EdgeInsets.all(15),
                                decoration:
                                    BoxDecoration(color: Colors.grey[200]),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${date.date}',
                                              style: TextStyle(
                                                fontSize: 20,
                                              )),
                                          date.documentUrl == null
                                              ? Container()
                                              : IconButton(
                                                  onPressed: () async {
                                                    if (await canLaunch(
                                                        date.documentUrl)) {
                                                      launch(date.documentUrl);
                                                    }
                                                  },
                                                  icon:
                                                      Icon(Icons.file_present)),
                                        ]),
                                    SizedBox(height: 10),
                                    Text('Hora: ${date.hour}'),
                                    SizedBox(height: 20),
                                    Text(
                                        '${date.patient.name} ${date.patient.lastname}'),
                                    SizedBox(height: 10),
                                    Text(
                                        'Doctor: ${date.doctor.name} ${date.doctor.lastname}'),
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
