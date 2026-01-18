import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/category.dart';
import '../models/expense.dart';
import '../models/transaction_model.dart';
import '../services/firestore_service.dart';
import 'add_expense_categories_page.dart';

class CategoryDetailPage extends StatefulWidget {
  final Category category;

  const CategoryDetailPage({super.key, required this.category});

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  late FirestoreService _firestoreService;
  late Stream<List<TransactionModel>> _expensesStream;
  final currencyFormat = NumberFormat.currency(locale: 'en_MY', symbol: 'RM ');

  @override
  void initState() {
    super.initState();
    _firestoreService = FirestoreService();
    _expensesStream = _firestoreService.getTransactionsByCategory(
      widget.category.name,
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FB),

      // ================= BODY =================
      body: StreamBuilder<List<TransactionModel>>(
        stream: _firestoreService.getAllTransactionsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading data: ${snapshot.error}'),
            );
          }

          final allTransactions = snapshot.data ?? [];

          // Calculate totals for all transactions
          double totalIncome = allTransactions
              .where((t) => t.isIncome)
              .fold(0, (sum, item) => sum + item.amount);
          double totalExpense = allTransactions
              .where((t) => !t.isIncome)
              .fold(0, (sum, item) => sum + item.amount);
          double totalBalance = totalIncome - totalExpense;

          // Calculate category-specific expense
          double categoryExpense = allTransactions
              .where((t) => t.category == widget.category.name && !t.isIncome)
              .fold(0, (sum, item) => sum + item.amount);

          // Calculate percentage for progress bar
          double expensePercentage = totalIncome > 0
              ? (totalExpense / totalIncome) * 100
              : 0;
          
          // Get category-specific expenses for the list
          final categoryExpenses = allTransactions
              .where((t) => t.category == widget.category.name && !t.isIncome)
              .toList();

          return Column(
            children: [
              // ===== HEADER (MATCH CATEGORY PAGE / STATISTIC PAGE) =====
              Container(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
                decoration: const BoxDecoration(
                  color: Color(0xFF1F4D6B),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    // Top Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          widget.category.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.notifications_none, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Balance Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _headerStat(
                          "Total Balance",
                          currencyFormat.format(totalBalance),
                          Icons.outbound_outlined,
                          Colors.white,
                        ),
                        Container(height: 40, width: 1, color: Colors.white30),
                        _headerStat(
                          "Total Expense",
                          currencyFormat.format(-totalExpense),
                          Icons.move_to_inbox_outlined,
                          const Color(0xFFFF8A8A),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Progress Bar
                    Container(
                      height: 24,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width - 40) * (expensePercentage / 100),
                            decoration: BoxDecoration(
                              color: const Color(0xFF26A69A),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "${expensePercentage.toStringAsFixed(1)}%",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 12,
                            top: 4,
                            child: Text(
                              currencyFormat.format(totalIncome),
                              style: const TextStyle(
                                color: Color(0xFF1F4D6B),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Icon(
                          Icons.check_box_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${expensePercentage.toStringAsFixed(1)}% Of Your Expenses, Looks Good.",
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ===== CONTENT =====
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: categoryExpenses.isEmpty
                      ? Column(
                          children: const [
                            SizedBox(height: 60),
                            Icon(
                              Icons.receipt_long,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "No expenses yet",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Tap Add Expense to get started",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: categoryExpenses.map((expense) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        expense.title,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${expense.date.hour.toString().padLeft(2, '0')}:${expense.date.minute.toString().padLeft(2, '0')} - ${expense.date.day}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "-${currencyFormat.format(expense.amount)}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFFF6B6B),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.more_vert,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              title: const Text(
                                                "Delete Expense?",
                                              ),
                                              content: Text(
                                                "Delete '${expense.title}' (${currencyFormat.format(expense.amount)})?",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text("Cancel"),
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                  onPressed: () async {
                                                    await _firestoreService
                                                        .deleteTransaction(
                                                          expense.id ?? '',
                                                        );
                                                    _showSuccessSnackBar(
                                                      "Expense deleted!",
                                                    );
                                                    if (context.mounted) {
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: const Text("Delete"),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                ),
              ),
            ],
          );
        },
      ),

      // ===== FIXED BOTTOM BUTTON =====
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddExpenseCategoriesPage(
                    categoryId: widget.category.name,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1F4D6B),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 6,
            ),
            child: const Text(
              "Add Expense",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===== HEADER STAT WIDGET =====
  Widget _headerStat(
    String label,
    String value,
    IconData icon,
    Color valColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
