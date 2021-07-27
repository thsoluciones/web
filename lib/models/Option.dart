import 'package:flutter/material.dart';

class Option {
  int id;
  String option;
  IconData icon;
  String route;
  Widget screen;

  Option({this.id, this.option, this.icon, this.route});

  factory Option.fromJSONResponse(Map<String, dynamic> response) {
    return Option(
        id: response['id'] as int,
        option: response['option'],
        icon: IconData(response['icon'], fontFamily: 'MaterialIcons'),
        route: response['route'] ?? response['route']);
  }
  static List<Option> get generalOptions => [
        Option(
            id: 5,
            option: 'Pacientes',
            icon: Icons.people,
            route: '/patient/all'),
        Option(
            id: 6,
            option: 'Consulta',
            icon: Icons.article,
            route: '/inquirie/all'),
        Option(id: 7, option: 'Citas', icon: Icons.book, route: '/dates/all'),
        Option(
            id: 8,
            option: 'Calendario',
            icon: Icons.calendar_today,
            route: '/calendar/view'),
        // Option(
        //   id: 9,
        //   option: "Doctores",
        //   icon: Icons.person_pin_circle,
        //   route: '/doctors/all'
        // ),
        Option(
            id: 1,
            option: "Empresas",
            icon: Icons.business_outlined,
            route: '/enterprise/view/all'),
        Option(
            id: 10,
            option: "Servicios",
            icon: Icons.build,
            route: '/services/all'),
        Option(
            id: 2,
            option: "Empleados",
            icon: Icons.people,
            route: '/employees/all'),
        Option(
            id: 11,
            option: "Medicamentos",
            icon: Icons.medical_services,
            route: '/medicine/all'),
        // Option(
        //   id: 12,
        //   option: "Categoria de medicamentos",
        //   icon: Icons.medical_services,
        //   route: '/categorie/all'
        // ),
        // Option(
        //   id: 13,
        //   option: "Gestión de citas",
        //   icon: Icons.book
        // ),
        Option(
            id: 14,
            option: "Facturación",
            icon: Icons.book,
            route: '/secretary/inquiries/pending'),
        // Option(
        //   id: 3,
        //   option: "Gestión de personal",
        //   icon: Icons.build
        // ),
        // Option(
        //   id: 4,
        //   option: "Estadisticas",
        //   icon: Icons.trending_up
        // ),
      ];

  static List<Option> get options => [
        Option(
            id: 1,
            option: "Empresas",
            icon: Icons.business_outlined,
            route: '/enterprise/view/all'),
        Option(
            id: 2,
            option: "Seleccionar empresa",
            icon: Icons.business_outlined,
            route: '/select/enterprise'),
        Option(
            id: 3,
            option: "Empleados",
            icon: Icons.people,
            route: '/employees/all'),
        Option(
            id: 4,
            option: 'Pacientes',
            icon: Icons.people,
            route: '/patient/all'),
        Option(
            id: 5,
            option: 'Consulta',
            icon: Icons.article,
            route: '/inquirie/all'),
        Option(id: 6, option: 'Citas', icon: Icons.book, route: '/dates/all'),
        Option(
            id: 7,
            option: 'Calendario',
            icon: Icons.calendar_today,
            route: '/calendar/view'),
        // Option(
        //   id: 9,
        //   option: "Doctores",
        //   icon: Icons.person_pin_circle,
        //   route: '/doctors/all'
        // ),
        Option(
            id: 8,
            option: "Servicios",
            icon: Icons.build,
            route: '/services/all'),
        Option(
            id: 9,
            option: "Medicamentos",
            icon: Icons.medical_services,
            route: '/medicine/all'),
        // Option(
        //   id: 12,
        //   option: "Categoria de medicamentos",
        //   icon: Icons.medical_services,
        //   route: '/categorie/all'
        // ),
        // Option(
        //   id: 13,
        //   option: "Gestión de citas",
        //   icon: Icons.book
        // ),
        Option(
            id: 10,
            option: "Facturación",
            icon: Icons.book,
            route: '/secretary/inquiries/pending'),
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'option': this.option,
      'icon': this.icon.codePoint,
      'route': this.route
    };
  }
}
