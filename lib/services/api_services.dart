import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../core/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30), // ← naikkan dari 10
      receiveTimeout: const Duration(seconds: 30), // ← naikkan dari 10
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  static Future<void> init() async {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }


  // GET
  static Future<dynamic> get(String endpoint) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await _dio.get(
        endpoint,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      return response.data;
    } catch (e) {
      print("GET ERROR: $e");
      throw Exception(e);
    }
  }

  // POST
  static Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      if (response.data is Map && response.data['success'] == false) {
        throw Exception(response.data['message'] ?? 'Terjadi kesalahan');
      }
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!.data;
      } else {
        throw Exception("Tidak ada koneksi");
      }
    }
  }

  static Future<String> kirimPesanChatbot(String pesan) async {
    try {
      final dio = Dio();

      final response = await dio.post(
        "https://n8n.pika.unila.ac.id/webhook/tbcare-chat",
        data: {
          "message": pesan,
        },
      );

      print("RAW RESPONSE:");
      print(response.data);

      final res = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      print("SETELAH PARSE:");
      print(res);

      return res['output']?.toString() ?? "Tidak ada jawaban dari bot";

    } catch (e) {
      print("CHATBOT ERROR: $e");
      throw Exception("Gagal menghubungi chatbot");
    }
  }

  // PUT
  static Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return response.data;
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data ?? e.message);
      } else {
        throw Exception("PUT Error: $e");
      }
    }
  }

  // DELETE
  static Future<dynamic> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return response.data;
    } catch (e) {
      if (e is DioException) {
        throw Exception(e.response?.data ?? e.message);
      } else {
        throw Exception("DELETE Error: $e");
      }
    }
  }
}