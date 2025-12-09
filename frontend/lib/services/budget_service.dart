import 'package:dio/dio.dart';
import '../core/dio_client.dart';
import '../models/budget.dart';

class BudgetService {
  final Dio dio = DioClient.dio;

  Future<List<Budget>> getAll() async {
    final r = await dio.get("/budgets");
    return (r.data as List).map((e) => Budget.fromJson(e)).toList();
  }

  Future<Budget> create(double limitValue, int categoryId) async {
    final r = await dio.post("/budgets", data: {
      "limitValue": limitValue,
      "categoryId": categoryId,
    });
    return Budget.fromJson(r.data);
  }

  Future<Budget> update(int id, double limitValue, int? categoryId) async {
    final r = await dio.put("/budgets/$id", data: {
      "limitValue": limitValue,
      if (categoryId != null) "categoryId": categoryId,
    });
    return Budget.fromJson(r.data);
  }

  Future<void> delete(int id) async {
    await dio.delete("/budgets/$id");
  }
}
