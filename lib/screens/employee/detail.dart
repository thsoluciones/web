import 'package:expediente_clinico/models/Option.dart';
import 'package:expediente_clinico/models/Staff.dart';
import 'package:expediente_clinico/providers/option.dart';
import 'package:expediente_clinico/services/staff.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailEmployeeScreen extends StatefulWidget {
  @override
  _DetailEmployeeScreenState createState() => _DetailEmployeeScreenState();
}

class _DetailEmployeeScreenState extends State<DetailEmployeeScreen> {
   ProviderOption providerOption;
  StaffService service = StaffService();
  @override
  Widget build(BuildContext context) {
    Staff staff = ModalRoute.of(context)?.settings.arguments as Staff;
    providerOption = Provider.of<ProviderOption>(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(
            children: HeaderOnlyBack(
              headerTitle: 'Detalle empleado',
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/employees/pemissions',
                arguments: staff),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: Color(0xff2667ff),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.people, color: Colors.white)),
                  Text('Gestionar Permisos',
                      style: TextStyle(fontSize: 20, color: Colors.white))
                ],
              ),
            ),
          ),
          // GestureDetector(
          //   onTap: ()=> Navigator.pushNamed(context, '/employee/edit', arguments: staff),
          //   child: Container(
          //     margin: EdgeInsets.symmetric(
          //       horizontal: 20,
          //       vertical: 10
          //     ),
          //     padding: EdgeInsets.symmetric(
          //       horizontal: 20,
          //       vertical: 10
          //     ),
          //     decoration: BoxDecoration(
          //       color: Colors.yellow[700],
          //       borderRadius: BorderRadius.circular(5)
          //     ),
          //     child: Row(
          //       children: [
          //         IconButton(onPressed: (){}, icon: Icon(Icons.edit, color: Colors.white)),
          //         Text('Editar', style: TextStyle(
          //           fontSize: 20,
          //           color: Colors.white
          //         ))
          //       ],
          //     ),
          //   ),
          // ),
          GestureDetector(
            onTap: () async {
              var res = await service.deleteStaff(staff.id);
              if (res['success']) {
                Navigator.popAndPushNamed(context, '/admin');
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('No se pudo eliminar al empleado'),
                      );
                    });
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(5)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.delete, color: Colors.white)),
                  Text('Eliminar',
                      style: TextStyle(fontSize: 20, color: Colors.white))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
