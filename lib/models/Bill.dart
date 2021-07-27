import 'package:expediente_clinico/models/Expedient.dart';
import 'package:expediente_clinico/models/Inquirie.dart';

class Bill {
  String id;
  String title;
  List<dynamic> content;
  Expedient patient;
  String clinic;
  String type;
  String methodPayment;
  String dateCreated;
  String status;
  dynamic subtotal;
  String url;
  Inquirie inquirie;

  Bill(
      {this.id,
      this.title,
      this.content,
      this.patient,
      this.clinic,
      this.type,
      this.methodPayment,
      this.dateCreated,
      this.url,
      this.status,
      this.subtotal,
      this.inquirie});

  factory Bill.fromJsonResponse(Map<String, dynamic> response) {
    return Bill(
        id: response['_id'],
        title: response['title'],
        url: response['url'],
        dateCreated: response['date_created'],
        content: response['content'],
        patient: Expedient.fromJsonResponse(response['patient']),
        clinic: response['clinic'],
        status: response['status'],
        type: response['type'],
        subtotal: response['subtotal']["\$numberDecimal"],
        methodPayment: response['methodPayment'],
        inquirie: Inquirie.fromJsonResponse(response['inquirie']));
  }
}
