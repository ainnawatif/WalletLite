import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:walletlite/pages/home_page.dart';
import '../models/expense.dart';
import '../models/transaction_model.dart';
import '../services/firestore_service.dart';
import 'add_transaction_page.dart';

class TransactionPage extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;

  const TransactionPage({super.key, this.categoryId, this.categoryName});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final currencyFormat = NumberFormat.currency(locale: 'en_MY', symbol: 'RM ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF1F4D6B,
      ), // Dark blue background for the header area
      body: SafeArea(
        child: StreamBuilder<List<TransactionModel>>(
          stream: _firestoreService.getAllTransactionsStream(),
          builder: (context, snapshot) {
            final transactions = snapshot.data ?? [];

            // Logic to calculate totals for the summary cards
            double totalIncome = transactions
                .where((t) => t.isIncome)
                .fold(0, (sum, item) => sum + item.amount);
            double totalExpense = transactions
                .where((t) => !t.isIncome)
                .fold(0, (sum, item) => sum + item.amount);
            double totalBalance = totalIncome - totalExpense;

            return Column(
              children: [
                // --- 1. HEADER SECTION (Balance & Summary Cards) ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildTopHeader(),
                      const SizedBox(height: 20),
                      _buildTotalBalanceCard(totalBalance),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSummaryCard(
                              "Income",
                              totalIncome,
                              isBlue: true,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildSummaryCard(
                              "Expense",
                              totalExpense,
                              isBlue: false,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // --- 2. LIST SECTION (White Rounded Area) ---
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(50),
                      ),
                    ),
                    child: transactions.isEmpty
                        ? const Center(child: Text("No transactions found"))
                        : _buildTransactionList(transactions),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      // Floating Action Button exactly like your screenshot
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionPage(
                categoryId: widget.categoryId,
                categoryName: widget.categoryName,
              ),
            ),
          );
        },
        backgroundColor: const Color(0xFF1F4D6B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.add, size: 35, color: Colors.white),
      ),
    );
  }

  // Header row with Back and Notification
  Widget _buildTopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),

        const Text(
          "Transaction",
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
          child: const Icon(Icons.notifications_none, color: Colors.white),
        ),
      ],
    );
  }

  // White Total Balance Card
  Widget _buildTotalBalanceCard(double amount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Text(
            "Total Balance",
            style: TextStyle(
              color: Color(0xFF1F4D6B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            currencyFormat.format(amount),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F4D6B),
            ),
          ),
        ],
      ),
    );
  }

  // Summary Cards (Income/Expense)
  Widget _buildSummaryCard(
    String label,
    double amount, {
    required bool isBlue,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isBlue ? const Color(0xFF007AFF) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isBlue ? Icons.arrow_outward : Icons.call_received,
                color: isBlue ? Colors.white : const Color(0xFF007AFF),
                size: 18,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  color: isBlue ? Colors.white : const Color(0xFF1F4D6B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            currencyFormat.format(amount),
            style: TextStyle(
              color: isBlue ? Colors.white : const Color(0xFF007AFF),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // The grouped List with Month headers
  Widget _buildTransactionList(List<TransactionModel> transactions) {
    // Group transactions by month and year
    Map<String, List<TransactionModel>> groupedTransactions = {};

    for (var transaction in transactions) {
      String monthYear = DateFormat('MMMM yyyy').format(transaction.date);
      if (!groupedTransactions.containsKey(monthYear)) {
        groupedTransactions[monthYear] = [];
      }
      groupedTransactions[monthYear]!.add(transaction);
    }

    List<Widget> widgets = [];
    groupedTransactions.forEach((monthYear, trans) {
      widgets.add(_buildMonthHeader(monthYear));
      widgets.addAll(trans.map((e) => _buildTransactionItem(e)).toList());
      widgets.add(const SizedBox(height: 20));
    });

    return ListView(padding: const EdgeInsets.all(30), children: widgets);
  }

  Widget _buildMonthHeader(String month) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            month,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F4D6B),
            ),
          ),
          const Icon(Icons.calendar_month_outlined, color: Color(0xFF1F4D6B)),
        ],
      ),
    );
  }

  // Custom List Item with vertical dividers like the screenshot
  Widget _buildTransactionItem(TransactionModel transaction) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: transaction.isIncome
                  ? const Color(0xFF4CAF50)
                  : const Color.fromARGB(255, 224, 95, 95),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              transaction.isIncome ? Icons.arrow_upward : Icons.layers,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "${DateFormat('HH:mm').format(transaction.date)} - ${DateFormat('MMMM dd').format(transaction.date)}",
                  style: const TextStyle(
                    color: Color(0xFF007AFF),
                    fontSize: 12,
                  ),
                ),
                Text(
                  transaction.category,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.grey[300],
          ), // Vertical Divider
          const Expanded(
            flex: 2,
            child: Center(
              child: Text("Monthly", style: TextStyle(color: Colors.grey)),
            ),
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.grey[300],
          ), // Vertical Divider
          Expanded(
            flex: 3,
            child: Text(
              currencyFormat.format(transaction.amount),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: transaction.isIncome ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
