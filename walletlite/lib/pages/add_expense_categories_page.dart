import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/transaction_model.dart';
import '../services/firestore_service.dart';
import 'dart:developer' as developer;

class AddExpenseCategoriesPage extends StatefulWidget {
  final String? categoryId;
  const AddExpenseCategoriesPage({super.key, this.categoryId});

  @override
  State<AddExpenseCategoriesPage> createState() =>
      _AddExpenseCategoriesPageState();
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

  void _saveExpense() async {
    if (titleCtrl.text.isEmpty) {
      setState(() => _errorMessage = "Please enter expense title");
      return;
    }

    if (amountCtrl.text.isEmpty) {
      setState(() => _errorMessage = "Please enter amount");
      return;
    }

    if (_selectedCategory == null) {
      setState(() => _errorMessage = "Please select a category");
      return;
    }

    setState(() => _errorMessage = null);

    try {
      final amount = double.parse(amountCtrl.text);
      if (amount <= 0) {
        setState(() => _errorMessage = "Amount must be greater than 0");
        return;
      }

      // Create TransactionModel
      final newTransaction = TransactionModel(
        title: titleCtrl.text.trim(),
        amount: amount,
        date: _selectedDate,
        category: _selectedCategory!,
        note: messageCtrl.text.trim(),
        isIncome: false,
      );

      // Save to Firestore
      final result = await FirestoreService().addTransaction(newTransaction);

      if (result != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Expense saved successfully!")),
          );
          Navigator.pop(context);
        }
      } else {
        setState(() => _errorMessage = "Failed to save expense");
      }
    } catch (e) {
      developer.log("Error saving expense: $e");
      setState(() => _errorMessage = "Error saving expense: $e");
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

      // ================= BODY =================
      body: Column(
        children: [
          // ===== HEADER (MATCH CATEGORY PAGE) =====
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
            decoration: const BoxDecoration(
              color: Color(0xFF1F4D6B),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock, color: Colors.white),
                ),
              ],
            ),
          ),

          // ===== FORM =====
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label("Date"),
                  _datePicker(),
                  const SizedBox(height: 16),

                  _label("Category"),
                  _categoryBox(),
                  const SizedBox(height: 16),

                  _label("Amount"),
                  _inputBox(
                    controller: amountCtrl,
                    hint: "Eg: RM 250.00",
                    keyboard: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  _label("Expense Title"),
                  _inputBox(controller: titleCtrl, hint: "Eg: Dinner"),
                  const SizedBox(height: 16),

                  _label("Enter Message"),
                  _messageBox(),
                  const SizedBox(height: 24),

                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),
        ],
      ),

      // ================= FIXED BOTTOM BUTTON =================
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: ElevatedButton(
            onPressed: _saveExpense,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1F4D6B),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 6,
            ),
            child: const Text(
              "Add Expense",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1F4D6B),
      ),
    );
  }

  Widget _inputBox({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
        onChanged: (_) => setState(() => _errorMessage = null),
      ),
    );
  }

  Widget _messageBox() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: TextField(
        controller: messageCtrl,
        maxLines: 5,
        decoration: const InputDecoration(
          hintText: "Add notes...",
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(12),
        ),
      ),
    );
  }

  Widget _categoryBox() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _selectedCategory ?? "Select the category",
            style: TextStyle(
              color: _selectedCategory != null
                  ? const Color(0xFF1F4D6B)
                  : Colors.grey,
            ),
          ),
          Icon(Icons.arrow_drop_down, color: Colors.blue.shade300),
        ],
      ),
    );
  }

  Widget _datePicker() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: GestureDetector(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime(_selectedDate.year - 1),
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
              style: const TextStyle(color: Color(0xFF1F4D6B)),
            ),
            const Icon(
              Icons.calendar_today,
              size: 18,
              color: Color(0xFF1F4D6B),
            ),
          ],
        ),
      ),
    );
  }
}
