import 'package:expediente_clinico/models/Clinic.dart';
import 'package:expediente_clinico/models/Enterprise.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  String _userId = "";
  String _email = "";
  String _role = "";
  String _fullName = "";
  Clinic _clinic;
  String _homeRoute = "";
  String _enterpriseOwnerId = "";
  String _enterpriseId = "";
  Enterprise _enterprise;

  set id(String value) {
    _userId = value;
    notifyListeners();
  }

  String get id => _userId;

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  String get email => _email;

  set role(String value) {
    _role = value;
    notifyListeners();
  }

  String get role => _role;

  set fullname(String value) {
    _fullName = value;
    notifyListeners();
  }

  String get fullname => _fullName;

  set clinic(Clinic clinic) {
    _clinic = clinic;
    notifyListeners();
  }

  Clinic get clinic => _clinic;

  set homeRoute(String route) {
    _homeRoute = route;
    notifyListeners();
  }

  String get homeRoute => _homeRoute;

  //owner id
  set enterpriseOwnerId(String enterpriseId) {
    _enterpriseOwnerId = enterpriseId;
    notifyListeners();
  }

  String get enterpriseOwnerId => _enterpriseOwnerId;

  //enterprise id from staff
  set enterpriseIdFrom(String id) {
    _enterpriseId = id;
    notifyListeners();
  }

  String get enterpriseIdFrom => _enterpriseId;

  set enterprise(Enterprise enterprise) {
    _enterprise = enterprise;
    notifyListeners();
  }

  Enterprise get enterprise => _enterprise;
}
