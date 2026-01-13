import 'expense.dart';

class Category {
  String? id;
  String name;
  List<Expense> expenses;

  Category({
    this.id,
    required this.name,
    List<Expense>? expenses,
  }) : expenses = expenses ?? [];

  // Convert Category to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  // Create Category from Firestore document
  factory Category.fromMap(Map<String, dynamic> map, String id) {
    return Category(
      id: id,
      name: map['name'] ?? '',
    );
  }
}
