import 'package:expediente_clinico/models/Treatment.dart';
import 'package:expediente_clinico/providers/treatments.dart';
import 'package:expediente_clinico/style.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewTreatMentsScreen extends StatefulWidget {
  ViewTreatMentsScreen() : super();

  @override
  _ViewTreatMentsScreenState createState() => _ViewTreatMentsScreenState();
}

class _ViewTreatMentsScreenState extends State<ViewTreatMentsScreen> {
   ProviderTreatment providerTreatment;

  @override
  Widget build(BuildContext context) {
    providerTreatment = Provider.of<ProviderTreatment>(context);
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(
              children: HeaderOnlyBack(
                headerTitle: 'Tratamientos',
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: providerTreatment.treatments.length,
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context, int index) {
                  Treatment treatment = providerTreatment.treatments[index];
                  return Container(
                    padding: AppStyle.paddingApp,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('# ${index + 1}'),
                            IconButton(
                                onPressed: () => providerTreatment
                                    .deleteTreatmentItem(treatment),
                                icon: Icon(Icons.delete))
                          ],
                        ),
                        SizedBox(height: 8),
                        Divider(
                          thickness: 2,
                        ),
                        SizedBox(height: 8),
                        Text('Tratamiento: ${treatment.nameTreatment}',
                            style: AppStyle.labelInputStyle),
                        SizedBox(height: 20),
                        Text('Precio: \$${treatment.price}',
                            style: AppStyle.labelInputStyle),
                        SizedBox(height: 20),
                        Text('Indicación:', style: AppStyle.labelInputStyle),
                        SizedBox(height: 20),
                        Text(treatment.description == null
                            ? "Sin descripcion"
                            : treatment.description),
                      ],
                    ),
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
