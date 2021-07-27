import 'package:expediente_clinico/models/Medicine.dart';
import 'package:expediente_clinico/models/Recetary.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/providers/recetary.dart';
import 'package:expediente_clinico/services/medicine.dart';
import 'package:expediente_clinico/widgets/button.dart';
import 'package:expediente_clinico/widgets/dropdown.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddRecetaryScreen extends StatefulWidget {
  @override
  _AddRecetaryScreenState createState() => _AddRecetaryScreenState();
}

class _AddRecetaryScreenState extends State<AddRecetaryScreen> {
  Recetary recetary = Recetary();
  ProviderRecetary providerRecetary;
  Medicine selectedMedicine;
  MedicineService medicineService = MedicineService();
  AppProvider appProvider = AppProvider();

  @override
  Widget build(BuildContext context) {
    providerRecetary = Provider.of<ProviderRecetary>(context);
    appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(
              children: HeaderOnlyBack(
                headerTitle: 'Agregar recetario',
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                children: [
                  comboMedicines(),
                  SizedBox(height: 20),
                  CustomTextField(
                    keyboardType: TextInputType.number,
                    hint: 'Cantidad de receta',
                    onChange: (value) {
                      setState(() {
                        recetary.count = value;
                      });
                    },
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
                        hintText: "Indicación de receta"),
                    onChanged: (value) {
                      setState(() {
                        recetary.indication = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    titleButton: 'Agregar',
                    onPressed: addMedicine,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget comboMedicines() => Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.5, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
      child: FutureBuilder(
        future: medicineService.getMedicinesByEnterprise(
            appProvider.role == 'Dueño'
                ? appProvider.enterprise.id
                : appProvider.enterpriseIdFrom),
        builder:
            (BuildContext context, AsyncSnapshot<List<Medicine>> snapshot) {
          if (snapshot.hasData) {
            return CustomDropDown(
              hintText: selectedMedicine == null
                  ? 'Seleccione un medicamento'
                  : '${selectedMedicine.product} - ${selectedMedicine.stock}',
              //actualValue: selectedMedicine,
              onChange: (value) {
                setState(() {
                  print(value);
                  setState(() {
                    selectedMedicine = value;
                  });
                });
              },
              children: snapshot.data
                  .map((e) => DropdownMenuItem(
                      value: e, child: Text('${e.product} - ${e.stock}')))
                  .toList(),
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator()],
            );
          }
        },
      ));

  void addMedicine() {
    recetary.medicine = selectedMedicine.product;
    providerRecetary.recetary = recetary;
    Navigator.pop(context);
  }
}
