import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  final Dio dio;

  DioClient() : dio = Dio() {
    dio.interceptors.add(PrettyDioLogger());
  }

  Future<List<T>> getData<T>(
      String endpoint, T Function(Map<String, dynamic>) fromJson) async {
    final response = await dio.get(endpoint);
    try {
      if (response.statusCode == 200) {
        List<dynamic> jsonList = response.data;
        return jsonList.map((json) => fromJson(json)).toList();
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch(e){
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<T> postData<T>(
      String endpoint, Map<String, dynamic> data, T Function(Map<String, dynamic>) fromJson) async {
    final response = await dio.post(endpoint, data: data);
    try {
      if (response.statusCode == 200) {
        return fromJson(response.data);
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch(e){
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }


}

