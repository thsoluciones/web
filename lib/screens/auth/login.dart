import 'package:expediente_clinico/models/Clinic.dart';
import 'package:expediente_clinico/models/Enterprise.dart';
import 'package:expediente_clinico/models/Option.dart';
import 'package:expediente_clinico/models/User.dart';
import 'package:expediente_clinico/preferences/app.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/providers/option.dart';
import 'package:expediente_clinico/services/auth.dart';
import 'package:expediente_clinico/widgets/button.dart';
import 'package:expediente_clinico/widgets/checkbox.dart';
import 'package:expediente_clinico/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AppProvider provider;
  ProviderOption providerOption;
  AuthService service = AuthService();
  AppPreferences preferences = AppPreferences();
  bool isLoading = false;
  String email = "";
  String password = "";
  bool rememberMe = true;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      rememberMe = preferences.logged;
      email = preferences.email;
      password = preferences.password;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppProvider>(context, listen: true);
    providerOption = Provider.of<ProviderOption>(context, listen: true);
    return Scaffold(
        body: PageView(
      onPageChanged: (int value) {
        FocusScope.of(context).unfocus();
      },
      children: [initPage(), loginScreen()],
    ));
  }

  Widget initPage() {
    return Container(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: Image(
              fit: BoxFit.cover,
              image: AssetImage('assets/background-doctor.jpeg'),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
            child: Container(
              color: Color(0xff2667ff).withOpacity(0.8),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text('Expediente Clinico',
                    style: TextStyle(fontSize: 25, color: Colors.white)),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.30),
                  child: Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget loginScreen() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    child: Image(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/login-cover.jpeg'),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      height: 225,
                      color: Color(0xff2667ff).withOpacity(0.5),
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 40, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Iniciar Sesión',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w600)),
                  SizedBox(height: 15),
                  Text('Complete los campos para iniciar sesión',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue[600],
                      )),
                  SizedBox(height: 30),
                  CustomTextField(
                    onTap: () {},
                    iconOnLeft: null,
                    iconOnRight: null,
                    value: null,
                    controller: null,
                    keyboardType: TextInputType.text,
                    hint: 'correo',
                    onChange: (value) => setState(() => email = value),
                  ),
                  SizedBox(height: 30),
                  CustomTextField(
                    onTap: () {},
                    iconOnLeft: null,
                    iconOnRight: null,
                    value: null,
                    controller: null,
                    keyboardType: TextInputType.text,
                    needHideText: true,
                    hint: 'contraseña',
                    onChange: (value) => setState(() => password = value),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      CustomCheckBox(
                        selected: rememberMe,
                        onChange: () =>
                            {setState(() => rememberMe = !rememberMe)},
                      ),
                      SizedBox(width: 15),
                      Text('Recuerdame')
                    ],
                  ),
                  SizedBox(height: 30),
                  CustomButton(
                    titleButton: 'Loguearme',
                    onPressed: isLoading ? null : () => login(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void login() async {
    try {
      setState(() => isLoading = true);
      if (email.isEmpty || password.isEmpty) {
        setState(() => isLoading = false);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Rellene los datos para inicar sesión'),
              );
            });
      } else {
        var res = await service.login(username: email, password: password);

        if (res['success']) {
          if (rememberMe) {
            preferences.password = password;
            preferences.email = email;
            preferences.remember = rememberMe;
          }

          preferences.logged = true;
          provider.id = res['user']['_id'];
          provider.email = res['user']['email'];
          provider.role = res['user']['role'];
          provider.fullname =
              '${res['user']['name']} ${res['user']['lastname']}';

          if (res['user']['role'] == 'Dueño') {
            provider.homeRoute = "/admin";
            preferences.routeHome = "/admin";
            Navigator.pushReplacementNamed(context, '/admin');
          } else if (res['user']['role'] == 'super-admin') {
            provider.homeRoute = "/super-admin";
            preferences.routeHome = "/super-admin";
            //admin role
            Navigator.pushReplacementNamed(context, '/super-admin');
          } else if (res['user']['role'] == 'Doctor') {
            // provider.enterprise =
            //     Enterprise.fromJsonResponse(res['user']['enterprise']);
            providerOption.optionsStaff = (res['user']['options'] as List)
                .map((e) => Option.fromJSONResponse(e))
                .toList();
            provider.homeRoute = "/doctor/home";
            preferences.routeHome = "/doctor/home";
            provider.clinic = Clinic.fromJsonResponse(res['user']['clinic']);
            provider.enterpriseIdFrom = res['user']['enterprise']['_id'];
            provider.enterpriseOwnerId = res['user']['enterprise']['doctor'];
            Navigator.pushReplacementNamed(context, '/doctor/home');
          } else if (res['user']['role'] == 'Secretaria') {
            provider.enterprise =
                Enterprise.fromJsonResponse(res['user']['enterprise']);
            providerOption.optionsStaff = (res['user']['options'] as List)
                .map((e) => Option.fromJSONResponse(e))
                .toList();
            provider.homeRoute = "/secretary/home";
            preferences.routeHome = "/secretary/home";
            provider.clinic = Clinic.fromJsonResponse(res['user']['clinic']);
            provider.enterpriseIdFrom = res['user']['enterprise']['_id'];
            provider.enterpriseOwnerId = res['user']['enterprise']['doctor'];
            Navigator.pushReplacementNamed(context, '/secretary/home');
          } else {
            // provider.enterprise =
            //     Enterprise.fromJsonResponse(res['user']['enterprise']);
            providerOption.optionsStaff = (res['user']['options'] as List)
                .map((e) => Option.fromJSONResponse(e))
                .toList();
            provider.homeRoute = "/enterprise/detail";
            preferences.routeHome = "/enterprise/detail";
            provider.clinic = Clinic.fromJsonResponse(res['user']['clinic']);
            provider.enterpriseIdFrom = res['user']['enterprise']['_id'];
            provider.enterpriseOwnerId = res['user']['enterprise']['doctor'];
            Navigator.pushReplacementNamed(context, '/enterprise/detail');
          }
        } else {
          setState(() => isLoading = false);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text(
                      'No hemos encontrado al usuario en nuestros registros.'),
                );
              });
        }
      }
    } catch (e) {
      setState(() {
        print(e);
        isLoading = false;
      });
    }
  }
}
