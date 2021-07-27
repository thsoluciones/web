import 'package:expediente_clinico/models/Expedient.dart';
import 'package:flutter/material.dart';

class ProviderPatient with ChangeNotifier {
  List<Expedient> _patients = [];

  set patient(Expedient patient) {
    _patients.add(patient);
    notifyListeners();
  }

  List<Expedient> get patients => _patients;
}
