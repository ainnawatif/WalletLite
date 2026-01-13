import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'profile_page.dart';
import 'category_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  /// Handles page switching
  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _homeContent();
      case 3:
        return const CategoryPage(); // Categories
      case 4:
        return const ProfilePage(); // Profile
      default:
        return const Center(child: Text("Coming Soon"));
    }
  }

  /// HOME PAGE CONTENT (your original UI)
  Widget _homeContent() {
    return SafeArea(
      child: Column(
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF1F4D6B),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hi, Welcome Back",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _BalanceCard(
                      title: "Total Balance",
                      amount: "RM 7,783.00",
                      color: Colors.white,
                    ),
                    _BalanceCard(
                      title: "Total Expense",
                      amount: "-RM 1,187.40",
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // CONTENT
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: const [
                _TransactionTile(
                  title: "Salary",
                  date: "April 30",
                  amount: "RM 400.00",
                  positive: true,
                ),
                _TransactionTile(
                  title: "Groceries",
                  date: "April 24",
                  amount: "-RM 100.00",
                  positive: false,
                ),
                _TransactionTile(
                  title: "Rent",
                  date: "April 15",
                  amount: "-RM 674.40",
                  positive: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* =======================
   REUSABLE WIDGETS
   ======================= */

class _BalanceCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;

  const _BalanceCard({
    required this.title,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final String title;
  final String date;
  final String amount;
  final bool positive;

  const _TransactionTile({
    required this.title,
    required this.date,
    required this.amount,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: positive ? Colors.green : Colors.blue,
          child: const Icon(Icons.account_balance_wallet, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(date),
        trailing: Text(
          amount,
          style: TextStyle(
            color: positive ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
