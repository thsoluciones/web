import 'package:expediente_clinico/models/Clinic.dart';
import 'package:expediente_clinico/models/Enterprise.dart';
import 'package:expediente_clinico/utils/api.dart';
import 'package:dio/dio.dart';

class EnterpriseService {
  Dio _dio = Dio();

  Future<List<Enterprise>> getMyEnterprises(String idUser) async {
    List<Enterprise> enterprises = [];

    try {
      Response response = await _dio.get("$BASE_URL/auth/byowner/$idUser");

      List<dynamic> res = response.data['enterprises']['enterprises'];

      res.forEach((element) {
        enterprises.add(Enterprise.fromJsonResponse(element));
      });
    } catch (e) {
      print(e);
    }

    return enterprises;
  }

  Future<Map<String, dynamic>> addEnterprise(var data) async {
    var result;

    Response response =
        await _dio.post('$BASE_URL/enterprise/save', data: data);
    print(response);
    if (response.statusCode == 200) {
      result = {'success': true};
    } else {
      result = {'success': false, 'message': 'Algo ha pasado, intenta luego.'};
    }
    return result;
  }

  Future<List<Clinic>> getClinicsByEnterprise(String id) async {
    List<Clinic> clinics = [];

    try {
      Response response = await _dio.get("$BASE_URL/clinic/byenterprise/$id");

      List<dynamic> res = response.data['clinic'];

      res.forEach((element) {
        clinics.add(Clinic.fromJsonResponse(element));
      });
    } catch (e) {
      print(e);
    }

    return clinics;
  }
}
