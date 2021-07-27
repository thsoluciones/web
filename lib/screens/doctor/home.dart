import 'package:expediente_clinico/models/Option.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/providers/option.dart';
import 'package:expediente_clinico/style.dart';
import 'package:expediente_clinico/widgets/app/itemGridMenu.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/menus/gridCustom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeDoctor extends StatefulWidget {
  @override
  _HomeDoctorState createState() => _HomeDoctorState();
}

class _HomeDoctorState extends State<HomeDoctor> {
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
      body: Container(
        child: Column(
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child:
                        Text(provider.clinic.name, style: AppStyle.titleHeader),
                  ),
                  SizedBox(height: 20),
                  Text('${provider.fullname} | Doctor',
                      style: AppStyle.subtitleNameHeader)
                ],
              ),
            ),
            Expanded(
              child: CustomGridList(
                context: context,
                itemHeight: itemHeight,
                itemWidth: itemWidth,
                builderChildren: providerOption.optionsStaff
                    .map((Option option) => ItemGridList(option: option))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
