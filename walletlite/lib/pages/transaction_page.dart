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

  // State to track filter: null = All, true = Income, false = Expense
  bool? _filterType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. MATCHING STATISTIC PAGE BACKGROUND COLOR
      backgroundColor: const Color(0xFFEFF6FB),
      body: StreamBuilder<List<TransactionModel>>(
        stream: _firestoreService.getAllTransactionsStream(),
        builder: (context, snapshot) {
          final transactions = snapshot.data ?? [];

          // 1. Calculate totals (Always based on ALL transactions)
          double totalIncome = transactions
              .where((t) => t.isIncome)
              .fold(0, (sum, item) => sum + item.amount);
          double totalExpense = transactions
              .where((t) => !t.isIncome)
              .fold(0, (sum, item) => sum + item.amount);
          double totalBalance = totalIncome - totalExpense;

          // 2. Filter the list for display
          List<TransactionModel> filteredTransactions = transactions;
          if (_filterType != null) {
            filteredTransactions = transactions
                .where((t) => t.isIncome == _filterType)
                .toList();
          }

          return Column(
            children: [
              //  HEADER SECTION
              Container(
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 30,
                  left: 20,
                  right: 20,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF1F4D6B), // Deep Blue
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(40), // Rounded Bottom
                  ),
                ),
                child: Column(
                  children: [
                    _buildTopHeader(),
                    const SizedBox(height: 20),

                    // Balance Card: Click to Reset Filter (Show All)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _filterType = null;
                        });
                      },
                      child: _buildTotalBalanceCard(totalBalance),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        // INCOME CARD
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _filterType = true; // Select Income
                              });
                            },
                            child: _buildSummaryCard(
                              "Income",
                              totalIncome,
                              isSelected:
                                  _filterType == true, // Blue if selected
                              icon: Icons.arrow_outward,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),

                        // EXPENSE CARD
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _filterType = false; // Select Expense
                              });
                            },
                            child: _buildSummaryCard(
                              "Expense",
                              totalExpense,
                              isSelected:
                                  _filterType == false, // Blue if selected
                              icon: Icons.call_received,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // --- LIST SECTION ---
              Expanded(
                // Removed the white container decoration here to match Statistic page look
                child: filteredTransactions.isEmpty
                    ? const Center(
                        child: Text(
                          "No transactions found",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : _buildTransactionList(filteredTransactions),
              ),
            ],
          );
        },
      ),
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

  Widget _buildTotalBalanceCard(double amount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
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

  // --- SUMMARY CARD (Filters) ---
  Widget _buildSummaryCard(
    String label,
    double amount, {
    required bool isSelected,
    required IconData icon,
  }) {
    // Decide highlight color based on label
    Color highlightColor = label == "Income"
        ? const Color.fromARGB(255, 47, 219, 116)
        : const Color(0xFFE05F5F);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isSelected ? highlightColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : highlightColor,
                size: 18,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF1F4D6B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            currencyFormat.format(amount),
            style: TextStyle(
              color: isSelected ? Colors.white : highlightColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<TransactionModel> transactions) {
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
      widgets.add(const SizedBox(height: 10)); // Reduced gap slightly
    });

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: widgets,
    );
  }

  Widget _buildMonthHeader(String month) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 10),
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

  Widget _buildTransactionItem(TransactionModel transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        // Added slight shadow to make items pop on the light blue background
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: transaction.isIncome
                  ? const Color.fromARGB(255, 47, 219, 116)
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
          Container(height: 40, width: 1, color: Colors.grey[200]),
          const Expanded(
            flex: 2,
            child: Center(
              child: Text(
                "Monthly",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),
          Container(height: 40, width: 1, color: Colors.grey[200]),
          Expanded(
            flex: 3,
            child: Text(
              currencyFormat.format(transaction.amount),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: transaction.isIncome
                    ? const Color.fromARGB(255, 57, 228, 117)
                    : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
