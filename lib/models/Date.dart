import 'package:expediente_clinico/models/Expedient.dart';
import 'package:expediente_clinico/models/Staff.dart';

class Date {
  String id;
  String dateCreated;
  bool assist;
  Expedient patient;
  String date;
  String hour;
  Staff doctor;
  String documentUrl;

  Date(
      {this.id,
      this.dateCreated,
      this.assist,
      this.patient,
      this.date,
      this.hour,
      this.doctor,
      this.documentUrl});

  factory Date.fromJsonResponse(Map<String, dynamic> response) {
    return Date(
        id: response['_id'],
        dateCreated: response['date_created'],
        assist: response['assist'],
        patient: Expedient.fromJsonResponse(response['patient']),
        date: response['date'],
        hour: response['hour'],
        doctor: Staff.fromJsonResponse(response['doctor']),
        documentUrl: response['urlDocument']);
  }
}
