import 'package:expediente_clinico/models/Expedient.dart';
import 'package:expediente_clinico/models/Inquirie.dart';
import 'package:expediente_clinico/utils/api.dart';
import 'package:dio/dio.dart';

class ExpedientService {
  Dio _dio = Dio();

  Future<List<Expedient>> getPatients(String clinicId) async {
    List<Expedient> expedients = [];

    try {
      Response response =
          await _dio.get("$BASE_URL/patient/byclinic/$clinicId");

      List<dynamic> res = response.data['Patients']['patient'];

      res.forEach((element) {
        expedients.add(Expedient.fromJsonResponse(element));
      });
    } catch (e) {
      print(e);
    }

    return expedients;
  }

  Future<List<Inquirie>> getHistoryClinic(String patient, String clinic) async {
    List<Inquirie> inquiries = [];

    try {
      Response response =
          await _dio.get("$BASE_URL/patient/history/$patient/clinic/$clinic");

      List<dynamic> res = response.data['data'];

      res.forEach((element) {
        inquiries.add(Inquirie.fromJsonResponse(element));
      });
    } catch (e) {
      print(e);
    }

    return inquiries;
  }

  Future<Map<String, dynamic>> addPatient(var data) async {
    var result;
    Response response =
        await _dio.post('$BASE_URL/patient/savepatient', data: data);
    if (response.statusCode == 200) {
      result = {'status': true};
    } else {
      result = {'status': false};
    }
    return result;
  }

  Future<Map<String, dynamic>> addHistory(var data, String id) async {
    var result;
    Response response = await _dio
        .put('$BASE_URL/patient/historyupdate/$id', data: {'history': data});
    if (response.statusCode == 200) {
      result = {'status': true};
    } else {
      result = {'status': false};
    }
    return result;
  }
}
