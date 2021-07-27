import 'package:expediente_clinico/models/Date.dart';
import 'package:expediente_clinico/models/Staff.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/services/date.dart';
import 'package:expediente_clinico/services/staff.dart';
import 'package:expediente_clinico/widgets/dropdown.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarForDoctorScreen extends StatefulWidget {
  @override
  _CalendarForDoctorScreenState createState() =>
      _CalendarForDoctorScreenState();
}

class _CalendarForDoctorScreenState extends State<CalendarForDoctorScreen> {
  AppProvider appProvider;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;

  List<Date> dates = [];
  List<Date> selectedEvents = [];

  bool isLoading = true;

  bool isLoadingDoctors = true;

  Staff selectedStaff;

  List<Staff> staffList = [];

  StaffService staffService = StaffService();

  @override
  void initState() {
    var appProvider = Provider.of<AppProvider>(context, listen: false);

    if (appProvider.clinic?.id != null) {
      getDatesByClinic(appProvider.clinic.id);
      getStaff();
    }
    // TODO: implement initState
    super.initState();
  }

  void getStaff() async {
    appProvider = Provider.of<AppProvider>(context, listen: false);
    var res =
        await staffService.getStaffByEnteprise(appProvider.clinic.enterprise);
    setState(() {
      isLoadingDoctors = false;
      staffList = res.where((element) => element.role == 'Doctor').toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(
              children: appProvider.clinic?.id == null
                  ? HeaderOnlyBack(
                      headerTitle: 'Calendario',
                    )
                  : HeaderOnlyBack(
                      headerTitle: 'Calendario',
                    ),
            ),
            appProvider.role != 'Doctor'
                ? appProvider.clinic == null
                    ? Container()
                    : isLoadingDoctors
                        ? Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: CustomDropDown(
                              hintText: 'Seleccione un doctor',
                              actualValue: selectedStaff,
                              children: staffList
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.name),
                                      ))
                                  .toList(),
                              onChange: (value) {
                                setState(() {
                                  selectedStaff = value;
                                });
                              },
                            ),
                          )
                : Container(),
            appProvider.role != 'Doctor'
                ? appProvider.clinic == null
                    ? Container()
                    : Text(selectedStaff == null
                        ? 'Todas las citas'
                        : 'Citas de: ${selectedStaff.name} ${selectedStaff.lastname}')
                : Container(),
            appProvider.clinic?.id == null
                ? Expanded(
                    child: Center(
                      child: Text(
                          'Has entrado como dueño ve a empresas, entra a una y en tus clinicas selecciona una clinica con la que quisieras ver información.',
                          textAlign: TextAlign.center),
                    ),
                  )
                : isLoading
                    ? Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : TableCalendar(
                        eventLoader: (day) => appProvider.role == 'Doctor'
                            ? getEventsByDoctor(day)
                            : selectedStaff == null
                                ? getEvents(day)
                                : getEventsBySelectedDoctor(day),
                        firstDay: DateTime.utc(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: _focusedDay,
                        onDaySelected: (selectedDay, focusedDay) {
                          getEventsByDay(selectedDay);
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay =
                                focusedDay; // update `_focusedDay` here as well
                          });
                        },
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                      ),
            selectedEvents.length > 0
                ? Expanded(
                    child: ListView.builder(
                      itemCount: selectedEvents.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(selectedEvents[index].doctor.name),
                          subtitle: Text(
                              'Paciente: ${selectedEvents[index].patient.name} - Hora:${selectedEvents[index].hour}'),
                        );
                      },
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  List<Date> getEvents(DateTime date) {
    return dates
        .where(
            (dayIterator) => date.day == DateTime.parse(dayIterator.date).day)
        .toList();
  }

  List<Date> getEventsBySelectedDoctor(DateTime date) {
    return dates
        .where((dayIterator) =>
            date.day == DateTime.parse(dayIterator.date).day &&
            dayIterator.doctor.id == selectedStaff.id)
        .toList();
  }

  List<Date> getEventsByDoctor(DateTime date) {
    return dates
        .where((dayIterator) =>
            date.day == DateTime.parse(dayIterator.date).day &&
            dayIterator.doctor.id == appProvider.id)
        .toList();
  }

  void getEventsByDay(DateTime calendarDate) {
    selectedEvents = dates
        .where((dayIterator) =>
            calendarDate.day == DateTime.parse(dayIterator.date).day)
        .toList();

    setState(() {});
  }

  void getDatesByClinic(String idClinic) async {
    List<Date> list =
        await DateService().getDatesByClinic(idClinic) as List<Date>;
    setState(() {
      isLoading = false;
      dates = list;
    });
  }
}
