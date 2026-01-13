import 'package:flutter/material.dart';
import 'add_transaction_page.dart';

enum TransactionFilter { all, income, expense }

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  TransactionFilter _filter = TransactionFilter.all;

  // Example transactions (replace later with Firestore)
  final List<_TransactionTile> _transactions = [
    _TransactionTile(
      title: "Salary",
      subtitle: "18:27 - April 30",
      category: "Monthly",
      amount: "4000.00",
      icon: Icons.account_balance_wallet_rounded,
      iconBgColor: Colors.blue,
      isPositive: true,
    ),
    _TransactionTile(
      title: "Groceries",
      subtitle: "17:00 - April 24",
      category: "Pantry",
      amount: "100.00",
      icon: Icons.shopping_basket_rounded,
      iconBgColor: Colors.blueAccent,
      isPositive: false,
    ),
    _TransactionTile(
      title: "Rent",
      subtitle: "8:30 - April 15",
      category: "Rent",
      amount: "610.40",
      icon: Icons.vpn_key_rounded,
      iconBgColor: Colors.indigo,
      isPositive: false,
    ),
  ];

  List<_TransactionTile> get _filteredTransactions {
    switch (_filter) {
      case TransactionFilter.income:
        return _transactions.where((tx) => tx.isPositive).toList();
      case TransactionFilter.expense:
        return _transactions.where((tx) => !tx.isPositive).toList();
      case TransactionFilter.all:
        return _transactions;
    }
  }

  double get totalBalance {
    double income = _transactions
        .where((tx) => tx.isPositive)
        .fold(0, (sum, tx) => sum + double.parse(tx.amount));
    double expense = _transactions
        .where((tx) => !tx.isPositive)
        .fold(0, (sum, tx) => sum + double.parse(tx.amount));
    return income - expense;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FB),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTransactionPage()),
          );
        },
        backgroundColor: const Color(0xFF1F4D6B),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
              decoration: const BoxDecoration(
                color: Color(0xFF1F4D6B),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    "Transaction",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // TOTAL BALANCE CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Total Balance",
                          style: TextStyle(
                            color: Color(0xFF1F4D6B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "RM ${totalBalance.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F4D6B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Income & Expense Boxes with tap
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _filter = TransactionFilter.income;
                            });
                          },
                          child: _buildSummaryBox(
                            "Income",
                            "RM 4,120.00",
                            Icons.arrow_outward_rounded,
                            Colors.teal,
                            isSelected: _filter == TransactionFilter.income,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _filter = TransactionFilter.expense;
                            });
                          },
                          child: _buildSummaryBox(
                            "Expense",
                            "RM 1,187.40",
                            Icons.call_received_rounded,
                            Colors.blueAccent,
                            isSelected: _filter == TransactionFilter.expense,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Show All button
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _filter = TransactionFilter.all;
                      });
                    },
                    child: const Text(
                      "Show All",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // TRANSACTION LIST
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: _filteredTransactions,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryBox(
    String title,
    String amount,
    IconData icon,
    Color color, {
    bool isSelected = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? color.withOpacity(0.2) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isSelected
            ? Border.all(color: color, width: 2)
            : Border.all(color: Colors.transparent),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 5),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final String title, subtitle, category, amount;
  final IconData icon;
  final Color iconBgColor;
  final bool isPositive;

  const _TransactionTile({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.amount,
    required this.icon,
    required this.iconBgColor,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: iconBgColor,
            child: Icon(icon, color: Colors.white),
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
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 30,
            width: 1,
            color: Colors.grey.shade300,
            margin: const EdgeInsets.symmetric(horizontal: 10),
          ),
          SizedBox(
            width: 60,
            child: Text(
              category,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          Text(
            isPositive ? "RM $amount" : "-RM $amount",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isPositive ? Colors.black : Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}
