import 'package:expediente_clinico/models/Expedient.dart';

class Inquirie {
  String id;
  Expedient expedient;
  String service;
  dynamic baseprice;
  List<dynamic> treatments;
  List<dynamic> recetaries;
  String clinic;
  String status;
  String type;
  dynamic totalService;
  dynamic balance;
  dynamic quota;
  dynamic deposit;
  int session;
  List<dynamic> history;

  Inquirie(
      {this.id,
      this.expedient,
      this.service,
      this.treatments,
      this.status,
      this.recetaries,
      this.type,
      this.baseprice,
      this.totalService,
      this.balance,
      this.quota,
      this.history,
      this.session});

  factory Inquirie.fromJsonResponse(Map<String, dynamic> response) {
    return Inquirie(
        id: response['_id'],
        expedient: Expedient.fromJsonResponse(response['patient']),
        service: response['service'],
        baseprice: response['baseprice']["\$numberDecimal"] ?? 0,
        treatments: response['extraservices'] ?? [],
        status: response['status'],
        type: response['type'],
        history: response['subinquirie'] ?? [],
        balance: response['balance']["\$numberDecimal"] ?? 0,
        quota: response['quota']["\$numberDecimal"] ?? 0,
        session: response['session'],
        recetaries: response['recetaries'] ?? [],
        totalService: response['totalService']["\$numberDecimal"] ?? 0);
  }
}
