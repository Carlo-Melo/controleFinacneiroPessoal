import 'package:dio/dio.dart';
import '../core/dio_client.dart';
import '../models/transaction.dart';

class TransactionService {
  final Dio dio = DioClient.dio;

  Future<List<TransactionModel>> getAll() async {
    final r = await dio.get("/transactions");
    return (r.data as List)
        .map((e) => TransactionModel.fromJson(e))
        .toList();
  }

  Future<TransactionModel> create(
      String desc, double amount, int categoryId) async {
    final r = await dio.post("/transactions", data: {
      "description": desc,
      "amount": amount,
      "categoryId": categoryId
    });
    return TransactionModel.fromJson(r.data);
  }

  Future<TransactionModel> update(
      int id, String desc, double amount, int? categoryId) async {
    final r = await dio.put("/transactions/$id", data: {
      "description": desc,
      "amount": amount,
      if (categoryId != null) "categoryId": categoryId
    });
    return TransactionModel.fromJson(r.data);
  }

  Future<void> delete(int id) async {
    await dio.delete("/transactions/$id");
  }
}
