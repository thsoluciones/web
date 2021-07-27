import 'package:expediente_clinico/style.dart';
import 'package:expediente_clinico/widgets/button.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/textfield.dart';
import 'package:flutter/material.dart';

class AddCategorieScreen extends StatefulWidget {
  @override
  _AddCategorieScreenState createState() => _AddCategorieScreenState();
}

class _AddCategorieScreenState extends State<AddCategorieScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(
              children: HeaderOnlyBack(
                headerTitle: 'Añadir categoria',
              ),
            ),
            Container(
              padding: AppStyle.paddingApp,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NOMBRE DE CATEGORIA', style: AppStyle.labelInputStyle),
                  SizedBox(height: 20),
                  categorieField(),
                  SizedBox(height: 20),
                  CustomButton(
                    onPressed: () {},
                    titleButton: 'Añadir',
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget categorieField() => CustomTextField(
        onTap: () {},
        iconOnLeft: null,
        iconOnRight: null,
        value: null,
        controller: null,
        helperText: "",
        keyboardType: TextInputType.text,
        maxLenght: 100,
        onChange: (value) => setState(() => {}),
        hint: 'Nombre',
      );
}
