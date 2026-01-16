import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../services/firestore_service.dart';
import 'home_page.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  int _selectedTab = 1; // 0=Daily, 1=Weekly, 2=Monthly, 3=Year
  final List<String> _tabs = ["Daily", "Weekly", "Monthly", "Year"];

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

  Widget _summaryItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _chartGroups(List<TransactionModel> transactions) {
    // Group by selected tab
    Map<int, Map<String, double>> groupedData = {};

    for (var transaction in transactions) {
      int key;
      if (_selectedTab == 0) {
        // Daily
        key = transaction.date.day;
      } else if (_selectedTab == 1) {
        // Weekly
        key =
            (transaction.date
                        .difference(DateTime(transaction.date.year, 1, 1))
                        .inDays /
                    7)
                .floor();
      } else if (_selectedTab == 2) {
        // Monthly
        key = transaction.date.month;
      } else {
        // Yearly
        key = transaction.date.year;
      }

      groupedData.putIfAbsent(key, () => {'income': 0, 'expense': 0});
      if (transaction.isIncome) {
        groupedData[key]!['income'] =
            (groupedData[key]!['income'] ?? 0) + transaction.amount;
      } else {
        groupedData[key]!['expense'] =
            (groupedData[key]!['expense'] ?? 0) + transaction.amount;
      }
    }

    // Create bar groups
    List<BarChartGroupData> groups = [];
    int index = 0;
    groupedData.forEach((key, values) {
      groups.add(
        _makeGroup(index, values['expense'] ?? 0, values['income'] ?? 0),
      );
      index++;
    });

    // If no data, show empty
    if (groups.isEmpty) {
      groups = [_makeGroup(0, 0, 0)];
    }

    return groups.take(4).toList(); // Show first 4
  }

  BarChartGroupData _makeGroup(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: y1, color: const Color(0xFFFF8A8A), width: 8),
        BarChartRodData(toY: y2, color: const Color(0xFF2196F3), width: 8),
      ],
    );
  }

  Widget _bottomTitles(double value, TitleMeta meta) {
    List<String> labels;
    if (_selectedTab == 0) {
      // Daily
      labels = ["Day 1", "Day 2", "Day 3", "Day 4"];
    } else if (_selectedTab == 1) {
      // Weekly
      labels = ["Week 1", "Week 2", "Week 3", "Week 4"];
    } else if (_selectedTab == 2) {
      // Monthly
      labels = ["Jan", "Feb", "Mar", "Apr"];
    } else {
      // Yearly
      labels = ["2023", "2024", "2025", "2026"];
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        labels[value.toInt() % labels.length],
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FB),
      body: StreamBuilder<List<TransactionModel>>(
        stream: FirestoreService().getAllTransactionsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final transactions = snapshot.data ?? [];

          // Calculate totals
          double totalIncome = transactions
              .where((t) => t.isIncome)
              .fold(0, (sum, item) => sum + item.amount);
          double totalExpense = transactions
              .where((t) => !t.isIncome)
              .fold(0, (sum, item) => sum + item.amount);
          double totalBalance = totalIncome - totalExpense;

          return SingleChildScrollView(
            child: Column(
              children: [
                // HEADER SECTION
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
                            "Statistics",
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
                      // Balance & Expense Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _headerStat(
                            "Total Balance",
                            NumberFormat.currency(
                              locale: 'en_MY',
                              symbol: 'RM ',
                            ).format(totalBalance),
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
                            NumberFormat.currency(
                              locale: 'en_MY',
                              symbol: '-RM ',
                            ).format(totalExpense),
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
                              width: totalExpense > 0
                                  ? MediaQuery.of(context).size.width *
                                        (totalExpense /
                                            (totalIncome + totalExpense))
                                  : 0,
                              decoration: BoxDecoration(
                                color: const Color(0xFF26A69A),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                totalExpense > 0
                                    ? "${((totalExpense / (totalIncome + totalExpense)) * 100).toStringAsFixed(0)}%"
                                    : "0%",
                                style: const TextStyle(
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
                                "RM 20,000.00",
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
                            totalExpense > 0
                                ? "${((totalExpense / (totalIncome + totalExpense)) * 100).toStringAsFixed(0)}% Of Your Expenses"
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

                // TAB SELECTOR
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 25,
                  ),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1E9F6),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(_tabs.length, (index) {
                      bool isSelected = _selectedTab == index;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTab = index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF1F4D6B)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            _tabs[index],
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF1F4D6B),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // CHART CARD
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1E9F6),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Income & Expenses",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF1F4D6B),
                            ),
                          ),
                          Row(
                            children: const [
                              Icon(Icons.search, color: Color(0xFF1F4D6B)),
                              SizedBox(width: 10),
                              Icon(
                                Icons.calendar_today,
                                color: Color(0xFF1F4D6B),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            maxY: () {
                              if (transactions.isEmpty) return 10.0;
                              double maxAmount = transactions
                                  .map((t) => t.amount)
                                  .reduce((a, b) => a > b ? a : b);
                              return maxAmount + 10;
                            }(),
                            barGroups: _chartGroups(transactions),
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              getDrawingHorizontalLine: (value) => FlLine(
                                color: Colors.white30,
                                strokeWidth: 1,
                                dashArray: [5, 5],
                              ),
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (v, m) => Text(
                                    "${v.toInt()}",
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: _bottomTitles,
                                ),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // SUMMARY BOTTOM
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _summaryItem(
                        "Income",
                        NumberFormat.currency(
                          locale: 'en_MY',
                          symbol: 'RM ',
                        ).format(totalIncome),
                        Icons.arrow_outward,
                        Colors.teal,
                      ),
                      _summaryItem(
                        "Expense",
                        NumberFormat.currency(
                          locale: 'en_MY',
                          symbol: 'RM ',
                        ).format(totalExpense),
                        Icons.call_received,
                        Colors.blueAccent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
