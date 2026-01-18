import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/category.dart';
import '../models/transaction_model.dart';
import '../services/firestore_service.dart';
import 'category_detail_page.dart';
import 'home_page.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late FirestoreService _firestoreService;
  final currencyFormat = NumberFormat.currency(locale: 'en_MY', symbol: 'RM ');

  final Map<String, IconData> categoryIcons = {
    'Food': Icons.restaurant,
    'Transport': Icons.directions_car,
    'Medicine': Icons.medical_services,
    'Groceries': Icons.shopping_bag,
    'Rent': Icons.apartment,
    'Gifts': Icons.card_giftcard,
    'Savings': Icons.savings,
    'Entertainment': Icons.movie,
  };

  @override
  void initState() {
    super.initState();
    _firestoreService = FirestoreService();
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

  void _addCategory() {
    showDialog(
      context: context,
      builder: (_) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text("New Category"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Write...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: const Color(0xFFE8F4FF),
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (controller.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter a category name"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      await _firestoreService.addCategory(controller.text);
                      if (mounted) {
                        _showSuccessSnackBar("Category added successfully!");
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F4D6B),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB0D9FF),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Color(0xFF1F4D6B),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TransactionModel>>(
      stream: _firestoreService.getAllTransactionsStream(),
      builder: (context, snapshot) {
        final transactions = snapshot.data ?? [];

        // Calculate totals
        double totalIncome = transactions
            .where((t) => t.isIncome)
            .fold(0, (sum, item) => sum + item.amount);
        double totalExpense = transactions
            .where((t) => !t.isIncome)
            .fold(0, (sum, item) => sum + item.amount);
        double totalBalance = totalIncome - totalExpense;

        // Calculate percentage for progress bar
        double expensePercentage = totalIncome > 0
            ? (totalExpense / totalIncome) * 100
            : 0;

        return Scaffold(
          backgroundColor: const Color(0xFFEFF6FB),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // ===== HEADER (SAME AS STATISTIC PAGE) =====
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
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
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              );
                            },
                          ),
                          const Text(
                            "Categories",
                            style: TextStyle(
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
                            child: const Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                            ),
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
                          Container(
                            height: 40,
                            width: 1,
                            color: Colors.white30,
                          ),
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
                              width:
                                  MediaQuery.of(context).size.width *
                                  (expensePercentage / 100),
                              decoration: BoxDecoration(
                                color: const Color(0xFF26A69A),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "${expensePercentage.toStringAsFixed(0)}%",
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
                            expensePercentage > 0
                                ? "${expensePercentage.toStringAsFixed(0)}% Of Your Expenses${expensePercentage <= 30 ? ', Looks Good.' : '.'}"
                                : "No expenses yet",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ===== CATEGORY GRID (UNCHANGED) =====
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                  child: StreamBuilder<List<Category>>(
                    stream: _firestoreService.getCategoriesStream(),
                    builder: (context, snapshot) {
                      final categories = snapshot.data ?? [];

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 1,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.95,
                            ),
                        itemCount: categories.length + 1,
                        itemBuilder: (context, index) {
                          if (index == categories.length) {
                            // ADD BUTTON
                            return GestureDetector(
                              onTap: _addCategory,
                              child: Column(
                                children: [
                                  Container(
                                    height: 68,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[300],
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 6,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.add,
                                        size: 36,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "More",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          final category = categories[index];
                          final icon =
                              categoryIcons[category.name] ?? Icons.category;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CategoryDetailPage(category: category),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: 68,
                                  decoration: BoxDecoration(
                                    color: Colors.blue[300],
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 6,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Icon(
                                      icon,
                                      size: 36,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  category.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===== SHARED HEADER WIDGET =====
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
