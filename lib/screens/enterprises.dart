import 'package:expediente_clinico/models/Enterprise.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/services/enterprise.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectEnteprise extends StatefulWidget {
  @override
  _SelectEntepriseState createState() => _SelectEntepriseState();
}

class _SelectEntepriseState extends State<SelectEnteprise> {
  @override
  Widget build(BuildContext context) {
    var appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          Header(
            children: HeaderOnlyBack(
              headerTitle: 'Seleccione una empresa',
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                  'Seleccione una empresa para que pueda trabajar con ella. (Datos que requieran de el)')),
          Expanded(
            child: FutureBuilder(
              future: EnterpriseService().getMyEnterprises(appProvider.id),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Enterprise>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      padding: EdgeInsets.all(5),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: () =>
                              appProvider.enterprise = snapshot.data[index],
                          title: Text(snapshot.data[index].name),
                          subtitle: Text(snapshot.data[index].socialReason),
                          trailing: appProvider.enterprise?.id ==
                                  snapshot.data[index].id
                              ? Icon(Icons.check)
                              : null,
                        );
                      });
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
