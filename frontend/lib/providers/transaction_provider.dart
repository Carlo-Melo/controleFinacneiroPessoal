import 'package:flutter/material.dart';
import '../services/transaction_service.dart';
import '../models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionService service = TransactionService();

  List<TransactionModel> items = [];
  bool loading = false;

  Future<void> load() async {
    loading = true;
    notifyListeners();
    items = await service.getAll();
    loading = false;
    notifyListeners();
  }

  Future<void> add(String description, double amount, int categoryId) async {
    await service.create(description, amount, categoryId);
    await load();
  }

  Future<void> update(int id, String description, double amount, int? categoryId) async {
    await service.update(id, description, amount, categoryId);
    await load();
  }

  Future<void> remove(int id) async {
    await service.delete(id);
    await load();
  }
}
