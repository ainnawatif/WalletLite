import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'dashboard_content.dart';
import 'transaction_page.dart'; // This will now be our "Global" version
import 'statistic_page.dart';
import 'profile_page.dart';
import 'category_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // We remove 'const' here because these widgets are now dynamic
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const DashboardContent(),
      const StatisticPage(),
      // We pass null or 'All' to indicate this is the Global View
      const TransactionPage(
        categoryId: 'all',
        categoryName: 'All Transactions',
      ),
      const CategoryPage(),
      const ProfilePage(),
    ];
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Using IndexedStack preserves the scroll position of your lists
      // when switching tabs so you don't lose your place.
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
