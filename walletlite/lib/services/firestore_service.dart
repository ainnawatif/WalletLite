import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category.dart';
import '../models/expense.dart';
import '../models/transaction_model.dart';
import 'dart:developer' as developer;

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();

  factory FirestoreService() {
    return _instance;
  }

  FirestoreService._internal() {
    developer.log('FirestoreService initialized');
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get _categoriesCollection => _db.collection('categories');
  CollectionReference get _usersCollection => _db.collection('users');
  CollectionReference get _transactionsCollection =>
      _db.collection('transactions');

  // ==========================================
  // CATEGORY OPERATIONS
  // ==========================================

  Future<List<Category>> getCategories() async {
    try {
      final querySnapshot = await _categoriesCollection.get();
      List<Category> categories = [];

      for (var doc in querySnapshot.docs) {
        final category = Category.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );

        final expensesSnapshot = await _categoriesCollection
            .doc(doc.id)
            .collection('expenses')
            .get();

        for (var expenseDoc in expensesSnapshot.docs) {
          final expense = Expense.fromMap(
            expenseDoc.data() as Map<String, dynamic>,
            expenseDoc.id,
          );
          category.expenses.add(expense);
        }
        categories.add(category);
      }
      return categories;
    } catch (e) {
      developer.log('Error fetching categories: $e');
      return [];
    }
  }

  Future<String?> addCategory(String name) async {
    try {
      await _categoriesCollection.doc(name).set({
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return name;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateCategory(String categoryId, String newName) async {
    try {
      await _categoriesCollection.doc(categoryId).update({'name': newName});
    } catch (e) {
      developer.log('Error updating category: $e');
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      final expensesSnapshot = await _categoriesCollection
          .doc(categoryId)
          .collection('expenses')
          .get();

      for (var doc in expensesSnapshot.docs) {
        await doc.reference.delete();
      }
      await _categoriesCollection.doc(categoryId).delete();
    } catch (e) {
      developer.log('Error deleting category: $e');
    }
  }

  // ==========================================
  // EXPENSE OPERATIONS
  // ==========================================

  /// Fetch ALL expenses across all categories for the Global Transaction Tab
  Stream<List<Expense>> getAllExpensesStream() {
    return _db
        .collectionGroup('expenses')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Expense.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();
        });
  }

  Future<String?> addExpense(String categoryId, Expense expense) async {
    try {
      await _categoriesCollection
          .doc(categoryId)
          .collection('expenses')
          .doc(expense.title)
          .set(expense.toMap());
      return expense.title;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateExpense(
    String categoryId,
    String expenseId,
    Expense expense,
  ) async {
    try {
      await _categoriesCollection
          .doc(categoryId)
          .collection('expenses')
          .doc(expenseId)
          .update(expense.toMap());
    } catch (e) {
      developer.log('Error updating expense: $e');
    }
  }

  Future<void> deleteExpense(String categoryId, String expenseId) async {
    try {
      await _categoriesCollection
          .doc(categoryId)
          .collection('expenses')
          .doc(expenseId)
          .delete();
    } catch (e) {
      developer.log('Error deleting expense: $e');
    }
  }

  Stream<List<Expense>> getExpensesStream(String categoryId) {
    return _categoriesCollection
        .doc(categoryId)
        .collection('expenses')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) =>
                    Expense.fromMap(doc.data() as Map<String, dynamic>, doc.id),
              )
              .toList();
        });
  }

  Stream<List<Category>> getCategoriesStream() {
    return _categoriesCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) =>
                Category.fromMap(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList();
    });
  }

  // ==========================================
  // USER OPERATIONS
  // ==========================================

  Future<void> saveUser(
    String uid,
    String email,
    String? username,
    String? photoUrl,
  ) async {
    try {
      await _usersCollection.doc(uid).set({
        'email': email,
        'username': username ?? 'User',
        'photoUrl': photoUrl ?? '',
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      developer.log('Error saving user: $e');
    }
  }

  Stream<DocumentSnapshot> getUserStream(String uid) {
    return _usersCollection.doc(uid).snapshots();
  }

  /// RESTORED: Update a specific field for a user (e.g. phone number)
  Future<void> updateUserField(String uid, String key, dynamic value) async {
    try {
      developer.log('Updating user field: $key');
      await _usersCollection.doc(uid).update({key: value});
      print('✓ Updated user field: $key');
    } catch (e) {
      developer.log('Error updating user field: $e', error: e);
      print('✗ Error updating user field: $e');
    }
  }

  // ==========================================
  // TRANSACTION OPERATIONS
  // ==========================================

  Future<String?> addTransaction(TransactionModel transaction) async {
    try {
      final docRef = await _transactionsCollection.add(transaction.toMap());
      return docRef.id;
    } catch (e) {
      developer.log('Error adding transaction: $e');
      return null;
    }
  }

  Future<void> updateTransaction(
    String transactionId,
    TransactionModel transaction,
  ) async {
    try {
      await _transactionsCollection
          .doc(transactionId)
          .update(transaction.toMap());
    } catch (e) {
      developer.log('Error updating transaction: $e');
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _transactionsCollection.doc(transactionId).delete();
    } catch (e) {
      developer.log('Error deleting transaction: $e');
    }
  }

  Stream<List<TransactionModel>> getAllTransactionsStream() {
    return _transactionsCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return TransactionModel.fromSnapshot(doc);
          }).toList();
        });
  }

  Stream<List<TransactionModel>> getIncomeTransactionsStream() {
    return _transactionsCollection
        .where('isIncome', isEqualTo: true)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return TransactionModel.fromSnapshot(doc);
          }).toList();
        });
  }

  Stream<List<TransactionModel>> getExpenseTransactionsStream() {
    return _transactionsCollection
        .where('isIncome', isEqualTo: false)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return TransactionModel.fromSnapshot(doc);
          }).toList();
        });
  }

  Stream<List<TransactionModel>> getTransactionsByCategory(String category) {
    return _transactionsCollection
        .where('category', isEqualTo: category)
        .where(
          'isIncome',
          isEqualTo: false,
        ) // Assuming categories are for expenses
        .snapshots()
        .map((snapshot) {
          final transactions = snapshot.docs.map((doc) {
            return TransactionModel.fromSnapshot(doc);
          }).toList();
          transactions.sort(
            (a, b) => b.date.compareTo(a.date),
          ); // Sort descending
          return transactions;
        });
  }
}
