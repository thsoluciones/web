import 'package:expediente_clinico/models/Date.dart';
import 'package:expediente_clinico/utils/api.dart';
import 'package:dio/dio.dart';

class DateService {
  Dio _dio = Dio();

  Future<List<Date>> getDatesByClinic(String id) async {
    List<Date> dates = [];

    try {
      Response response = await _dio.get("$BASE_URL/dates/byclinic/${id}");

      List<dynamic> res = response.data['dates'];

      res.forEach((element) {
        dates.add(Date.fromJsonResponse(element));
      });
    } catch (e) {
      print(e);
    }

    return dates;
  }

  Future<Map<String, dynamic>> addDate(var data) async {
    var result;

    Response response = await _dio.post('$BASE_URL/dates', data: data);
    if (response.statusCode == 200) {
      Map<String, dynamic> bodyResponse = response.data;
      if (bodyResponse['status']) {
        result = {'success': true};
      } else {
        result = {'success': false, 'message': bodyResponse['message']};
      }
    } else {
      result = {'success': false, 'message': 'Algo ha pasado, intenta luego.'};
    }
    return result;
  }
}
