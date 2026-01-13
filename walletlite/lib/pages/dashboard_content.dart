import 'package:flutter/material.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
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
                        "RM 7,783.00",
                        Icons.outbond_outlined,
                        Colors.white,
                      ),
                      Container(height: 40, width: 1, color: Colors.white30),
                      _headerStat(
                        "Total Expense",
                        "-RM 1,187.40",
                        Icons.move_to_inbox_outlined,
                        const Color(0xFFFF8A8A),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // Progress Bar
                  Container(
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            color: const Color(0xFF26A69A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "30%",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Positioned(
                          right: 12,
                          top: 4,
                          child: Text(
                            "\$20,000.00",
                            style: TextStyle(
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
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Icon(
                        Icons.check_box_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "30% Of Your Expenses, Looks Good.",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
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
                                    value: 0.7,
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
                        Container(height: 80, width: 1, color: Colors.white24),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            children: [
                              _goalRow(
                                Icons.payments,
                                "Revenue Last Week",
                                "RM 4.000.00",
                                Colors.white,
                              ),
                              const Divider(color: Colors.white24),
                              _goalRow(
                                Icons.restaurant,
                                "Food Last Week",
                                "-RM 100.00",
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
                      children: ["Daily", "Weekly", "Monthly"].map((tab) {
                        bool isMonthly = tab == "Monthly";
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isMonthly
                                ? const Color(0xFF1F4D6B)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tab,
                            style: TextStyle(
                              color: isMonthly ? Colors.white : Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // --- TRANSACTIONS ---
                  _transactionTile(
                    "Salary",
                    "18:27 - April 30",
                    "Monthly",
                    "RM 400,00",
                    Colors.blue,
                    Colors.blue,
                  ),
                  _transactionTile(
                    "Groceries",
                    "17:00 - April 24",
                    "Pantry",
                    "-RM 100,00",
                    Colors.lightBlue,
                    Colors.red,
                  ),
                  _transactionTile(
                    "Rent",
                    "8:30 - April 15",
                    "Rent",
                    "-RM 674,40",
                    Colors.blueAccent,
                    Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
