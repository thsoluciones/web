import 'package:expediente_clinico/models/Recetary.dart';
import 'package:expediente_clinico/providers/recetary.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListRecetaryScreen extends StatefulWidget {
  @override
  _ListRecetaryScreenState createState() => _ListRecetaryScreenState();
}

class _ListRecetaryScreenState extends State<ListRecetaryScreen> {
  ProviderRecetary providerRecetary;

  @override
  Widget build(BuildContext context) {
    providerRecetary = Provider.of<ProviderRecetary>(context);
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(
              children: HeaderOnlyBack(
                headerTitle: 'Recetarios',
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: providerRecetary.recetaries.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        providerRecetary.deleteRecetaryItem(
                            providerRecetary.recetaries[index]);
                      },
                    ),
                    leading: Icon(Icons.science),
                    title: Text(providerRecetary.recetaries[index].medicine ??
                        'Sin medicina'),
                    subtitle: Text(
                        providerRecetary.recetaries[index].indication ??
                            "Sin indicación"),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
