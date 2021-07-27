import 'package:expediente_clinico/models/Expedient.dart';
import 'package:expediente_clinico/models/Inquirie.dart';
import 'package:expediente_clinico/models/Service.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/services/inquirie.dart';
import 'package:expediente_clinico/services/services.dart';
import 'package:expediente_clinico/utils/firebase.dart';
import 'package:expediente_clinico/utils/pdf.dart';
import 'package:expediente_clinico/widgets/button.dart';
import 'package:expediente_clinico/widgets/dropdown.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as PdfWidget;
import 'package:uuid/uuid.dart';

class DetailInquirie extends StatefulWidget {
  @override
  _DetailInquirieState createState() => _DetailInquirieState();
}

class _DetailInquirieState extends State<DetailInquirie>
    with SingleTickerProviderStateMixin {
  //tabs config
  int currentIndex = 0;
  Service selectedService;
  TabController _controller;
  List<Service> services;

  Inquirie inquirie;
  bool isLoadinServices = true;

  FirebaseUtil firebaseUtil = FirebaseUtil();

  InquirieService inquirieService = InquirieService();
  ServicesService servicesService = ServicesService();

  @override
  void initState() {
    getServices();
    _controller = TabController(length: 3, vsync: this);

    _controller.addListener(() {
      setState(() {
        currentIndex = _controller.index;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  String title;
  String money;

  AppProvider provider;

  @override
  Widget build(BuildContext context) {
    inquirie = ModalRoute.of(context)?.settings.arguments as Inquirie;
    provider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          Header(
            children: HeaderOnlyBack(
              headerTitle: 'Detalle consulta',
            ),
          ),
          tabController(),
          Expanded(child: tabBarView())
        ],
      ),
    );
  }

  Widget tabController() {
    return DefaultTabController(
      length: 3,
      child: TabBar(
        controller: _controller,
        indicatorColor: Color(0xff4361ee),
        unselectedLabelColor: Colors.grey[400],
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 2,
        labelPadding: EdgeInsets.symmetric(vertical: 15),
        labelColor: Color(0xff4361ee),
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        tabs: [
          Column(
            children: [
              Text(
                'Detalles',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Column(
            children: [
              Text(
                'Historial procedimiento',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Column(
            children: [
              Text(
                'Crear subconsulta',
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
        contentInquirie(),
        contentHistory(inquirie.history),
        contentFormSubInquirie()
      ],
    );
  }

  Widget contentInquirie() => Container(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            itemSelectedExpedient(inquirie.expedient),
            SizedBox(height: 30),
            Text("Detalles de consulta", style: TextStyle(fontSize: 20)),
            SizedBox(height: 30),
            Text("Servicio brindado ${inquirie.service}"),
            SizedBox(height: 20),
            Text("Estado: ${inquirie.status}"),
            SizedBox(height: 20),
            Text("Servicio en total: \$${inquirie.totalService}"),
            SizedBox(height: 20),
            Text("Prima: \$${inquirie.deposit}"),
            SizedBox(height: 20),
            Text("Cuota acordada: \$${inquirie.quota}"),
            SizedBox(height: 20),
            Text("Sesiones: ${inquirie.session}"),
            SizedBox(height: 20),
            Text("Balance: \$${inquirie.balance}"),
          ],
        ),
      );

  Widget contentHistory(List<dynamic> history) => Container(
        child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemCount: history.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(history[index]["title"] ?? 'Sin servicio'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text('Abonado: \$${history[index]["money"]}'),
                    SizedBox(
                      height: 10,
                    ),
                    Text(history[index]["date"] ?? ""),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            }),
      );

  Widget contentFormSubInquirie() => Container(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            Text('Crear procedimiento'),
            SizedBox(height: 30),
            isLoadinServices ? CircularProgressIndicator() : comboServices(),
            SizedBox(height: 20),
            Text(
                'Estimado de servicio: ${selectedService?.price == null ? "sin servicio" : selectedService.price}'),
            SizedBox(height: 20),
            CustomTextField(
              keyboardType: TextInputType.number,
              iconOnLeft: null,
              iconOnRight: null,
              value: null,
              helperText: "",
              maxLenght: 100,
              controller: null,
              hint: 'Monto',
              onChange: (String value) {
                setState(() {
                  money = value;
                });
              },
            ),
            SizedBox(height: 20),
            CustomButton(
              onPressed: () => addHistory(),
              titleButton: 'Crear',
            )
          ],
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
              inquirie.service = selectedService.typeOfService;
            });
          },
          children: services
              .map((e) =>
                  DropdownMenuItem(value: e, child: Text(e.typeOfTreatment)))
              .toList(),
        ),
      );

  Widget itemSelectedExpedient(Expedient selectedExpedient) => Container(
        width: double.infinity,
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
            Text('Malestar: ' + selectedExpedient.badFor),
            SizedBox(height: 15),
            Text('Motivo: ' + selectedExpedient.whyVisiting),
            SizedBox(height: 15),
            Text('${selectedExpedient.dateBirthday}')
          ],
        ),
      );

  void addHistory() async {
    await pdfCreate();
    var data = {
      'title': selectedService.typeOfTreatment,
      'money': money != null ? money : selectedService.price
    };
    var res = await inquirieService.addHistoryToInquirie(data, inquirie.id);
    if (res['success']) {
      FocusScope.of(context).unfocus();

      setState(() {
        //inquirie.history.add(data);
        _controller.index = 0;
      });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Ha ocurrido un error, intenta luego.'),
            );
          });
    }
  }

  Future pdfCreate() async {
    try {
      await PDFUtil.createPDF(
          createContent(), 'subsconsultas-facturas', Uuid().v4());
    } catch (e) {
      print('hola');
      print(e);
    }
  }

  dynamic createContent() {
    return PdfWidget.Container(
        width: double.infinity,
        child: PdfWidget.Column(children: [
          PdfWidget.Text('Factura'),
          PdfWidget.SizedBox(height: 20),
          PdfWidget.Text('Tipo de factura - Ticket'),
          PdfWidget.SizedBox(height: 20),
          PdfWidget.Text('Clinica: ${provider.clinic.name}'),
          PdfWidget.SizedBox(height: 20),
          PdfWidget.Text('Doctor: ${provider.fullname}'),
          PdfWidget.SizedBox(height: 20),
          PdfWidget.Divider(height: 1),
          PdfWidget.SizedBox(height: 20),
          PdfWidget.Text('Procedimiento: ${selectedService.typeOfTreatment}'),
          PdfWidget.SizedBox(height: 20),
          PdfWidget.Text('Procedimiento: ${selectedService.price}')
        ]));
  }

  void getServices() async {
    provider = Provider.of<AppProvider>(context, listen: false);
    if (provider.role == 'Dueño' && provider.enterprise == null) return;
    services = await servicesService.getServicesByEnterprise(
        provider.role == 'Dueño'
            ? provider.enterprise.id
            : provider.enterpriseIdFrom);
    isLoadinServices = false;
    setState(() {});
  }
}
