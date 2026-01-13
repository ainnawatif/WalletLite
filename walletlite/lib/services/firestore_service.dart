import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category.dart';
import '../models/expense.dart';
import 'dart:developer' as developer;

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();

  factory FirestoreService() {
    return _instance;
  }

  FirestoreService._internal() {
    // Log initialization
    developer.log('FirestoreService initialized');
    print('✓ FirestoreService initialized');
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get _categoriesCollection => _db.collection('categories');

  // Debug method - Test Firebase connection
  Future<bool> testConnection() async {
    try {
      developer.log('Testing Firebase connection...');
      print('🔍 Testing Firebase connection...');
      
      await _categoriesCollection.limit(1).get();
      
      developer.log('✓ Firebase connection successful!');
      print('✓ Firebase connection successful!');
      return true;
    } catch (e) {
      developer.log('✗ Firebase connection failed: $e', error: e);
      print('✗ Firebase connection failed: $e');
      return false;
    }
  }

  // CATEGORY OPERATIONS

  /// Get all categories with their expenses
  Future<List<Category>> getCategories() async {
    try {
      developer.log('Fetching categories from Firestore');
      final querySnapshot = await _categoriesCollection.get();
      
      developer.log('Found ${querySnapshot.docs.length} categories');
      print('✓ Found ${querySnapshot.docs.length} categories');
      
      List<Category> categories = [];

      for (var doc in querySnapshot.docs) {
        final category = Category.fromMap(doc.data() as Map<String, dynamic>, doc.id);

        // Fetch expenses for this category
        final expensesSnapshot = await _categoriesCollection
            .doc(doc.id)
            .collection('expenses')
            .get();

        for (var expenseDoc in expensesSnapshot.docs) {
          final expense = Expense.fromMap(
            expenseDoc.data(),
            expenseDoc.id,
          );
          category.expenses.add(expense);
        }

        categories.add(category);
      }

      return categories;
    } catch (e) {
      developer.log('Error fetching categories: $e', error: e);
      print('✗ Error fetching categories: $e');
      return [];
    }
  }

  /// Add a new category
  Future<String?> addCategory(String name) async {
    try {
      developer.log('Adding category: $name');
      print('📝 Adding category: "$name"');
      
      // Use the category name as the document ID
      await _categoriesCollection.doc(name).set({
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      developer.log('✓ Category added with ID: $name');
      print('✓ Category saved with ID: $name');
      print('📌 Check Firestore Console: collections > categories > $name');
      
      return name;
    } catch (e) {
      developer.log('Error adding category: $e', error: e);
      print('✗ Error adding category: $e');
      print('⚠️ Check that Firestore rules allow WRITE access!');
      return null;
    }
  }

  /// Update a category
  Future<void> updateCategory(String categoryId, String newName) async {
    try {
      developer.log('Updating category: $categoryId');
      print('📝 Updating category: "$categoryId"');
      
      await _categoriesCollection.doc(categoryId).update({
        'name': newName,
      });
      
      developer.log('✓ Category updated');
      print('✓ Category updated successfully');
    } catch (e) {
      developer.log('Error updating category: $e', error: e);
      print('✗ Error updating category: $e');
    }
  }

  /// Delete a category
  Future<void> deleteCategory(String categoryId) async {
    try {
      developer.log('Deleting category: $categoryId');
      print('🗑️ Deleting category: "$categoryId"');
      
      // Delete all expenses in this category first
      final expensesSnapshot = await _categoriesCollection
          .doc(categoryId)
          .collection('expenses')
          .get();

      print('   Deleting ${expensesSnapshot.docs.length} expenses...');
      
      for (var doc in expensesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete the category
      await _categoriesCollection.doc(categoryId).delete();
      
      developer.log('✓ Category deleted');
      print('✓ Category and all expenses deleted successfully');
    } catch (e) {
      developer.log('Error deleting category: $e', error: e);
      print('✗ Error deleting category: $e');
    }
  }

  // EXPENSE OPERATIONS

  /// Add an expense to a category
  Future<String?> addExpense(String categoryId, Expense expense) async {
    try {
      developer.log('Adding expense to category: $categoryId');
      print('📝 Adding expense: "${expense.title}" (RM ${expense.amount})');
      
      // Use the expense title as the document ID
      await _categoriesCollection
          .doc(categoryId)
          .collection('expenses')
          .doc(expense.title)
          .set(expense.toMap());
      
      developer.log('✓ Expense added with ID: ${expense.title}');
      print('✓ Expense saved with ID: ${expense.title}');
      print('📌 Check Firestore Console: categories > $categoryId > expenses > ${expense.title}');
      
      return expense.title;
    } catch (e) {
      developer.log('Error adding expense: $e', error: e);
      print('✗ Error adding expense: $e');
      print('⚠️ Check that Firestore rules allow WRITE access!');
      return null;
    }
  }

  /// Get expenses for a specific category
  Future<List<Expense>> getExpenses(String categoryId) async {
    try {
      developer.log('Fetching expenses for category: $categoryId');
      final querySnapshot = await _categoriesCollection
          .doc(categoryId)
          .collection('expenses')
          .get();

      developer.log('Found ${querySnapshot.docs.length} expenses');
      print('✓ Found ${querySnapshot.docs.length} expenses');
      
      List<Expense> expenses = [];
      for (var doc in querySnapshot.docs) {
        final expense = Expense.fromMap(doc.data(), doc.id);
        expenses.add(expense);
      }

      return expenses;
    } catch (e) {
      developer.log('Error fetching expenses: $e', error: e);
      print('✗ Error fetching expenses: $e');
      return [];
    }
  }

  /// Update an expense
  Future<void> updateExpense(
    String categoryId,
    String expenseId,
    Expense expense,
  ) async {
    try {
      developer.log('Updating expense: $expenseId');
      print('📝 Updating expense: "$expenseId"');
      
      await _categoriesCollection
          .doc(categoryId)
          .collection('expenses')
          .doc(expenseId)
          .update(expense.toMap());
      
      developer.log('✓ Expense updated');
      print('✓ Expense updated successfully');
    } catch (e) {
      developer.log('Error updating expense: $e', error: e);
      print('✗ Error updating expense: $e');
    }
  }

  /// Delete an expense
  Future<void> deleteExpense(String categoryId, String expenseId) async {
    try {
      developer.log('Deleting expense: $expenseId from category: $categoryId');
      print('🗑️ Deleting expense: "$expenseId"');
      
      await _categoriesCollection
          .doc(categoryId)
          .collection('expenses')
          .doc(expenseId)
          .delete();
      
      developer.log('✓ Expense deleted');
      print('✓ Expense deleted successfully');
    } catch (e) {
      developer.log('Error deleting expense: $e', error: e);
      print('✗ Error deleting expense: $e');
    }
  }

  /// Get expenses stream for real-time updates
  Stream<List<Expense>> getExpensesStream(String categoryId) {
    developer.log('Creating expenses stream for category: $categoryId');
    return _categoriesCollection
        .doc(categoryId)
        .collection('expenses')
        .snapshots()
        .map((snapshot) {
      developer.log('Expenses stream update: ${snapshot.docs.length} items');
      return snapshot.docs
          .map((doc) => Expense.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  /// Get categories stream for real-time updates
  Stream<List<Category>> getCategoriesStream() {
    developer.log('Creating categories stream');
    return _categoriesCollection.snapshots().map((snapshot) {
      developer.log('Categories stream update: ${snapshot.docs.length} items');
      return snapshot.docs
          .map((doc) => Category.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }
}
