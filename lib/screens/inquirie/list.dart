import 'package:expediente_clinico/models/Expedient.dart';
import 'package:expediente_clinico/models/Inquirie.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/providers/inquirie.dart';
import 'package:expediente_clinico/services/inquirie.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ViewInquiriesScreen extends StatefulWidget {
  @override
  _ViewInquiriesScreenState createState() => _ViewInquiriesScreenState();
}

class _ViewInquiriesScreenState extends State<ViewInquiriesScreen> {
  ProviderInquirie providerInquirie;
  InquirieService inquirieService = InquirieService();
  List<Inquirie> inquiries = [];
  List<Inquirie> filteredInquiries = [];
  bool isLoading = true;
  AppProvider provider;

  @override
  void initState() {
    super.initState();
    getInquiries();
  }

  @override
  Widget build(BuildContext context) {
    providerInquirie = Provider.of<ProviderInquirie>(context);
    provider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(
              children: provider.clinic?.id == null
                  ? HeaderOnlyBack(
                      headerTitle: 'Consultas',
                    )
                  : HeaderWithBackAndNext(
                      headerTitle: 'Consultas',
                      nextRoute: '/inquirie/add',
                      customIcon: Icons.add,
                    ),
            ),
            SizedBox(height: 15),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
                  keyboardType: TextInputType.text,
                  iconOnLeft: null,
                  iconOnRight: null,
                  value: null,
                  helperText: "",
                  maxLenght: 100,
                  controller: null,
                  hint: 'Busca algun paciente',
                  onChange: (String value) {
                    List<Inquirie> result = inquiries
                        .where((element) =>
                            element.expedient.name == value ||
                            element.expedient.lastname == value)
                        .toList();
                    if (value.isEmpty) {
                      setState(() {
                        filteredInquiries = inquiries;
                      });
                    } else {
                      setState(() {
                        filteredInquiries = result;
                      });
                    }
                  },
                )),
            SizedBox(height: 15),
            Expanded(
              child: provider.clinic?.id == null
                  ? Center(
                      child: Text(
                          'Has entrado como dueño ve a empresas, entra a una y en tus clinicas selecciona una clinica con la que quisieras ver información.',
                          textAlign: TextAlign.center),
                    )
                  : isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : filteredInquiries.length == 0
                          ? noData()
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: filteredInquiries.length,
                              itemBuilder: (BuildContext context, int index) {
                                Inquirie inquirie = filteredInquiries[index];
                                return itemInquirie(inquirie);
                              },
                            ),
            )
          ],
        ),
      ),
    );
  }

  Widget noData() {
    final String assetName = 'assets/nodata.svg';
    final Widget svg = SvgPicture.asset(
      assetName,
    );
    return Center(
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
    );
  }

  Widget itemInquirie(Inquirie inquirie) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      color: Colors.grey[200],
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Paciente:'),
          SizedBox(height: 10),
          Text('${inquirie.expedient.name} ${inquirie.expedient.lastname}'),
          Divider(
            thickness: 2,
          ),
          Text('Expediente general.'),
          SizedBox(height: 10),
          Text(inquirie.expedient.badFor ?? "Sin registro de malestar"),
          SizedBox(height: 10),
          Text('${inquirie.service}:'),
          SizedBox(height: 10),
          Text('\$${inquirie.baseprice}'),
          SizedBox(height: 10),
          SizedBox(height: 5),
          Text('${inquirie.recetaries.length} medicamentos'),
          SizedBox(height: 5),
          Text('${inquirie.treatments.length} tratamientos'),
          inquirie.type == 'treatment'
              ? FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/inquirie/detail',
                        arguments: inquirie);
                  },
                  child: Text('Ver consulta procedimiento'))
              : Container()
        ],
      ),
    );
  }

  void getInquiries() async {
    var provider = Provider.of<AppProvider>(context, listen: false);

    if (provider.clinic != null) {
      var res = await inquirieService.getInquiriesByClinic(provider.clinic?.id);

      setState(() {
        isLoading = false;
        inquiries = res;
        filteredInquiries = res;
      });
    }
  }
}
