import 'dart:convert';

import 'package:expediente_clinico/models/Medicine.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/services/medicine.dart';
import 'package:expediente_clinico/widgets/button.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditMedicineScreen extends StatefulWidget {
  @override
  _EditMedicineScreenState createState() => _EditMedicineScreenState();
}

class _EditMedicineScreenState extends State<EditMedicineScreen> {
  AppProvider provider;
  String category;
  String product;
  String stock;
  MedicineService medicineService = MedicineService();
  Medicine medicine;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);
    medicine = ModalRoute.of(context)?.settings.arguments as Medicine;
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(
              children: HeaderOnlyBack(
                headerTitle: 'Agregar Medicina',
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                children: [
                  CustomTextField(
                    iconOnLeft: null,
                    iconOnRight: null,
                    helperText: "",
                    maxLenght: 100,
                    controller: null,
                    value: medicine.category,
                    hint: 'Categoria',
                    keyboardType: TextInputType.text,
                    onChange: (value) {
                      setState(() {
                        medicine.category = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    iconOnLeft: null,
                    iconOnRight: null,
                    helperText: "",
                    maxLenght: 100,
                    controller: null,
                    value: medicine.product,
                    hint: 'Nombre de producto',
                    keyboardType: TextInputType.text,
                    onChange: (value) {
                      setState(() {
                        medicine.product = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    iconOnLeft: null,
                    iconOnRight: null,
                    helperText: "",
                    maxLenght: 100,
                    controller: null,
                    value: medicine.stock,
                    hint: 'stock',
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      setState(() {
                        medicine.stock = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    titleButton: 'Guardar',
                    onPressed: () => editMedicine(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void editMedicine() async {
    var data = jsonEncode({
      "category": medicine.category,
      "product": medicine.product,
      "stock": medicine.stock,
      "clinic": provider.clinic.id
    });
    var res = await medicineService.editMedicine(data, medicine.id);
    if (res['success']) {
      Navigator.popAndPushNamed(context, provider.homeRoute);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('No se puede agregar el medicamento'),
            );
          });
    }
  }
}
