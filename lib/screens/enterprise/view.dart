import 'dart:async';

import 'package:expediente_clinico/models/Enterprise.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/services/enterprise.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewEnterprisesScreen extends StatefulWidget {
  @override
  _ViewEnterprisesScreenState createState() => _ViewEnterprisesScreenState();
}

class _ViewEnterprisesScreenState extends State<ViewEnterprisesScreen> {
  EnterpriseService service = EnterpriseService();
   AppProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);
    print(provider.enterpriseOwnerId);
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(
                children: HeaderWithBackAndNext(
              customIcon: Icons.add,
              headerTitle: 'Mis empresas',
              nextRoute: '/enterprise/add',
            )),
            Expanded(
              child: FutureBuilder(
                future: service.getMyEnterprises(provider.role != 'Dueño'
                    ? provider.enterpriseOwnerId
                    : provider.id),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Enterprise>> snapshot) {
                  if (snapshot.hasData) {
                    return listOfEnterprise(snapshot.data);
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
      ),
    );
  }

  Widget listOfEnterprise(List<Enterprise> enterprises) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: enterprises.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () => Navigator.pushNamed(context, '/enterprise/view',
              arguments: enterprises[index]),
          title: Text(enterprises[index].name),
          subtitle: Text(enterprises[index].direction),
        );
      },
    );
  }
}
