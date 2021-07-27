import 'package:expediente_clinico/models/Expedient.dart';
import 'package:expediente_clinico/providers/app.dart';
import 'package:expediente_clinico/providers/patient.dart';
import 'package:expediente_clinico/services/expedient.dart';
import 'package:expediente_clinico/widgets/alerts/alertTemplate.dart';
import 'package:expediente_clinico/widgets/button.dart';
import 'package:expediente_clinico/widgets/header.dart';
import 'package:expediente_clinico/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPatientScreen extends StatefulWidget {
  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  int age = 0;
  DateTime birthDayDate;
  bool isChild = false;
  bool loading = false;
  AppProvider appProvider;
  TextEditingController birthDateController = TextEditingController();
  ProviderPatient providerPatient;
  Expedient expedient = Expedient();
  ExpedientService service = ExpedientService();

  @override
  Widget build(BuildContext context) {
    providerPatient = Provider.of<ProviderPatient>(context);
    appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Header(
              children: HeaderOnlyBack(
                headerTitle: 'Agregar Paciente',
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                children: [
                  Text('Rellene los campos para completar el formulario.'),
                  SizedBox(height: 20),
                  CustomTextField(
                    hint: 'Nombre del paciente',
                    onChange: (value) {
                      setState(() {
                        expedient.name = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    hint: 'Apellido del paciente',
                    onChange: (value) {
                      setState(() {
                        expedient.lastname = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    hint: 'Direccion de vivienda',
                    onChange: (value) {
                      setState(() {
                        expedient.direction = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  //Fecha de nacimiento
                  CustomTextField(
                    onTap: _pickDateDialog,
                    iconOnRight: Icons.calendar_today,
                    isReadOnly: true,
                    controller: birthDateController,
                    helperText: '$age años',
                    hint: 'Seleccione fecha de nacimiento',
                  ),
                  SizedBox(height: 15),
                  isChild ? formIfPatiendIsChild() : Container(),
                  isChild ? SizedBox(height: 15) : Container(),
                  CustomTextField(
                    hint: 'Lugar de trabajo',
                    onChange: (value) {
                      setState(() {
                        expedient.work = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    hint: 'Email',
                    onChange: (value) {
                      setState(() {
                        expedient.email = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    hint: 'Motivo de la visita',
                    onChange: (value) {
                      setState(() {
                        expedient.whyVisiting = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    hint: 'Es alergico a:',
                    onChange: (value) {
                      setState(() {
                        expedient.badFor = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    controller: null,
                    hint: 'Clinica odontologica que visitaba:',
                    onChange: (value) {
                      setState(() {
                        expedient.medicalLastArchive = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    hint: 'Clinica dental que visitaba:',
                    onChange: (value) {
                      setState(() {
                        expedient.odontologyLastArchive = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    hint: 'Clinica que visitaba:',
                    onChange: (value) {
                      setState(() {
                        expedient.lastClinicVisiting = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    hint: 'Otros:',
                    onChange: (value) {
                      setState(() {
                        expedient.others = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  CustomButton(
                    titleButton: 'Agregar paciente',
                    onPressed: loading ? null : addPatient,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget formIfPatiendIsChild() {
    return Column(
      children: [
        CustomTextField(
          hint: 'Nombre del padre de familia',
          onChange: (value) {
            setState(() {
              expedient.fatherName = value;
            });
          },
        ),
        SizedBox(height: 15),
        CustomTextField(
          hint: 'Nombre de la madre de familia',
          onChange: (value) {
            setState(() {
              expedient.motherName = value;
            });
          },
        ),
        SizedBox(height: 15),
        CustomTextField(
          hint: 'Nombre del responsable/titular',
          onChange: (value) {
            setState(() {
              expedient.tutorName = value;
            });
          },
        ),
        SizedBox(height: 15),
        CustomTextField(
          hint: 'Lugar de estudio',
          onChange: (value) {
            setState(() {
              expedient.school = value;
            });
          },
        )
      ],
    );
  }

  void _pickDateDialog() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1100),
      lastDate: DateTime.now(),
    ) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        birthDayDate = pickedDate;
        birthDateController.text =
            '${birthDayDate.year}-${birthDayDate.month.toString().padLeft(2, '0')}-${birthDayDate.day.toString().padLeft(2, '0')}';
        expedient.dateBirthday =
            '${birthDayDate.year}-${birthDayDate.month.toString().padLeft(2, '0')}-${birthDayDate.day.toString().padLeft(2, '0')}';
        age = DateTime.now().year - birthDayDate.year;
        age > 18 ? isChild = false : isChild = true;
        setState(() {});
      });
    });
  }

  void addPatient() async {
    setState(() {
      loading = true;
    });
    if (expedient.name == null ||
        expedient.name.isEmpty ||
        expedient.lastname == null ||
        expedient.lastname.isEmpty ||
        expedient.direction == null ||
        expedient.direction.isEmpty ||
        birthDayDate == null) {
      setState(() {
        loading = false;
      });
      return requestFields(
          context,
          Text('Error con ingresar paciente'),
          Text(
              'Nombre, apellido, dirección y fecha de nacimiento son necesarios.'));
    }
    if (isChild) {
      expedient.child = {
        'fatherName': expedient.fatherName,
        'motherName': expedient.motherName,
        'tutorName': expedient.tutorName,
        'school': expedient.school,
      };
    }
    expedient.isAChild = isChild;
    expedient.clinic = appProvider.clinic.id;

    var res = await service.addPatient(expedient.form());
    if (res['status']) {
      Navigator.popAndPushNamed(context, appProvider.homeRoute);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('No se puede agregar al paciente'),
            );
          });
    }
  }
}
