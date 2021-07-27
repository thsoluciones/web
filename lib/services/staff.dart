import 'dart:convert';

import 'package:expediente_clinico/models/Option.dart';
import 'package:expediente_clinico/models/Staff.dart';
import 'package:expediente_clinico/utils/api.dart';
import 'package:dio/dio.dart';

class StaffService {
  Dio _dio = Dio();

  Future<Map<String, dynamic>> addStaff(var data) async {
    var result;

    Response response =
        await _dio.post('$BASE_URL/staff/staff/new', data: data);
    print(response);
    if (response.statusCode == 200) {
      result = {'success': true};
    } else {
      result = {'success': false, 'message': 'Algo ha pasado, intenta luego.'};
    }
    return result;
  }

  Future<Map<String, dynamic>> deleteStaff(var id) async {
    var result;

    Response response = await _dio.delete('$BASE_URL/staff/delete/$id');
    if (response.statusCode == 200) {
      result = {'success': true};
    } else {
      result = {'success': false, 'message': 'Algo ha pasado, intenta luego.'};
    }
    return result;
  }

  Future<List<Staff>> getStaffByEnteprise(String id) async {
    List<Staff> staffs = [];

    try {
      Response response =
          await _dio.get("$BASE_URL/staff/staffbyenterprise/$id");

      List<dynamic> res = response.data['staffbyenterprises']['staff'];

      res.forEach((element) {
        staffs.add(Staff.fromJsonResponse(element));
      });
    } catch (e) {
      print(e);
    }

    return staffs;
  }

  Future<Map<String, dynamic>> updatePermissions(
      List<Option> options, String iduser) async {
    var result;
    List<Map<String, dynamic>> list = options.map((e) => e.toJson()).toList();

    Response response = await _dio
        .patch('$BASE_URL/staff/options/$iduser', data: {"options": list});
    if (response.data['status']) {
      result = {'status': true};
    } else {
      result = {'status': true};
    }
    return result;
  }
}
