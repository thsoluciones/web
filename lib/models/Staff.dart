import 'package:expediente_clinico/models/Option.dart';

class Staff {
  String id;
  String name;
  String lastname;
  String email;
  String direction;
  String role;
  String clinic;
  String enterprise;
  bool hasPermissionViewClinics;
  List<Option> options;

  Staff(
      {this.id,
      this.name,
      this.lastname,
      this.email,
      this.direction,
      this.role,
      this.clinic,
      this.enterprise,
      this.hasPermissionViewClinics,
      this.options});

  factory Staff.fromJsonResponse(Map<String, dynamic> response) {
    return Staff(
        id: response['_id'],
        name: response['name'],
        lastname: response['lastname'],
        email: response['email'],
        direction: response['direction'],
        role: response['role'],
        clinic: response['clinic'],
        enterprise: response['enterprise'],
        hasPermissionViewClinics: response['hasPermissionViewClinics'],
        options: (response['options'] as List)
            .map((e) => Option.fromJSONResponse(e))
            .toList());
  }
}
