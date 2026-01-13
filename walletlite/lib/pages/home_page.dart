import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'dashboard_content.dart';
import 'transaction_page.dart';
import 'statistic_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardContent(), // Tab 0
    StatisticPage(), // Tab 1 (future page)
    TransactionPage(), // Tab 2 ← now shows both Income & Expenses tabs
    Placeholder(), // Tab 3 (future page)
    ProfilePage(), // Tab 4
  ];

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
