import 'package:expediente_clinico/models/Option.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/providers/option.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/menus/gridCustom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeEnterpriseScreen extends StatefulWidget {
  @override
  _HomeEnterpriseScreenState createState() => _HomeEnterpriseScreenState();
}

class _HomeEnterpriseScreenState extends State<HomeEnterpriseScreen> {
  ProviderOption providerOption;
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 1;
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
                        icon: Icon(Icons.settings, color: Colors.white))
                  ],
                ),
                Text(
                  provider.clinic.name,
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
            itemHeight: itemHeight,
            itemWidth: itemWidth,
            builderChildren: providerOption.optionsStaff.map((Option value) {
              return itemGrid(value);
            }).toList(),
          ) //gridList(itemWidth, itemHeight)
              )
        ]),
      ),
    );
  }

  Widget gridList(double itemWidth, double itemHeight) => GridView.count(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        crossAxisCount: 2,
        childAspectRatio: (itemWidth / itemHeight),
        controller: ScrollController(keepScrollOffset: false),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          Option(id: 1, option: 'hey', route: '/hey', icon: Icons.ac_unit)
        ].map((Option value) {
          return itemGrid(value);
        }).toList(),
      );

  Widget itemGrid(Option value) => GestureDetector(
        onTap: () => Navigator.pushNamed(context, value.route),
        child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color(0xff2667ff),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[400])),
            margin: EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.blue[900]?.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(10),
                  child: Icon(value.icon, size: 40, color: Colors.white),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    value.option,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                )
              ],
            )),
      );
}
