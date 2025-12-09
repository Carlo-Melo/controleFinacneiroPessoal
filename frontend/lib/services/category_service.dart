import 'package:dio/dio.dart';
import '../core/dio_client.dart';
import '../models/category.dart';

class CategoryService {
  final Dio dio = DioClient.dio;

  Future<List<Category>> getAll() async {
    final r = await dio.get("/categories");
    return (r.data as List).map((e) => Category.fromJson(e)).toList();
  }

  Future<Category> create(String name) async {
    final r = await dio.post("/categories", data: {"name": name});
    return Category.fromJson(r.data);
  }

  Future<Category> update(int id, String name) async {
    final r = await dio.put("/categories/$id", data: {"name": name});
    return Category.fromJson(r.data);
  }

  Future<void> delete(int id) async {
    await dio.delete("/categories/$id");
  }
}
