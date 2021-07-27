import 'package:expediente_clinico/models/Inquirie.dart';
import 'package:expediente_clinico/utils/api.dart';
import 'package:dio/dio.dart';

class InquirieService {
  Dio _dio = Dio();
  Future<Map<String, dynamic>> addInquirie(var data) async {
    var result;

    Response response = await _dio.post('$BASE_URL/inquiries', data: data);
    if (response.statusCode == 200) {
      result = {'success': true};
    } else {
      result = {'success': false, 'message': 'Algo ha pasado, intenta luego.'};
    }
    return result;
  }

  Future<Map<String, dynamic>> addHistoryToInquirie(var data, String id) async {
    var result;

    Response response = await _dio
        .post('$BASE_URL/inquiries/updatehistorybalance/$id', data: data);
    if (response.statusCode == 200) {
      result = {'success': true};
    } else {
      result = {'success': false, 'message': 'Algo ha pasado, intenta luego.'};
    }
    return result;
  }

  Future<List<Inquirie>> getInquiriesByClinic(String id) async {
    List<Inquirie> inquiries = [];

    try {
      Response response = await _dio.get("$BASE_URL/inquiries/byclinic/$id");

      List<dynamic> res = response.data['data'];

      res.forEach((element) {
        inquiries.add(Inquirie.fromJsonResponse(element));
      });
    } catch (e) {
      print(e);
    }
    return inquiries;
  }

  Future<List<Inquirie>> getPendingInquiries(String clinic) async {
    List<Inquirie> inquiries = [];

    try {
      Response response =
          await _dio.get("$BASE_URL/inquiries/pending/clinic/$clinic");

      List<dynamic> res = response.data['result'];

      res.forEach((element) {
        inquiries.add(Inquirie.fromJsonResponse(element));
      });
    } catch (e) {
      print(e);
    }

    return inquiries;
  }
}
