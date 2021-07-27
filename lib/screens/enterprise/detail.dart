import 'dart:convert';

import 'package:expediente_clinico/models/Clinic.dart';
import 'package:expediente_clinico/models/Enterprise.dart';
import 'package:expediente_clinico/screens/enterprise/list.clinics.dart';
import 'package:expediente_clinico/services/clinic.dart';
import 'package:expediente_clinico/services/enterprise.dart';
import 'package:expediente_clinico/widgets/alerts/alertTemplate.dart';
import 'package:expediente_clinico/widgets/button.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/textfield.dart';
import 'package:flutter/material.dart';

class DetailEnterprise extends StatefulWidget {
  @override
  _DetailEnterpriseState createState() => _DetailEnterpriseState();
}

class _DetailEnterpriseState extends State<DetailEnterprise>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  TabController _controller;

  String name;
  String direction;

  Enterprise enterprise;

  ClinicService clinicService = ClinicService();
  EnterpriseService enterpriseService = EnterpriseService();

  bool loading = false;

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
    enterprise = ModalRoute.of(context)?.settings.arguments as Enterprise;
    return Scaffold(
      body: Column(
        children: [
          Header(
            children: HeaderOnlyBack(
              headerTitle: enterprise.name,
            ),
          ),
          SizedBox(height: 10),
          tabController(),
          Expanded(
            child: tabBarView(),
          )
        ],
      ),
    );
  }

  Widget tabController() {
    return DefaultTabController(
      length: 2,
      child: TabBar(
        controller: _controller,
        indicatorColor: Color(0xff4361ee),
        unselectedLabelColor: Colors.grey[400],
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 2,
        labelPadding: EdgeInsets.symmetric(vertical: 10),
        labelColor: Color(0xff4361ee),
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        tabs: [
          Column(
            children: [
              Text('Clinicas'),
              SizedBox(height: 5),
            ],
          ),
          Column(
            children: [
              Text('Añadir clinica'),
              SizedBox(height: 5),
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
        ListOfClinics(
            enterpriseService: enterpriseService, enteprise: enterprise),
        formClinic()
      ],
    );
  }

  Widget formClinic() {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      children: [
        Text('Rellene los campos.',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500])),
        SizedBox(height: 20),
        CustomTextField(
          hint: 'Nombre',
          onChange: (event) {
            setState(() {
              name = event;
            });
          },
        ),
        SizedBox(height: 20),
        CustomTextField(
          hint: 'dirección',
          onChange: (event) {
            setState(() {
              direction = event;
            });
          },
        ),
        SizedBox(height: 20),
        CustomButton(
          titleButton: 'Guardar',
          onPressed: loading ? null : () => addClinic(),
        )
      ],
    );
  }

  void addClinic() async {
    setState(() {
      loading = true;
    });

    if (name == null ||
        name.isEmpty ||
        direction == null ||
        direction.isEmpty) {
      setState(() {
        loading = false;
      });
      return requestFields(
          context, Text('Error al ingresar'), Text('Rellene los campos'));
    }

    var data = jsonEncode(
        {'name': name, 'direction': direction, 'enterprise': enterprise.id});

    var res = await clinicService.addClinic(data);

    if (res['success']) {
      _controller.index = 0;
      FocusScope.of(context).unfocus();
      name = "";
      direction = "";
      setState(() {});
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('No se pudo añadir la clinica'),
            );
          });
    }
  }
}
