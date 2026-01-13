# Firebase Integration Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    WalletLite App (Flutter)                 │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────────┐  ┌──────────────────┐                │
│  │  Category Page   │  │ Category Detail  │                │
│  │  - List View     │→ │ - Expense List   │                │
│  │  - Add Button    │  │ - Add Expense    │                │
│  │  - Delete Button │  │ - Total Display  │                │
│  └────────┬─────────┘  └────────┬─────────┘                │
│           │                     │                            │
│           └──────────┬──────────┘                            │
│                      │                                       │
│           ┌──────────▼──────────┐                            │
│           │ FirestoreService    │                            │
│           │ (Singleton Pattern) │                            │
│           │                     │                            │
│           │ Methods:            │                            │
│           │ - getCategories()   │                            │
│           │ - addCategory()     │                            │
│           │ - deleteCategory()  │                            │
│           │ - getExpenses()     │                            │
│           │ - addExpense()      │                            │
│           │ - deleteExpense()   │                            │
│           │ - Streams for RT    │                            │
│           └──────────┬──────────┘                            │
│                      │                                       │
└──────────────────────┼───────────────────────────────────────┘
                       │
        ┌──────────────┴──────────────┐
        │                             │
        ▼                             ▼
┌───────────────────┐       ┌─────────────────────┐
│ Firebase Core     │       │  Cloud Firestore    │
│ (Initialization)  │       │  (Data Storage)     │
│                   │       │                     │
│ main.dart:        │       │ Collections:        │
│ Firebase.init()   │       │ - categories        │
│                   │       │   └─ expenses       │
│                   │       │                     │
│                   │       │ Real-time Sync:     │
│                   │       │ - Snapshots()       │
│                   │       │ - StreamBuilder     │
└───────────────────┘       └─────────────────────┘
```

---

## Data Flow Diagram

### Adding a Category

```
CategoryPage
    │
    └─ User Taps "+" Button
         │
         └─ _addCategory() Dialog Opens
              │
              └─ User Types Name & Taps "Add"
                   │
                   ├─ Validation Check
                   │   ├─ ✅ Valid
                   │   │   │
                   │   │   └─ FirestoreService.addCategory(name)
                   │   │        │
                   │   │        └─ _categoriesCollection.add({
                   │   │             'name': name,
                   │   │             'createdAt': now
                   │   │           })
                   │   │            │
                   │   │            └─ ✅ Document Created in Firestore
                   │   │                 │
                   │   │                 └─ categoryId Returned
                   │   │                      │
                   │   │                      └─ _loadCategories()
                   │   │                           │
                   │   │                           └─ setState() → UI Updates
                   │   │                                │
                   │   │                                └─ ✅ Success Message
                   │   │
                   │   └─ ❌ Invalid (empty)
                   │       └─ Error Message Shows
                   │
```

### Adding an Expense

```
CategoryDetailPage
    │
    └─ User Taps "Add Expense" Button
         │
         └─ Navigate to AddExpensePage
              │
              └─ User Enters Title & Amount
                   │
                   └─ User Taps "Save Expense"
                        │
                        ├─ Validation Check
                        │   ├─ Title not empty?
                        │   ├─ Amount not empty?
                        │   ├─ Amount > 0?
                        │   │
                        │   └─ ✅ All Valid
                        │       │
                        │       └─ Create Expense Object
                        │            │
                        │            └─ Navigator.pop(expense)
                        │                 │
                        │                 └─ Back to CategoryDetailPage
                        │                      │
                        │                      └─ Check: expense != null?
                        │                          │
                        │                          └─ ✅ Yes
                        │                              │
                        │                              └─ FirestoreService.addExpense()
                        │                                   │
                        │                                   └─ _categoriesCollection
                        │                                        .doc(categoryId)
                        │                                        .collection('expenses')
                        │                                        .add(expense.toMap())
                        │                                        │
                        │                                        └─ ✅ Document Created
                        │                                            │
                        │                                            └─ StreamBuilder Triggers
                        │                                                │
                        │                                                └─ getExpensesStream()
                        │                                                    │
                        │                                                    └─ ✅ List Updates
                        │                                                        │
                        │                                                        └─ Total Calculates
                        │                                                            │
                        │                                                            └─ ✅ UI Refreshes
```

---

## Component Interaction Diagram

```
┌─────────────────────────────────────────────────────────┐
│                     Models Layer                        │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Category {                  Expense {                  │
│    id: String?                 id: String?              │
│    name: String                title: String            │
│    expenses: List               amount: double           │
│    toMap()                       date: DateTime          │
│    fromMap()                     toMap()                 │
│  }                              fromMap()                │
│                               }                         │
└─────────────────────────────────────────────────────────┘
         │                                │
         └────────────┬───────────────────┘
                      │
