import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';
import '../models/user_model.dart';
import '../services/api_services.dart';

class AuthRepository {
  static Future<UserModel> login(String email, String password) async {
    final res = await ApiService.post(ApiConstants.login, {
      "email": email,
      "password": password,
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', res['data']['token']);

    return UserModel.fromJson(res);
  }

  static Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final res = await ApiService.post(ApiConstants.register, {
      "nama_lengkap": name,
      "email": email,
      "no_telepon": phone,
      "password": password,
    });

    if (res['success'] != true) {
      throw Exception(res['message']);
    }

    final token = res['data']?['token'];
    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
    }

    return UserModel.fromJson(res);
  }
}