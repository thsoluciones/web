import 'package:expediente_clinico/models/Option.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/providers/option.dart';
import 'package:expediente_clinico/widgets/app/itemGridMenu.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/menus/gridCustom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecretaryHome extends StatefulWidget {
  @override
  _SecretaryHomeState createState() => _SecretaryHomeState();
}

class _SecretaryHomeState extends State<SecretaryHome> {
  AppProvider provider;
  ProviderOption providerOption;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context);
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 1;
    providerOption = Provider.of<ProviderOption>(context);
    return Scaffold(
      body: Column(
        children: [
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
                        icon: Icon(Icons.settings, color: Colors.white))
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
                  '${provider.fullname} | ${provider.role}',
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
            builderChildren: providerOption.optionsStaff.map((Option value) {
              return ItemGridList(option: value);
            }).toList(),
          ))
        ],
      ),
    );
  }
}
