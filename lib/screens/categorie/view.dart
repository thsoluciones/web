import 'package:expediente_clinico/widgets/header.dart';
import 'package:flutter/material.dart';

class ViewCategoriesScreen extends StatefulWidget {
  @override
  _ViewCategoriesScreenState createState() => _ViewCategoriesScreenState();
}

class _ViewCategoriesScreenState extends State<ViewCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(
                children: HeaderWithBackAndNext(
              customIcon: null,
              headerTitle: 'Categorias',
              nextRoute: '/categorie/add',
            ))
          ],
        ),
      ),
    );
  }
}
