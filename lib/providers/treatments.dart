import 'package:expediente_clinico/models/Treatment.dart';
import 'package:flutter/material.dart';

class ProviderTreatment with ChangeNotifier {
  List<Treatment> _treatments = [];

  set treatment(Treatment treatment) {
    _treatments.add(treatment);
    notifyListeners();
  }

  List<Treatment> get treatments => _treatments;

  void clear() {
    _treatments.clear();
  }

  void deleteTreatmentItem(Treatment treatment) {
    _treatments.remove(treatment);
    notifyListeners();
  }
}
