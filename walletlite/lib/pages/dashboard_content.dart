import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../services/firestore_service.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  final FirestoreService _firestoreService = FirestoreService();
  final currencyFormat = NumberFormat.currency(locale: 'en_MY', symbol: 'RM ');
  int _selectedTabIndex =
      2; // 0=Daily, 1=Weekly, 2=Monthly (default to Monthly)

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
          body: SafeArea(
            child: Column(
              children: [
                // --- HEADER ---
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1F4D6B),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Hi, Welcome Back",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
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
                      const SizedBox(height: 25),
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
                      const SizedBox(height: 25),
                      // Progress Bar
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: LinearProgressIndicator(
                              value: totalExpense > 0
                                  ? totalExpense / (totalIncome + totalExpense)
                                  : 0,
                              backgroundColor: Colors.white,
                              color: const Color(0xFF26A69A),
                              minHeight: 24,
                            ),
                          ),
                          // Centered percentage text
                          Text(
                            totalExpense > 0
                                ? "${((totalExpense / (totalIncome + totalExpense)) * 100).toStringAsFixed(0)}%"
                                : "0%",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Income label aligned to the right
                          Positioned(
                            right: 12,
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
                      const SizedBox(height: 12),
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
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      // --- GOALS CARD ---
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F4D6B),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      height: 70,
                                      width: 70,
                                      child: CircularProgressIndicator(
                                        value: totalIncome > 0
                                            ? (totalBalance / totalIncome)
                                            : 0,
                                        strokeWidth: 8,
                                        color: Colors.tealAccent,
                                        backgroundColor: Colors.white12,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.directions_car,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Savings\nOn Goals",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                            Container(
                              height: 80,
                              width: 1,
                              color: Colors.white24,
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                children: [
                                  _goalRow(
                                    Icons.payments,
                                    "Revenue Last Week",
                                    currencyFormat.format(
                                      _calculateWeeklyIncome(transactions),
                                    ),
                                    Colors.white,
                                  ),
                                  const Divider(color: Colors.white24),
                                  _goalRow(
                                    Icons.restaurant,
                                    "Food Last Week",
                                    currencyFormat.format(
                                      -_calculateWeeklyExpense(
                                        transactions,
                                        'Food',
                                      ),
                                    ),
                                    const Color(0xFFFF8A8A),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // --- TABS ---
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: ["Daily", "Weekly", "Monthly"]
                              .asMap()
                              .entries
                              .map((entry) {
                                int index = entry.key;
                                String tab = entry.value;
                                bool isSelected = _selectedTabIndex == index;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedTabIndex = index;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 25,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFF1F4D6B)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      tab,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      ),

                      // --- RECENT TRANSACTIONS ---
                      ..._buildRecentTransactions(
                        _filterTransactionsByTab(transactions),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<TransactionModel> _filterTransactionsByTab(
    List<TransactionModel> transactions,
  ) {
    final now = DateTime.now();
    DateTime startDate;

    switch (_selectedTabIndex) {
      case 0: // Daily - last 24 hours
        startDate = now.subtract(const Duration(days: 1));
        break;
      case 1: // Weekly - last 7 days
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 2: // Monthly - last 30 days
      default:
        startDate = now.subtract(const Duration(days: 30));
        break;
    }

    return transactions
        .where((transaction) => transaction.date.isAfter(startDate))
        .take(3)
        .toList();
  }

  double _calculateWeeklyIncome(List<TransactionModel> transactions) {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return transactions
        .where((t) => t.isIncome && t.date.isAfter(weekAgo))
        .fold(0, (sum, item) => sum + item.amount);
  }

  double _calculateWeeklyExpense(
    List<TransactionModel> transactions,
    String category,
  ) {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return transactions
        .where(
          (t) =>
              !t.isIncome && t.category == category && t.date.isAfter(weekAgo),
        )
        .fold(0, (sum, item) => sum + item.amount);
  }

  List<Widget> _buildRecentTransactions(List<TransactionModel> transactions) {
    return transactions.map((transaction) {
      return _transactionTile(
        transaction.title,
        "${DateFormat('HH:mm').format(transaction.date)} - ${DateFormat('MMMM dd').format(transaction.date)}",
        transaction.category,
        currencyFormat.format(transaction.amount),
        transaction.isIncome ? Colors.blue : Colors.lightBlue,
        transaction.isIncome ? Colors.green : Colors.red,
      );
    }).toList();
  }

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

  Widget _goalRow(IconData icon, String label, String value, Color valColor) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
            Text(
              value,
              style: TextStyle(
                color: valColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _transactionTile(
    String title,
    String subtitle,
    String category,
    String amount,
    Color iconBagColor,
    Color amountColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconBagColor,
            child: const Icon(Icons.wallet, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.blue, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(height: 30, width: 1, color: Colors.grey.shade300),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(category, style: const TextStyle(color: Colors.grey)),
          ),
          Container(height: 30, width: 1, color: Colors.grey.shade300),
          const SizedBox(width: 15),
          Text(
            amount,
            style: TextStyle(color: amountColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
