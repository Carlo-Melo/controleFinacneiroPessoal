import 'category.dart';

class TransactionModel {
  final int id;
  final String description;
  final double amount;
  final Category category;

  TransactionModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json["id"],
        description: json["description"],
        amount: json["amount"],
        category: Category.fromJson(json["category"]),
      );
}
