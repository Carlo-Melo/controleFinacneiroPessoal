import 'package:flutter/material.dart';
import '../services/category_service.dart';
import '../models/category.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService service = CategoryService();

  List<Category> items = [];
  bool loading = false;

  Future<void> load() async {
    loading = true;
    notifyListeners();
    items = await service.getAll();
    loading = false;
    notifyListeners();
  }

  Future<void> add(String name) async {
    await service.create(name);
    await load();
  }

  Future<void> update(int id, String name) async {
    await service.update(id, name);
    await load();
  }

  Future<void> remove(int id) async {
    await service.delete(id);
    await load();
  }
}
