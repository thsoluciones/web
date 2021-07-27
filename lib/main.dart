//import (screens)
import 'package:expediente_clinico/screens/bill/colective.dart';
import 'package:expediente_clinico/screens/bill/pendinglist.dart';
import 'package:expediente_clinico/screens/enterprises.dart';
import 'package:expediente_clinico/screens/inquirie/detail.dart';
import 'package:expediente_clinico/screens/medicine/edit.dart';
import 'package:expediente_clinico/screens/patient/detail.dart';
import 'package:expediente_clinico/screens/service/edit.dart';
import 'package:expediente_clinico/screens/super-admin/add.owner.dart';
import 'package:expediente_clinico/screens/super-admin/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:expediente_clinico/preferences/app.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/providers/date.dart';
import 'package:expediente_clinico/providers/inquirie.dart';
import 'package:expediente_clinico/providers/option.dart';
import 'package:expediente_clinico/providers/patient.dart';
import 'package:expediente_clinico/providers/recetary.dart';
import 'package:expediente_clinico/providers/treatments.dart';
import 'package:expediente_clinico/screens/auth/login.dart';
import 'package:expediente_clinico/screens/calendar/events.dart';
import 'package:expediente_clinico/screens/calendar/view.dart';
import 'package:expediente_clinico/screens/categorie/add.dart';
import 'package:expediente_clinico/screens/categorie/view.dart';
import 'package:expediente_clinico/screens/date/add.dart';
import 'package:expediente_clinico/screens/date/view.dart';
import 'package:expediente_clinico/screens/doctor/add.dart';
import 'package:expediente_clinico/screens/doctor/home.dart';
import 'package:expediente_clinico/screens/doctor/view.dart';
import 'package:expediente_clinico/screens/employee/add.dart';
import 'package:expediente_clinico/screens/employee/detail.dart';
import 'package:expediente_clinico/screens/employee/permissions.dart';
import 'package:expediente_clinico/screens/employee/view.dart';
import 'package:expediente_clinico/screens/enterprise/detail.dart';
import 'package:expediente_clinico/screens/enterprise/view.dart';
import 'package:expediente_clinico/screens/home.dart';
import 'package:expediente_clinico/screens/inquirie/add.dart';
import 'package:expediente_clinico/screens/inquirie/add.recetary.dart';
import 'package:expediente_clinico/screens/inquirie/add.treatment.dart';
import 'package:expediente_clinico/screens/inquirie/list.dart';
import 'package:expediente_clinico/screens/inquirie/list.recetary.dart';
import 'package:expediente_clinico/screens/inquirie/list.treatment.dart';
import 'package:expediente_clinico/screens/medicine/add.dart';
import 'package:expediente_clinico/screens/medicine/view.dart';
import 'package:expediente_clinico/screens/patient/add.dart';
import 'package:expediente_clinico/screens/patient/view.dart';
import 'package:expediente_clinico/screens/secretary.dart';
import 'package:expediente_clinico/screens/service/add.dart';
import 'package:expediente_clinico/screens/service/view.dart';
import 'package:expediente_clinico/screens/enterprise/home.dart';
import 'package:expediente_clinico/screens/setting/view.dart';
import 'package:expediente_clinico/screens/staff/edit.dart';
import 'package:expediente_clinico/screens/store/add.dart';
import 'package:expediente_clinico/screens/store/view.dart';
import 'package:expediente_clinico/screens/enterprise/add.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AppPreferences preferences = AppPreferences();
  await preferences.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppPreferences prefs = AppPreferences();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppProvider()),
          ChangeNotifierProvider(create: (_) => ProviderTreatment()),
          ChangeNotifierProvider(create: (_) => ProviderRecetary()),
          ChangeNotifierProvider(create: (_) => ProviderInquirie()),
          ChangeNotifierProvider(create: (_) => ProviderPatient()),
          ChangeNotifierProvider(create: (_) => ProviderDate()),
          ChangeNotifierProvider(create: (_) => ProviderOption())
        ],
        child: MaterialApp(
          title: 'Material App',
          initialRoute: '/',
          routes: {
            //flutter register the screen as first screen history
            '/': (BuildContext context) => Login(),
            '/super-admin': (BuildContext context) => SuperAdminScreen(),
            '/super-admin/add/owner': (BuildContext context) =>
                AddOwnerScreen(),
            '/options/menu': (BuildContext context) => SettingsScreen(),

            //admin
            '/admin': (BuildContext context) => HomeScreen(),
            '/enterprise/view/all': (BuildContext context) =>
                ViewEnterprisesScreen(),

            '/select/enterprise': (BuildContext context) => SelectEnteprise(),
            '/enterprise/view': (BuildContext context) => DetailEnterprise(),
            '/enterprise/add': (BuildContext context) => AddEnterprise(),
            '/employees/all': (BuildContext context) => ViewEmployeesScreen(),
            '/employee/edit': (BuildContext context) => EditStaffScreen(),
            '/employees/detail': (BuildContext context) =>
                DetailEmployeeScreen(),
            '/employees/pemissions': (BuildContext context) =>
                PermissionsEmployeeScreen(),
            '/employees/add': (BuildContext context) => AddEmployeeScreen(),
            '/store/all': (BuildContext context) => ViewStores(),
            '/store/add': (BuildContext context) => AddStoreScreen(),
            //doctor
            '/doctor/home': (BuildContext context) => HomeDoctor(),
            '/patient/all': (BuildContext context) => ViewPatientsScreen(),
            '/patient/detail': (BuildContext context) => DetailPatientScreen(),
            '/patient/add': (BuildContext context) => AddPatientScreen(),
            '/inquirie/all': (BuildContext context) => ViewInquiriesScreen(),
            '/inquirie/detail': (BuildContext context) => DetailInquirie(),
            '/inquirie/add': (BuildContext context) => AddInquirieScreen(),
            '/inquirie/treatment/all': (BuildContext context) =>
                ViewTreatMentsScreen(),
            '/inquirie/treatment/add': (BuildContext context) =>
                AddTreatmentScreen(),
            '/inquirie/recetary/all': (BuildContext context) =>
                ListRecetaryScreen(),
            '/inquirie/recetary/add': (BuildContext context) =>
                AddRecetaryScreen(),
            '/dates/all': (BuildContext context) => ViewDatesScreen(),
            '/dates/add': (BuildContext context) => AddDateScreen(),
            '/calendar/view': (BuildContext context) =>
                CalendarForDoctorScreen(),
            '/calendar/view/dates': (BuildContext context) => ViewDates(),
            //secretaria
            '/secretary/home': (BuildContext context) => SecretaryHome(),
            '/secretary/inquiries/pending': (BuildContext context) =>
                PendingListInquiries(),
            //encargado
            '/enterprise/detail': (BuildContext context) =>
                HomeEnterpriseScreen(),
            '/doctors/all': (BuildContext context) => DoctorsScreen(),
            '/doctors/add': (BuildContext context) => AddDoctorScreen(),
            '/services/all': (BuildContext context) => ViewServicesScreen(),
            '/services/add': (BuildContext context) => AddServiceScreen(),
            '/services/update': (BuildContext context) => EditServiceScreen(),
            '/medicine/all': (BuildContext context) => ViewMedicineScreen(),
            '/medicine/add': (BuildContext context) => AddMedicineScreen(),
            '/medicine/update': (BuildContext context) => EditMedicineScreen(),
            '/categorie/all': (BuildContext context) => ViewCategoriesScreen(),
            '/categorie/add': (BuildContext context) => AddCategorieScreen(),
            '/bill/colective': (BuildContext context) => ColectiveBill()
          },
        ));
  }
}
