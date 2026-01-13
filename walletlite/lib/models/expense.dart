class Expense {
  String? id;
  String title;
  double amount;
  DateTime date;

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
  });

  // Convert Expense to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  // Create Expense from Firestore document
  factory Expense.fromMap(Map<String, dynamic> map, String id) {
    return Expense(
      id: id,
      title: map['title'] ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
    );
  }
}

