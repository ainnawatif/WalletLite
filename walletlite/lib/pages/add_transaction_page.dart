import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart'; // import your BottomNav
import 'add_income_page.dart';
import 'add_expense_page.dart';

class AddTransactionPage extends StatelessWidget {
  final String? categoryId;
  final String? categoryName;
  const AddTransactionPage({super.key, this.categoryId, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFEFF6FB),
        body: SafeArea(
          child: Column(
            children: [
              // HEADER + BACK BUTTON + TAB BAR
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
                    // Back button row
                    Row(
                      children: [
                        const SizedBox(width: 8),
                        const Text(
                          "Add Transaction",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Pill-style TabBar
                    Container(
                      height: 50,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        labelColor: const Color(0xFF1F4D6B),
                        unselectedLabelColor: Colors.white,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        tabs: const [
                          Tab(text: "Income"),
                          Tab(text: "Expenses"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // TAB CONTENT
              const Expanded(
                child: TabBarView(
                  children: [AddIncomePage(), AddExpensePage()],
                ),
              ),
            ],
          ),
        ),

        // Bottom Navigation Bar
        bottomNavigationBar: BottomNav(
          currentIndex: 2, // highlight the Add Transaction tab
          onTap: (index) {
            // handle navigation back to HomePage tabs
            Navigator.pop(context); // or use your HomePage logic
          },
        ),
      ),
    );
  }
}
