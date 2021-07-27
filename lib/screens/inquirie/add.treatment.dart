import 'package:expediente_clinico/models/Service.dart';
import 'package:expediente_clinico/models/Treatment.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/providers/treatments.dart';
import 'package:expediente_clinico/services/services.dart';
import 'package:expediente_clinico/widgets/button.dart';
import 'package:expediente_clinico/widgets/dropdown.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTreatmentScreen extends StatefulWidget {
  @override
  _AddTreatmentScreenState createState() => _AddTreatmentScreenState();
}

class _AddTreatmentScreenState extends State<AddTreatmentScreen> {
  TextEditingController priceController = TextEditingController();
  AppProvider appProvider;
  Treatment treatment = Treatment();
  List<Service> services = [];
  ServicesService servicesService = ServicesService();
  Service selectedService;
  bool isLoadingServices = true;

  @override
  void initState() {
    getServices();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerTreatment = Provider.of<ProviderTreatment>(context);
    appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(
            children: HeaderOnlyBack(
              headerTitle: 'Añadir Tratamiento',
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              children: [
                isLoadingServices
                    ? Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      )
                    : comboServices(),
                SizedBox(height: 15),
                CustomTextField(
                  controller: priceController,
                  hint: 'Precio',
                  onChange: (String value) {
                    setState(() {
                      treatment.price = double.tryParse(value);
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                TextField(
                  maxLines: 8,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 1,
                          style: BorderStyle.none,
                        ),
                      ),
                      hintText: "Descripción de tratamiento"),
                  onChanged: (value) {
                    setState(() {
                      treatment.description = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                CustomButton(
                  onPressed: () => addTreatment(providerTreatment),
                  titleButton: 'Añadir',
                )
              ],
            ),
          )
        ],
      ),
    );
  }

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

              //priceController.text = treatment.price.toString();
            });
          },
          children: services
              .map((e) =>
                  DropdownMenuItem(value: e, child: Text(e.typeOfTreatment)))
              .toList(),
        ),
      );

  void addTreatment(ProviderTreatment providerTreatment) {
    treatment.nameTreatment = selectedService.typeOfService;
    treatment.price = double.parse(selectedService.price);
    providerTreatment.treatment = treatment;
    Navigator.pop(context);
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
