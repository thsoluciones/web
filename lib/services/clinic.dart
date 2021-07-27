import 'package:expediente_clinico/utils/api.dart';
import 'package:dio/dio.dart';

class ClinicService {
  Dio _dio = Dio();
  Future<Map<String, dynamic>> addClinic(var data) async {
    var result;

    Response response = await _dio.post('$BASE_URL/clinic/clinic', data: data);
    if (response.statusCode == 200) {
      result = {'success': true};
    } else {
      result = {'success': false, 'message': 'Algo ha pasado, intenta luego.'};
    }
    return result;
  }
}
