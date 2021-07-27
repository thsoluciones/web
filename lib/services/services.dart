import 'package:expediente_clinico/models/Service.dart';
import 'package:expediente_clinico/utils/api.dart';
import 'package:dio/dio.dart';

class ServicesService {
  Dio _dio = Dio();

  Future<List<Service>> getServicesByEnterprise(String id) async {
    List<Service> clinics = [];

    try {
      Response response = await _dio.get("$BASE_URL/services/byenterprise/$id");
      print(response.data);
      List<dynamic> res = response.data['service'] ?? [];

      res.forEach((element) {
        clinics.add(Service.fromJsonResponse(element));
      });
    } catch (e) {
      print(e);
    }

    return clinics;
  }

  Future<Map<String, dynamic>> addService(var data) async {
    var result;

    Response response =
        await _dio.post('$BASE_URL/services/service', data: data);
    if (response.statusCode == 200) {
      result = {'success': true};
    } else {
      result = {'success': false, 'message': 'Algo ha pasado, intenta luego.'};
    }
    return result;
  }

  Future<Map<String, dynamic>> editService(var data, String id) async {
    var result;

    Response response = await _dio.put('$BASE_URL/services/$id', data: data);
    if (response.statusCode == 200) {
      result = {'success': true};
    } else {
      result = {'success': false, 'message': 'Algo ha pasado, intenta luego.'};
    }
    return result;
  }

  Future<Map<String, dynamic>> deleteService(String id) async {
    var result;

    Response response = await _dio.delete('$BASE_URL/services/delete/$id');

    if (response.data['status']) {
      result = {'success': true};
    } else {
      result = {'success': false};
    }

    return result;
  }
}
