import 'package:expediente_clinico/models/Date.dart';
import 'package:flutter/material.dart';

class ProviderDate with ChangeNotifier {
  List<Date> _dates = [];

  set date(Date date) {
    _dates.add(date);
    notifyListeners();
  }

  List<Date> get dates => _dates;
}
