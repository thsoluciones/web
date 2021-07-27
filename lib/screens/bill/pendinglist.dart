import 'package:expediente_clinico/models/Bill.dart';
import 'package:pdf/widgets.dart' as PdfWidget;
import 'package:expediente_clinico/models/Inquirie.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/providers/inquirie.dart';
import 'package:expediente_clinico/services/bill.dart';
import 'package:expediente_clinico/services/inquirie.dart';
import 'package:expediente_clinico/utils/pdf.dart';
import 'package:expediente_clinico/widgets/button.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/showBlock.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class PendingListInquiries extends StatefulWidget {
  @override
  _PendingListInquiriesState createState() => _PendingListInquiriesState();
}

class _PendingListInquiriesState extends State<PendingListInquiries>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  TabController _controller;
  Inquirie selectedInquirie;

  BillService billService = BillService();

  ProviderInquirie providerInquirie;
  AppProvider appProvider;

  InquirieService inquirieService = InquirieService();

  int paymentMethod = 0;
  bool isLoadingBill = false;

  List<String> methods = ['Efectivo', 'Con tarjeta'];

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);

    _controller.addListener(() {
      setState(() {
        currentIndex = _controller.index;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    providerInquirie = Provider.of<ProviderInquirie>(context);
    appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Header(
          children: appProvider.clinic?.id != null
              ? HeaderOnlyBack(
                  headerTitle: 'Facturación',
                )
              : HeaderOnlyBack(
                  headerTitle: 'Facturación',
                ),
        ),
        SizedBox(height: 10),
        appProvider.clinic?.id == null
            ? Container()
            : Expanded(
                child: listbills(),
              )
      ]),
    );
  }

  Widget listbills() {
    return FutureBuilder(
        future: billService.getBillsByClinic(appProvider.clinic?.id),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            //return Container();
            return listOfBills(snapshot.data as List<Bill>);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget listOfBills(List<Bill> bills) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: bills.length,
      itemBuilder: (BuildContext context, int index) {
        Bill bill = bills[index];
        return GestureDetector(child: itemBill(bill));
      },
    );
  }

  Widget itemBill(Bill bill) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      color: Colors.grey[100],
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Asunto: ${bill.title}'),
          SizedBox(height: 20),
          Text('Expediente: ${bill.patient.name}'),
          SizedBox(height: 20),
          Text('Subtotal: ${bill.subtotal}'),
          SizedBox(height: 20),
          CustomButton(
            onPressed: () => {
              //payBill(bill, appProvider)
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(builder: (context, updateState) {
                      return AlertDialog(
                        title: Text('Seleccione metodo de pago'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ShowBlockOfWidgets(
                              show: isLoadingBill,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(),
                                )
                              ],
                            ),
                            ShowBlockOfWidgets(
                              show: !isLoadingBill,
                              children: [
                                Row(
                                  children: [
                                    Radio(
                                        value: 0,
                                        groupValue: paymentMethod,
                                        onChanged: (dynamic value) {
                                          updateState(() {
                                            paymentMethod = value;
                                          });
                                        }),
                                    Text('Tarjeta')
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio(
                                        value: 1,
                                        groupValue: paymentMethod,
                                        onChanged: (dynamic value) {
                                          updateState(() {
                                            paymentMethod = value;
                                          });
                                        }),
                                    Text('Efectivo')
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        actions: [
                          ShowBlockOfWidgets(
                            show: !isLoadingBill,
                            children: [
                              FlatButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancelar')),
                              FlatButton(
                                  onPressed: () async {
                                    updateState(() => isLoadingBill = true);
                                    payBill(bill, appProvider);
                                  },
                                  child: Text('Aceptar')),
                            ],
                          )
                        ],
                      );
                    });
                  })
            },
            titleButton: 'Facturar',
          )
        ],
      ),
    );
  }

  void payBill(Bill bill, AppProvider provider) async {
    var uuid = Uuid();
    var resPdf = await PDFUtil.createPDF(
        createContent(provider, bill), 'facturas', uuid.v4());
    print(resPdf);
    if (resPdf['state'] == 'success') {
      var resBill = await billService.updateBill(
          paymentMethod == 0 ? "Efectivo" : "Tajeta", bill.id, resPdf['url']);
      if (resBill['status']) {
        Navigator.pop(context);
        setState(() {
          isLoadingBill = false;
        });
        launchURL(resPdf['url']);
      } else {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('La factura no pudo ser alamacenada'),
              );
            });
      }
    } else {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('La factura no pudo ser alamacenada'),
            );
          });
    }
  }

  void launchURL(String url) async {
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  dynamic createContent(AppProvider provider, Bill bill) {
    print(bill.inquirie.treatments);

    return PdfWidget.Container(
        width: double.infinity,
        child: PdfWidget.Column(
            crossAxisAlignment: PdfWidget.CrossAxisAlignment.start,
            children: [
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
              PdfWidget.Text('Procedimiento: ${bill.inquirie.service}'),
              PdfWidget.SizedBox(height: 20),
              PdfWidget.SizedBox(height: 20),
              // PdfWidget.Column(
              //     children: bill.inquirie.recetaries
              //         .map((e) => e['medicine'])
              //         .toList()),
              PdfWidget.Text(
                  'Paciente: ${bill.patient.name} ${bill.patient.lastname}'),
              PdfWidget.Text('Procedimiento: ${bill.inquirie.service}'),
              PdfWidget.SizedBox(height: 20),
              PdfWidget.Text('SubTotal: ${bill.subtotal}'),
              PdfWidget.SizedBox(height: 20),
            ]));
  }
}
