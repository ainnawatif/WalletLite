import 'package:flutter/material.dart';
import '../models/expense.dart';

class AddExpenseCategoriesPage extends StatefulWidget {
  final String? categoryId;
  const AddExpenseCategoriesPage({super.key, this.categoryId});

  @override
  State<AddExpenseCategoriesPage> createState() => _AddExpenseCategoriesPageState();
}

class _AddExpenseCategoriesPageState extends State<AddExpenseCategoriesPage> {
  final titleCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  final messageCtrl = TextEditingController();
  late DateTime _selectedDate;
  String? _errorMessage;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedCategory = widget.categoryId;
  }

  void _saveExpense() {
    // Validation
    if (titleCtrl.text.isEmpty) {
      setState(() => _errorMessage = "Please enter expense title");
      return;
    }

    if (amountCtrl.text.isEmpty) {
      setState(() => _errorMessage = "Please enter amount");
      return;
    }

    try {
      final amount = double.parse(amountCtrl.text);
      if (amount <= 0) {
        setState(() => _errorMessage = "Amount must be greater than 0");
        return;
      }

      final expense = Expense(
        title: titleCtrl.text,
        amount: amount,
        date: _selectedDate,
      );
      Navigator.pop(context, expense);
    } catch (e) {
      setState(() => _errorMessage = "Invalid amount. Please enter a valid number");
    }
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    amountCtrl.dispose();
    messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF1F4D6B),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          "Add Expenses",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.lock, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Form
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Section
                    const Text(
                      "Date",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F4D6B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4FF),
                        border: Border.all(color: Colors.blue[200]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate:
                                DateTime(_selectedDate.year - 1),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => _selectedDate = picked);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF1F4D6B),
                              ),
                            ),
                            const Icon(Icons.calendar_today,
                                size: 20, color: Color(0xFF1F4D6B)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Category Section (optional)
                    const Text(
                      "Category",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F4D6B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4FF),
                        border: Border.all(color: Colors.blue[200]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedCategory ?? "Select the category",
                            style: TextStyle(
                              fontSize: 14,
                              color: _selectedCategory != null
                                  ? const Color(0xFF1F4D6B)
                                  : Colors.grey,
                            ),
                          ),
                          Icon(Icons.arrow_drop_down,
                              color: Colors.blue[300]),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Amount Section
                    const Text(
                      "Amount",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F4D6B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4FF),
                        border: Border.all(color: Colors.blue[200]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: amountCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "RM 26.00",
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        onChanged: (_) =>
                            setState(() => _errorMessage = null),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Expense Title Section
                    const Text(
                      "Expense Title",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F4D6B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4FF),
                        border: Border.all(color: Colors.blue[200]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: titleCtrl,
                        decoration: InputDecoration(
                          hintText: "Dinner",
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        onChanged: (_) =>
                            setState(() => _errorMessage = null),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Message Section
                    const Text(
                      "Enter Message",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F4D6B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4FF),
                        border: Border.all(color: Colors.blue[200]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: messageCtrl,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "Add notes...",
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(12),
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Error Message
                    if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveExpense,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1F4D6B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
