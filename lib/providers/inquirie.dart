import 'package:expediente_clinico/models/Inquirie.dart';
import 'package:flutter/material.dart';

class ProviderInquirie with ChangeNotifier {
  List<Inquirie> _inquiries = [];

  set inquirie(Inquirie inquirie) {
    _inquiries.add(inquirie);
    notifyListeners();
  }

  List<Inquirie> get inquiries => _inquiries;
}
