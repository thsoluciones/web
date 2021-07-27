import 'package:expediente_clinico/models/Recetary.dart';
import 'package:flutter/material.dart';

class ProviderRecetary with ChangeNotifier {
  List<Recetary> _recetaries = [];

  set recetary(Recetary recetary) {
    _recetaries.add(recetary);
    notifyListeners();
  }

  List<Recetary> get recetaries => _recetaries;

  void clear() {
    _recetaries.clear();
    notifyListeners();
  }

  void deleteRecetaryItem(Recetary recetary) {
    _recetaries.remove(recetary);
    notifyListeners();
  }
}
