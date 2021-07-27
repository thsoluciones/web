import 'package:expediente_clinico/models/Enterprise.dart';
import 'package:expediente_clinico/models/Service.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ListOfServices extends StatefulWidget {
  final ServicesService servicesService;
  Enterprise enterprise;
  String enterpriseId;
  String role;
  ListOfServices(
      {this.role, this.servicesService, this.enterprise, this.enterpriseId});
  @override
  _ListOfServicesState createState() => _ListOfServicesState();
}

class _ListOfServicesState extends State<ListOfServices> {
  AppProvider provider;

  ServicesService servicesService = ServicesService();

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);
    return FutureBuilder(
        future: widget.servicesService.getServicesByEnterprise(
            widget.role == 'Dueño'
                ? widget.enterprise.id
                : widget.enterpriseId),
        builder: (BuildContext context, AsyncSnapshot<List<Service>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return noData();
            } else {
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  print(snapshot.data[index]);
                  Service service = snapshot.data[index];

                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${service.code} ${service.typeOfService}' ??
                            "Sin servicio"),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () => Navigator.pushNamed(
                                    context, '/services/update',
                                    arguments: service),
                                icon: Icon(Icons.edit)),
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
                                                var res = await servicesService
                                                    .deleteService(service.id);

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
                                            'Seguro que quieres eliminar este servicio?'),
                                      );
                                    });
                              },
                            )
                          ],
                        )
                      ],
                    ),
                    subtitle:
                        Text('${service.typeOfTreatment} \$${service.price}'),
                  );
                },
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
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
