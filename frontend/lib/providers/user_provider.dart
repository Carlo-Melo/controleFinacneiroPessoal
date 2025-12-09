import 'package:flutter/material.dart';
import '../models/user.dart';
import 'package:dio/dio.dart';
import '../core/dio_client.dart';

class UserProvider extends ChangeNotifier {
  final Dio dio = DioClient.dio;

  List<User> items = [];
  bool loading = false;

  Future<void> load() async {
    loading = true;
    notifyListeners();
    final response = await dio.get("/users");
    items = (response.data as List).map((e) => User.fromJson(e)).toList();
    loading = false;
    notifyListeners();
  }

  Future<void> add(String username, String password) async {
    await dio.post("/users/register", data: {
      "username": username,
      "password": password,
    });
    await load();
  }

  Future<void> update(int id, String username, String password) async {
    await dio.put("/users/$id", data: {
      "username": username,
      "password": password,
    });
    await load();
  }

  Future<void> remove(int id) async {
    await dio.delete("/users/$id");
    await load();
  }
}