┌─────────────────────┴──────────────────────────────────┐
│              Services Layer                            │
├───────────────────────────────────────────────────────┤
│                                                       │
│  FirestoreService (Singleton)                        │
│  ├─ getCategories() → Future<List<Category>>         │
│  ├─ getCategoriesStream() → Stream<List<Category>>   │
│  ├─ addCategory(name) → Future<String?>              │
│  ├─ updateCategory(id, name) → Future<void>          │
│  ├─ deleteCategory(id) → Future<void>                │
│  ├─ getExpenses(categoryId) → Future<List<Expense>>  │
│  ├─ getExpensesStream(id) → Stream<List<Expense>>    │
│  ├─ addExpense(catId, exp) → Future<String?>         │
│  ├─ updateExpense(catId, expId, exp) → Future<void>  │
│  └─ deleteExpense(catId, expId) → Future<void>       │
│                                                       │
└───────────────────┬──────────────────────────────────┘
                    │
┌───────────────────┴──────────────────────────────────┐
│              UI Layer (Pages)                        │
├───────────────────────────────────────────────────────┤
│                                                       │
│  CategoryPage              CategoryDetailPage        │
│  ├─ _loadCategories()      ├─ _expensesStream       │
│  ├─ _addCategory()         ├─ StreamBuilder         │
│  ├─ ListView               ├─ Delete Expense        │
│  └─ Delete Category        └─ Total Display         │
│                                                       │
│  AddExpensePage                                       │
│  ├─ Validation                                       │
│  ├─ Input Fields                                     │
│  └─ Save Button                                      │
│                                                       │
└────────────────────────────────────────────────────────┘
```

---

## Real-Time Sync Flow

```
Device A (User 1)           Firebase Firestore           Device B (User 2)
     │                              │                             │
     │──── Add Category ───────────→ │                             │
     │                              │──── Document Created ───────→ │
     │                              │                             │
     │                              │──── Snapshot Event ────────→ │
     │                              │                             │
     │←─── CategoryPage Updates ────│                             │
     │                              │──── CategoryDetailPage ────→ │
     │                              │       Updates               │
```

---

## Error Handling Flow

```
User Action
    │
    └─ Firebase Operation Called
         │
         ├─ ✅ Success
         │   │
         │   └─ docId/result Returned
         │       │
         │       └─ setState() or StreamBuilder updates
         │           │
         │           └─ Success SnackBar
         │
         └─ ❌ Error
             │
             ├─ catch(e)
             │   │
             │   ├─ print('Error: $e')
             │   │
             │   └─ return null or re-throw
             │
             └─ UI Error Message
                 │
                 └─ SnackBar or AlertDialog
```

---

## Firestore Document Structure

```
Firestore
│
└── categories (collection)
    │
    ├── doc_id_1
    │   ├── name: "Food" (string)
    │   ├── createdAt: 2024-01-13T10:30:00Z (timestamp)
    │   │
    │   └── expenses (subcollection)
    │       ├── exp_id_1
    │       │   ├── title: "Lunch" (string)
    │       │   ├── amount: 25.50 (number)
    │       │   └── date: "2024-01-13T12:30:00Z" (string)
    │       │
    │       └── exp_id_2
    │           ├── title: "Snack" (string)
    │           ├── amount: 10.00 (number)
    │           └── date: "2024-01-13T15:45:00Z" (string)
    │
    └── doc_id_2
        ├── name: "Transport" (string)
        ├── createdAt: 2024-01-12T08:00:00Z (timestamp)
        │
        └── expenses (subcollection)
            └── exp_id_3
                ├── title: "Bus Fare" (string)
                ├── amount: 3.50 (number)
                └── date: "2024-01-13T08:00:00Z" (string)
```

---

## Authentication & Security (Future)

```
┌──────────────────────────────────────────┐
│   Currently: Public Access (Dev Mode)     │
│   Rules: allow read, write: if true;     │
└──────────────────────────────────────────┘
            │
            │ (Upgrade for Production)
            ▼
┌──────────────────────────────────────────┐
│   Firebase Authentication                │
│   ├─ Email/Password                     │
│   ├─ Google Sign-In                     │
│   └─ Other Providers                    │
└────────────┬─────────────────────────────┘
             │
             ▼
┌──────────────────────────────────────────┐
│   Security Rules with Auth               │
│   ├─ User-specific data access          │
│   ├─ Field-level validation              │
│   └─ Prevent unauthorized writes         │
└──────────────────────────────────────────┘
```

---

## Performance Optimization (Future)

```
Current:
├─ Real-time Streams (✅ Fast)
└─ Document-level queries (✅ Efficient)

Optimizations to Consider:
├─ Pagination (for many categories)
├─ Local Caching (Firestore offline support)
├─ Indexes (for complex queries)
└─ Batch Operations (for bulk changes)
```

---

**This architecture ensures:**
- ✅ Separation of concerns (Models, Services, UI)
- ✅ Real-time data synchronization
- ✅ Error handling at every step
- ✅ Scalable structure for future features
- ✅ Easy testing and maintenance
