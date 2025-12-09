import 'package:dio/dio.dart';
import '../core/dio_client.dart';

class AuthService {
  final Dio dio = DioClient.dio;

  Future<String> login(String username, String password) async {
    final response = await dio.post("/auth/login", data: {
      "username": username,
      "password": password,
    });

    return response.data["token"];
  }

  Future<void> register(String username, String password) async {
    await dio.post("/users/register", data: {
      "username": username,
      "password": password,
    });
  }
}
