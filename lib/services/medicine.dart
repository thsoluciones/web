import 'package:expediente_clinico/models/Medicine.dart';
import 'package:expediente_clinico/utils/api.dart';
import 'package:dio/dio.dart';

class MedicineService {
  Dio _dio = Dio();
  Future<Map<String, dynamic>> addMedicine(var data) async {
    var result;

    Response response =
        await _dio.post('$BASE_URL/medicine/medicine', data: data);
    if (response.statusCode == 200) {
      result = {'success': true};
    } else {
      result = {'success': false, 'message': 'Algo ha pasado, intenta luego.'};
    }
    return result;
  }

  Future<Map<String, dynamic>> editMedicine(var data, String id) async {
    var result;

    Response response = await _dio.put('$BASE_URL/medicine/$id', data: data);
    if (response.statusCode == 200) {
      result = {'success': true};
    } else {
      result = {'success': false, 'message': 'Algo ha pasado, intenta luego.'};
    }
    return result;
  }

  Future<List<Medicine>> getMedicinesByEnterprise(String id) async {
    List<Medicine> clinics = [];

    try {
      Response response = await _dio.get("$BASE_URL/medicine/byenterprise/$id");

      List<dynamic> res = response.data['medicine'] ?? [];

      res.forEach((element) {
        clinics.add(Medicine.fromJsonResponse(element));
      });
    } catch (e) {
      print(e);
    }

    return clinics;
  }

  Future<Map<String, dynamic>> deleteMedicine(String id) async {
    var result;

    Response response = await _dio.delete('$BASE_URL/medicine/delete/$id');

    if (response.data['status']) {
      result = {'success': true};
    } else {
      result = {'success': false};
    }

    return result;
  }
}
