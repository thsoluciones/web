import 'package:expediente_clinico/models/Option.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/providers/option.dart';
import 'package:expediente_clinico/widgets/app/itemGridMenu.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/menus/gridCustom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  AppProvider provider;
  ProviderOption providerOption;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemWidth = size.width / 1;
    provider = Provider.of<AppProvider>(context);
    providerOption = Provider.of<ProviderOption>(context);

    return Scaffold(
      body: Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Header(
            children: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/options/menu'),
                        icon: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ))
                  ],
                ),
                Text(
                  'Bienvenido',
                  style: TextStyle(
                      fontSize: 30,
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
                SizedBox(height: 15),
                Text(
                  provider.clinic?.name ?? 'Sin Clinica seleccionada',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
              child: CustomGridList(
            context: context,
            itemHeight: itemWidth,
            itemWidth: itemWidth,
            builderChildren: Option.options.map((Option value) {
              return ItemGridList(option: value);
            }).toList(),
          ))
        ]),
      ),
    );
  }
}
