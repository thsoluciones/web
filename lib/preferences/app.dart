import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static SharedPreferences _prefs;

  Future<SharedPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  get instance => _prefs;

  //logged
  set logged(bool status) {
    _prefs.setBool('logged', status);
  }

  bool get logged => _prefs.getBool('logged') ?? false;

  set id(String id) {
    _prefs.setString('id', id);
  }

  String get id => _prefs.getString('id') as String;

  set role(String role) {
    _prefs.setString('role', id);
  }

  String get role => _prefs.getString('role') as String;

  set fullname(String fullname) {
    _prefs.setString('fullname', fullname);
  }

  String get fullname => _prefs.getString('fullname') ?? "";

  set routeHome(String route) {
    _prefs.setString('route', route);
  }

  String get routeHome => _prefs.getString('route') ?? "";

  set email(String email) {
    _prefs.setString('email', email);
  }

  String get email => _prefs.getString('email') ?? "";

  set password(String password) {
    _prefs.setString('pass', password);
  }

  String get password => _prefs.getString('pass') ?? "";

  set remember(bool status) {
    _prefs.setBool('remember', status);
  }

  bool get remember => _prefs.getBool('remember') as bool;
}
