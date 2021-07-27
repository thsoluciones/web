import 'package:expediente_clinico/models/Expedient.dart';
import 'package:expediente_clinico/models/Inquirie.dart';
import 'package:expediente_clinico/models/Service.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/providers/inquirie.dart';
import 'package:expediente_clinico/providers/patient.dart';
import 'package:expediente_clinico/providers/recetary.dart';
import 'package:expediente_clinico/providers/treatments.dart';
import 'package:expediente_clinico/services/expedient.dart';
import 'package:expediente_clinico/services/inquirie.dart';
import 'package:expediente_clinico/services/services.dart';
import 'package:expediente_clinico/style.dart';
import 'package:expediente_clinico/widgets/dropdown.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/showBlock.dart';
import 'package:expediente_clinico/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AddInquirieScreen extends StatefulWidget {
  @override
  _AddInquirieScreenState createState() => _AddInquirieScreenState();
}

class _AddInquirieScreenState extends State<AddInquirieScreen> {
  List<String> items = ['Servicio 1', 'Servicio 2', 'Servicio 3', 'Servicio 4'];

  Expedient selectedExpedient;
  ProviderTreatment providerTreatment;
  ProviderPatient providerPatient;
  ProviderRecetary providerRecetary;
  ProviderInquirie providerInquirie;
  Inquirie inquirie;
  InquirieService inquirieService = InquirieService();
  List<Service> services = [];
  List<Expedient> patients = [];
  Service selectedService;
  double extras = 0;
  double subTotal = 0;
  double deposit = 0;
  double cuota = 0;
  double prime = 0;
  int sessions = 0;
  String description;
  ServicesService servicesService = ServicesService();
  bool isLoadingServices = true;
  AppProvider appProvider;
  bool isLoading = false;
  bool isLoadingRequest = false;
  ExpedientService expedientService = ExpedientService();
  List<Map<String, dynamic>> recetary = [];
  List<Map<String, dynamic>> treatments = [];
  int _radioValue = 0;
  int _radioTypeInquirie = 0;
  bool isInquirieCreated = true;
  DateTime _selectedDate;
  String dateOfDate;
  TextEditingController dateInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getServices();
    getPatients();
  }

  List<Expedient> filteredPatients = [];

  void getPatients() async {
    var appProvider = Provider.of<AppProvider>(context, listen: false);

    List<Expedient> expedients =
        await expedientService.getPatients(appProvider.clinic.id);

    setState(() {
      isLoading = false;
      filteredPatients = expedients;
      patients = expedients;
    });
  }

  @override
  Widget build(BuildContext context) {
    providerTreatment = Provider.of<ProviderTreatment>(context);
    providerRecetary = Provider.of<ProviderRecetary>(context);
    providerInquirie = Provider.of<ProviderInquirie>(context);
    providerPatient = Provider.of<ProviderPatient>(context);

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(
              children: HeaderOnlyBack(
                headerTitle: 'Añadir Consulta',
              ),
            ),
            selectedExpedient == null
                ? Expanded(
                    child: Container(
                        padding: AppStyle.paddingApp,
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Column(
                                children: [
                                  searchField(),
                                  SizedBox(height: 30),
                                  filteredPatients.length == 0
                                      ? noData()
                                      : listOfPatients()
                                ],
                              )),
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
                    onTap: () => setState(() => selectedExpedient = null),
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
              SizedBox(height: 20),
              Text('Tipo de consulta', style: AppStyle.labelInputStyle),
              SizedBox(height: 20),
              Row(
                children: [
                  Radio(
                    groupValue: _radioTypeInquirie,
                    onChanged: (dynamic value) {
                      setState(() {
                        _radioTypeInquirie = value;
                      });
                    },
                    value: 0,
                  ),
                  Text('Tratamiento (pago en cuotas)')
                ],
              ),
              Row(
                children: [
                  Radio(
                    groupValue: _radioTypeInquirie,
                    onChanged: (dynamic value) {
                      setState(() {
                        _radioTypeInquirie = value;
                      });
                    },
                    value: 1,
                  ),
                  Text('Instantanea (pago instantaneo)')
                ],
              ),
              SizedBox(height: 30),
              Text('Servicio a ofrecer', style: AppStyle.labelInputStyle),
              SizedBox(height: 10),
              isLoadingServices
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: Text('Cargando servicios...'),
                    )
                  : comboServices(),
              SizedBox(height: 20),
              Text(
                  'Servicio: ${selectedService?.typeOfTreatment == null ? "sin servicio seleccionado" : selectedService.typeOfTreatment}',
                  style: AppStyle.labelInputStyle),
              SizedBox(height: 20),
              Text(
                  'Costo base : \$${selectedService?.price == null ? 0 : selectedService.price}',
                  style: AppStyle.labelInputStyle),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Servicios extra', style: AppStyle.labelInputStyle),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, '/inquirie/treatment/add'),
                    child: Text('Añadir',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff2667ff),
                            fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              SizedBox(height: 10),
              treatmentsView(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recetario', style: AppStyle.labelInputStyle),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, '/inquirie/recetary/add'),
                    child: Text('Añadir',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff2667ff),
                            fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              recetaryView(),
              SizedBox(height: 20),
              ShowBlockOfWidgets(
                show: _radioTypeInquirie == 0,
                children: [
                  SizedBox(height: 10),
                  CustomTextField(
                    keyboardType: TextInputType.number,
                    hint: 'Prima inicial',
                    onChange: (String value) {
                      setState(() {
                        deposit = double.tryParse(value) as double;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    keyboardType: TextInputType.number,
                    hint: 'Cuota de preferencia',
                    onChange: (dynamic value) {
                      setState(() {
                        cuota = double.tryParse(value) as double;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    keyboardType: TextInputType.number,
                    hint: 'No de sesiones de pago',
                    onChange: (value) {
                      setState(() {
                        sessions = int.parse(value);
                      });
                    },
                  )
                ],
              ),
              SizedBox(height: 20),
              selectedService != null ? totalTreatment() : Container(),
              SizedBox(height: 20),
              CustomTextField(
                hint: 'Seleccione una fecha',
                controller: dateInputController,
                isReadOnly: true,
                iconOnLeft: Icons.calendar_today,
                onTap: () => _pickDateDialog(),
              ),
              SizedBox(height: 20),
              CustomTextField(
                rows: 8,
                hint: 'Descripción de la consulta',
                onChange: (value) {
                  setState(() {
                    description = value;
                  });
                },
              ),
              SizedBox(height: 20),
              RaisedButton(
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  color: Color(0xff2667ff),
                  textColor: Colors.white,
                  onPressed: isLoadingRequest ? null : addPatient,
                  child: Text('Crear Consulta'))
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
          onChange: (dynamic value) {
            setState(() {
              selectedService = value;
              //inquirie.service = selectedService.typeOfService;
            });
          },
          children: services
              .map((e) =>
                  DropdownMenuItem(value: e, child: Text(e.typeOfTreatment)))
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
          Text('${providerTreatment.treatments.length} servicios añadidos',
              style: AppStyle.labelInputStyle),
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
  Widget recetaryView() => Container(
      padding: EdgeInsets.symmetric(
        vertical: 20,
      ),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${providerRecetary.recetaries.length} Recetarios creados',
              style: AppStyle.labelInputStyle),
          GestureDetector(
              child: Row(
            children: [
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, '/inquirie/recetary/all'),
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
                ? 'Motivo: ${selectedExpedient?.whyVisiting}'
                : "Sin razon de visita"),
            SizedBox(height: 15),
            Text('${selectedExpedient.dateBirthday}')
          ],
        ),
      );

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
                Expedient expedient = filteredPatients[index];
                return GestureDetector(
                    onTap: () => {
                          setState(() {
                            selectedExpedient = expedient;
                            //inquirie.expedient = expedient;
                          })
                        },
                    child: patientItem(expedient));
              }),
        ),
      );

  Widget patientItem(Expedient expedient) => Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.grey[200].withOpacity(0.7),
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

  Widget totalTreatment() {
    double sum = 0;

    for (int i = 0; i < providerTreatment.treatments.length; i++) {
      sum += providerTreatment.treatments[i].price;
    }

    double totalInquirie = sum + double.tryParse(selectedService.price);

    setState(() {
      extras = sum;
      subTotal = totalInquirie;
    });

    return Text('Subtotal: $subTotal');
  }

  void addPatient() async {
    setState(() {
      isLoadingRequest = true;
    });
    double totalInquirie;

    if (deposit != null && deposit > 0) {
      totalInquirie = extras + double.tryParse(selectedService?.price);
    }

    if (selectedService == null) {
      setState(() {
        isLoadingRequest = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Servicio requerido'),
              content: Text('Seleccione un servicio antes de continuar'),
            );
          });
    } else if (deposit > 0 && deposit > totalInquirie) {
      setState(() {
        isLoadingRequest = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                  'El deposito no puede ser mayor al costo total de la consulta'),
            );
          });
    } else {
      if (dateOfDate == null || description == null || description.isEmpty) {
        setState(() {
          isLoadingRequest = false;
        });
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text(
                    'Fecha de acción de consulta y descripción son necesarios.'),
              );
            });
      }

      print(_radioTypeInquirie == 0 ? 'treatment' : 'directly');
      providerTreatment.treatments
          .map((e) => treatments.add(e.toJson()))
          .toList();
      providerRecetary.recetaries.map((e) => recetary.add(e.toJson())).toList();

      var body = {
        "date": dateOfDate,
        "title": description,
        "patient": selectedExpedient.id,
        "service": selectedService.typeOfTreatment,
        "baseprice": selectedService.price,
        "treatments": treatments,
        "type": _radioTypeInquirie == 0 ? 'treatment' : 'directly',
        "recetaries": recetary,
        "deposit": deposit, // prima inicial
        "quota": cuota,
        "status": _radioTypeInquirie == 0 ? 'No abonado' : 'Pendiente',
        "session": sessions, //sesiones
        "balance": deposit == 0
            ? extras + double.tryParse(selectedService.price)
            : (extras + double.tryParse(selectedService.price)) - deposit,
        "clinic": appProvider.clinic.id,
        "methodPayment": _radioValue == 0 ? 'Tarjeta' : 'Efectivo',
        "totalService": extras + double.tryParse(selectedService.price)
      };
      var res = await inquirieService.addInquirie(body);

      if (res['success']) {
        Navigator.popAndPushNamed(context, appProvider.homeRoute);
        providerRecetary.clear();
        providerTreatment.clear();
      } else {
        setState(() {
          isLoadingRequest = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error al ingresar'),
                content: Text('No se pudo agregar la consulta, intente luego'),
              );
            });
      }
    }
  }

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

  void getServices() async {
    appProvider = Provider.of<AppProvider>(context, listen: false);
    if (appProvider.role == 'Dueño' && appProvider.enterprise == null) return;
    services = await servicesService.getServicesByEnterprise(
        appProvider.role == 'Dueño'
            ? appProvider.enterprise.id
            : appProvider.enterpriseIdFrom);
    isLoadingServices = false;
    setState(() {});
  }
}
