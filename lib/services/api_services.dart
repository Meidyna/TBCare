import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://dummy-url.com",
      connectTimeout: const Duration(seconds: 10),
    ),
  );

  Future<Response> get(String endpoint) async {
    return await _dio.get(endpoint);
  }
}