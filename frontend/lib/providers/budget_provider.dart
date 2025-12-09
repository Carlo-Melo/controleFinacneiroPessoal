import 'package:flutter/material.dart';
import '../services/budget_service.dart';
import '../models/budget.dart';

class BudgetProvider extends ChangeNotifier {
  final BudgetService service = BudgetService();

  List<Budget> items = [];
  bool loading = false;

  Future<void> load() async {
    loading = true;
    notifyListeners();
    items = await service.getAll();
    loading = false;
    notifyListeners();
  }

  Future<void> add(double limitValue, int categoryId) async {
    await service.create(limitValue, categoryId);
    await load();
  }

  Future<void> update(int id, double limitValue, int? categoryId) async {
    await service.update(id, limitValue, categoryId);
    await load();
  }

  Future<void> remove(int id) async {
    await service.delete(id);
    await load();
  }
}

