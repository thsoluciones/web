import 'package:expediente_clinico/models/User.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/utils/api.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SuperAdminScreen extends StatefulWidget {
  @override
  _SuperAdminScreenState createState() => _SuperAdminScreenState();
}

class _SuperAdminScreenState extends State<SuperAdminScreen> {
  AppProvider provider;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);
    return Scaffold(
        body: Container(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Header(
          children: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () => Navigator.pushNamed(
                          context, '/super-admin/add/owner'),
                      icon: Icon(
                        Icons.people_alt,
                        color: Colors.white,
                      )),
                  IconButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/options/menu'),
                      icon: Icon(
                        Icons.settings,
                        color: Colors.white,
                      )),
                ],
              ),
              Text(
                'Bienvenido',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                'Super admin',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 15),
              Text(
                provider.fullname,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 15, top: 10),
          child: Text('Dueños',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 10),
        Expanded(
            child: FutureBuilder(
          future: getOwners(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: (snapshot.data as List<User>).length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(snapshot.data[index].fullName),
                    subtitle: Text(
                        'No de empresas: ${snapshot.data[index].enterprises.length}'),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ))
      ],
    )));
  }

  Future<List<User>> getOwners() async {
    List<User> users = [];

    try {
      Response response = await Dio().get("$BASE_URL/auth/all");

      List<dynamic> res = response.data['doctor'];

      res.forEach((element) {
        users.add(User.fromJsonResponse(element));
      });
    } catch (e) {
      print(e);
    }

    return users.where((element) => element.role == "Dueño").toList();
  }
}
