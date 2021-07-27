import 'package:expediente_clinico/models/Bill.dart';
import 'package:expediente_clinico/services/bill.dart';
import 'package:expediente_clinico/widgets/button.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/textfield.dart';
import 'package:flutter/material.dart';

class ColectiveBill extends StatefulWidget {
  @override
  _ColectiveBillState createState() => _ColectiveBillState();
}

class _ColectiveBillState extends State<ColectiveBill> {
  double addMoney = 0;
  BillService billService = BillService();
  Bill bill;
  int _radioValue = 0;
  @override
  Widget build(BuildContext context) {
    bill = ModalRoute.of(context).settings.arguments;
    print(bill.id);
    return Scaffold(
      body: Column(
        children: [
          Header(
            children: HeaderOnlyBack(
              headerTitle: bill.inquirie.type == 'directly'
                  ? 'Pagar consulta'
                  : 'Abonar consulta',
            ),
          ),
          Expanded(
              child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              SizedBox(height: 15),
              Text('Metodo de pago:'),
              Row(
                children: [
                  Radio(
                    groupValue: _radioValue,
                    onChanged: (dynamic value) {
                      setState(() {
                        _radioValue = value;
                      });
                    },
                    value: 0,
                  ),
                  Text('Tarjeta')
                ],
              ),
              Row(
                children: [
                  Radio(
                    groupValue: _radioValue,
                    onChanged: (dynamic value) {
                      setState(() {
                        _radioValue = value;
                      });
                    },
                    value: 1,
                  ),
                  Text('Efectivo')
                ],
              ),
              bill.inquirie.type == 'directly'
                  ? Container()
                  : CustomTextField(
                      onTap: () {},
                      iconOnLeft: null,
                      iconOnRight: null,
                      value: null,
                      controller: null,
                      helperText: "",
                      maxLenght: 100,
                      keyboardType: TextInputType.number,
                      hint: 'Cantidad a abonar:',
                      onChange: (event) {
                        setState(() {
                          addMoney = double.tryParse(event);
                        });
                      },
                    ),
              SizedBox(height: 15),
              // CustomButton(
              //   onPressed: bill.status == 'Pagado'
              //       ? null
              //       : bill.inquirie.type == 'directly'
              //           ? () => updatePayDirect()
              //           : bill.colective == bill.total
              //               ? null
              //               : () => updateColective(),
              //   titleButton:
              //       bill.inquirie.type == 'directly' ? 'Pagar' : 'Abonar',
              // )
            ],
          ))
        ],
      ),
    );
  }

  void updateColective() async {
    print('hey');
    if (addMoney == null || addMoney <= 0) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('No se pudo abonar'),
              content: Text('Tiene que abonar una cantidad valida'),
            );
          });
    } else {
      String methodPayment = _radioValue == 0 ? 'Tarjeta' : 'Efectivo';
      var res =
          await billService.updateColective(methodPayment, addMoney, bill.id);
      if (res['status']) {
        Navigator.pop(context);
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('No se pudo abonar'),
                content: Text('Hubo un error, intenta luego'),
              );
            });
      }
    }
  }

  void updatePayDirect() async {
    // String methodPayment = _radioValue == 0 ? 'Tarjeta' : 'Efectivo';
    // var res = await billService.updateBill(methodPayment, addMoney, bill.id);
    // if (res['status']) {
    //   Navigator.pop(context);
    // } else {
    //   showDialog(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return AlertDialog(
    //           title: Text('No se pudo abonar'),
    //           content: Text('Hubo un error, intenta luego'),
    //         );
    //       });
    // }
  }
}
