import 'package:expediente_clinico/models/Clinic.dart';

class Enterprise {
  String id;
  String name;
  String socialReason;
  String direction;
  String doctorId;
  List<Clinic> clinics;

  Enterprise(
      {this.id,
      this.name,
      this.socialReason,
      this.direction,
      this.doctorId,
      this.clinics});

  factory Enterprise.fromJsonResponse(Map<String, dynamic> response) {
    return Enterprise(
        id: response['_id'],
        name: response['name'],
        socialReason: response['socialReason'],
        direction: response['direction'],
        doctorId: response['doctor'],
        clinics: (response['clinic'] as List)
            .map((e) => Clinic.fromJsonResponse(e))
            .toList());
  }
}
