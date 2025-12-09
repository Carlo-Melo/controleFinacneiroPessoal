import 'category.dart';

class Budget {
  final int id;
  final double limitValue;
  final Category category;

  Budget({required this.id, required this.limitValue, required this.category});

  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
    id: json["id"],
    limitValue: json["limitValue"],
    category: Category.fromJson(json["category"]),
  );
}
