import 'package:expediente_clinico/models/Medicine.dart';
import 'package:expediente_clinico/services/medicine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListOfMedicine extends StatefulWidget {
  final MedicineService medicineService;
  final String idClinic;
  final String enterpriseId;
  final String role;
  ListOfMedicine(
      {this.role, this.enterpriseId, this.medicineService, this.idClinic});
  @override
  _ListOfMedicineState createState() => _ListOfMedicineState();
}

class _ListOfMedicineState extends State<ListOfMedicine> {
  MedicineService medicineService = MedicineService();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.medicineService.getMedicinesByEnterprise(
          widget.role == 'Dueño' ? widget.idClinic : widget.enterpriseId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return noData();
          } else {
            return ListView.builder(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                ),
                itemCount: (snapshot.data as List<Medicine>).length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(snapshot.data[index].product),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pushNamed(
                                  context, '/medicine/update',
                                  arguments: snapshot.data[index]),
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        actions: [
                                          FlatButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Cancelar')),
                                          FlatButton(
                                              onPressed: () async {
                                                var res = await medicineService
                                                    .deleteMedicine(snapshot
                                                        .data[index].id);

                                                if (res['success']) {
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                } else {
                                                  Navigator.pop(context);
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text('Error'),
                                                          content: Text(
                                                              'No se pudo eliminar el servicio'),
                                                        );
                                                      });
                                                }
                                              },
                                              child: Text('Si, eliminar'))
                                        ],
                                        title: Text(
                                            'Seguro que quieres eliminar este medicamento?'),
                                      );
                                    });
                              },
                            )
                          ],
                        )
                      ],
                    ),
                    subtitle: Text('Stock: ${snapshot.data[index].stock}'),
                  );
                });
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
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
}
