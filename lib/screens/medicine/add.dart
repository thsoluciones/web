import 'dart:convert';

import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/services/medicine.dart';
import 'package:expediente_clinico/widgets/button.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddMedicineScreen extends StatefulWidget {
  @override
  _AddMedicineScreenState createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  AppProvider provider;
  String category;
  String product;
  String stock;
  MedicineService medicineService = MedicineService();
  bool isLoadingRequest = false;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);
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
                    hint: 'Categoria',
                    keyboardType: TextInputType.text,
                    onChange: (value) {
                      setState(() {
                        category = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    hint: 'Nombre de producto',
                    keyboardType: TextInputType.text,
                    onChange: (value) {
                      setState(() {
                        product = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    hint: 'stock',
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      setState(() {
                        stock = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    titleButton: 'Guardar',
                    onPressed: isLoadingRequest ? null : () => addMedicine(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addMedicine() async {
    setState(() {
      isLoadingRequest = true;
    });
    if (category != null &&
        product != null &&
        stock != null &&
        int.parse(stock) > 0) {
      var data = jsonEncode({
        "category": category,
        "product": product,
        "stock": stock,
        "enterprise": provider.role == 'Dueño'
            ? provider.enterprise.id
            : provider.enterpriseIdFrom
      });
      var res = await medicineService.addMedicine(data);
      if (res['success']) {
        Navigator.popAndPushNamed(context, provider.homeRoute);
      } else {
        setState(() {
          isLoadingRequest = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text('No se puede agregar el medicamento'),
              );
            });
      }
    } else {
      setState(() {
        isLoadingRequest = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Complete los datos o rellene bien los datos'),
            );
          });
    }
  }
}
