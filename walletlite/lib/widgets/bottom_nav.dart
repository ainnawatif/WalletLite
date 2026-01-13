import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFD6EAF8), // light blue background
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(5, (index) {
          final icons = [
            Icons.home,
            Icons.bar_chart,
            Icons.swap_horiz,
            Icons.layers,
            Icons.person,
          ];

          final isSelected = index == currentIndex;

          return GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1F4D6B)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icons[index],
                color: isSelected ? Colors.white : const Color(0xFF1F4D6B),
              ),
            ),
          );
        }),
      ),
    );
  }
}
