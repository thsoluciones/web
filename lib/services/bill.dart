import 'package:expediente_clinico/models/Bill.dart';
import 'package:expediente_clinico/models/Date.dart';
import 'package:expediente_clinico/utils/api.dart';
import 'package:dio/dio.dart';

class BillService {
  Dio _dio = Dio();
  Future<Map<String, dynamic>> addBill(var data) async {
    var result;
    Response response = await _dio.post('$BASE_URL/bills', data: data);
    if (response.statusCode == 200) {
      result = {'status': true};
    } else {
      result = {'status': false};
    }

    return result;
  }

  Future<List<Bill>> getBillsByClinic(String idClinic) async {
    List<Bill> bills = [];

    try {
      Response response = await _dio.get("$BASE_URL/bills/byclinic/$idClinic");

      List<dynamic> res = response.data;

      res.forEach((element) {
        bills.add(Bill.fromJsonResponse(element));
      });
    } catch (e) {
      print(e);
    }

    return bills;
  }

  Future<Map<String, dynamic>> updateColective(
      String method, double mount, String id) async {
    var result;
    Response response = await _dio.patch('$BASE_URL/bills/payment/$id',
        data: {"methodPayment": method, "deposit": mount});
    if (response.statusCode == 200) {
      result = {'status': true};
    } else {
      result = {'status': false};
    }

    return result;
  }

  Future<Map<String, dynamic>> updateBill(
      String method, String id, String url) async {
    var result;
    Response response = await _dio.patch('$BASE_URL/bills/bill/payment/$id',
        data: {"methodPayment": method, "url": url});
    if (response.statusCode == 200) {
      result = {'status': true};
    } else {
      result = {'status': false};
    }

    return result;
  }

  Future<List<Bill>> getBillsByPatient(String patient) async {
    List<Bill> bills = [];

    try {
      Response response = await _dio.get("$BASE_URL/bills/bypatient/$patient");

      List<dynamic> res = response.data;

      res.forEach((element) {
        bills.add(Bill.fromJsonResponse(element));
      });
    } catch (e) {
      print(e);
    }

    return bills;
  }
}
