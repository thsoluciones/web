import 'package:expediente_clinico/models/Option.dart';
import 'package:flutter/material.dart';

class ProviderOption extends ChangeNotifier {
  List<Option> _optionsStaff = [];

  set optionsStaff(List<Option> options) {
    _optionsStaff = options;
    notifyListeners();
  }

  List<Option> get optionsStaff => _optionsStaff;
}
