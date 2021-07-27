import 'package:expediente_clinico/utils/api.dart';
import 'package:dio/dio.dart';

class AuthService {
  Dio _dio = Dio();

  Future<Map<String, dynamic>> login({username, password}) async {
    var result;

    Response response = await _dio.post('$BASE_URL/auth/login',
        data: {'email': username, 'password': password});

    if (response.statusCode == 200) {
      if (response.data['user'] != null) {
        result = {
          'success': true,
          'user': response.data['user'],
        };
      } else {
        result = {
          'success': false,
          'user': null,
          'message': 'Algo ha ocurrido. Intenta luego'
        };
      }
    } else {
      result = {
        'success': false,
        'user': null,
        'message': 'Algo ha ocurrido. Intenta luego'
      };
    }

    return result;
  }

  Future<Map<String, dynamic>> addOwner(var data) async {
    var result;

    Response response = await _dio.post('$BASE_URL/auth/signup', data: data);

    if (response.statusCode == 200) {
      if (response.data['user'] != null) {
        result = {'success': true};
      } else {
        result = {
          'success': false,
          'user': null,
          'message': 'Algo ha ocurrido. Intenta luego'
        };
      }
    } else {
      result = {
        'success': false,
        'user': null,
        'message': 'Algo ha ocurrido. Intenta luego'
      };
    }

    return result;
  }
}
