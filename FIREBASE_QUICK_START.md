# WalletLite Firebase - Quick Setup Checklist

## ✅ What's Been Set Up

- ✅ Firebase Core & Firestore dependencies added to `pubspec.yaml`
- ✅ Firestore Service with all CRUD operations (Create, Read, Update, Delete)
- ✅ Models updated with Firestore serialization (toMap/fromMap)
- ✅ All UI pages connected to Firestore
- ✅ Real-time data sync with StreamBuilder
- ✅ Error handling and success feedback
- ✅ Input validation on all forms
- ✅ Delete confirmations with dialogs

## 🚀 To Get It Working NOW

### Step 1: Get Your Firebase Credentials
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Sign in with your Google account
3. Create a new project or use an existing one
4. Go to **Project Settings** (gear icon ⚙️)
5. Copy your `projectId` - looks like: `walletlite-xxxxx`

### Step 2: Update firebase_options.dart
Replace the placeholder values in `lib/firebase_options.dart`:

For **Android**, get credentials from:
- Firebase Console → Your Android App → google-services.json
- Copy the values to the `android` configuration

For **iOS**, get credentials from:
- Firebase Console → Your iOS App → GoogleService-Info.plist
- Values auto-apply when you add the plist file to Xcode

For **Web**, copy from Firebase Console script:
```
<script>
  const firebaseConfig = {
    apiKey: "YOUR_API_KEY",
    projectId: "walletlite-xxxxx",
    messagingSenderId: "123456789",
    appId: "1:123456789:web:abc...",
  };
</script>
```

### Step 3: Set Firestore Rules
1. In Firebase Console → **Firestore Database** → **Rules**
2. Replace with:
```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;  // For development only!
    }
  }
}
```
3. **Publish** the rules

### Step 4: Run the App
```bash
cd walletlite
flutter pub get
flutter run
```

## 📲 How All Buttons Work Now

| Button | Location | Function | Firebase Action |
|--------|----------|----------|-----------------|
| **+ (FAB)** | Categories Page | Opens add category dialog | Creates doc in `categories` collection |
| **Add** | Category Dialog | Saves category | Inserts to Firestore |
| **Category Tile** | Categories Page | Navigate to details | — |
| **Delete Icon** | Category Item | Delete category | Removes category & all expenses |
| **Add Expense (FAB)** | Category Detail | Navigate to add expense page | — |
| **Save Expense** | Add Expense Page | Save & return | Inserts to `categories/{id}/expenses` |
| **Delete** | Expense Item | Delete expense | Removes expense doc |

## 🔍 How to Verify It's Working

1. Run the app
2. Add a category (e.g., "Food")
3. Go to [Firebase Console](https://console.firebase.google.com/) → Firestore Database
4. You should see:
   ```
   collections
   └── categories
       └── [document with name: "Food"]
   ```
5. Add an expense to the category
6. In Firestore, expand the category document:
   ```
   collections
   └── categories
       └── [category doc]
           └── expenses
               └── [expense doc with title, amount, date]
   ```

## ❌ Common Issues & Fixes

### Collections don't appear in Firestore?
- [ ] Check you're in the correct Firebase project
- [ ] Verify Firestore rules allow write access
- [ ] Check Android Studio logcat for errors: `flutter run -v`

### "Permissions denied" error?
- [ ] Update Firestore rules to: `allow read, write: if true;`
- [ ] Make sure you **published** the rules (don't just edit)

### App crashes when adding category?
- [ ] Check `firebase_options.dart` has correct credentials
- [ ] Ensure `projectId` matches your Firebase project
- [ ] Check that Firestore Database is enabled in Firebase Console

### Data not persisting?
- [ ] Verify Firebase initialization in `main.dart` completes before `runApp()`
- [ ] Check internet connection on device
- [ ] Ensure Firestore rules allow the operation

### Still seeing "YOUR_" placeholder values?
- [ ] You haven't updated `firebase_options.dart` with real credentials yet
- [ ] This is the first thing to fix!

## 📝 Data Structure in Firestore

When you use the app, this structure is created automatically:

```
Firestore Database
└── collections
    └── categories
        └── [auto-generated-id]
            ├── name: "Food" (string)
            ├── createdAt: timestamp
            └── expenses (subcollection)
                └── [auto-generated-id]
                    ├── title: "Lunch" (string)
                    ├── amount: 25.50 (number)
                    └── date: "2024-01-13T..." (string)
```

## 🎯 What Happens When You Click Each Button

### Add Category Button
1. Dialog appears
2. Enter category name
3. Click "Add"
4. ✅ Document created in `categories` collection
5. ✅ Page updates with new category
6. ✅ Success message shows

### Add Expense Button
1. Navigate to add expense page
2. Enter title and amount
3. Click "Save Expense"
4. ✅ Document created in `categories/{id}/expenses`
5. ✅ Stream updates category detail page
6. ✅ Total spent updates automatically

### Delete Category Button
1. Confirmation dialog appears
2. Click "Delete"
3. ✅ All expenses in that category deleted first
4. ✅ Category document deleted
5. ✅ Page refreshes automatically

## 💡 Pro Tips

- **Data syncs in real-time** - Open Firestore console in one tab, app in another to see instant updates!
- **Try it on multiple devices** - Add data on one device, see it update on another instantly
- **Check logs** - Run with `flutter run -v` to see Firebase initialization logs

## ⚠️ Important for Production

Before releasing:
- [ ] Implement Firebase Authentication
- [ ] Use user-specific security rules
- [ ] Never leave rules as `allow read, write: if true;`
- [ ] Add data validation on the backend
- [ ] Test with real user IDs

---

**You're all set!** 🎉 All the data will now save to Firebase automatically when you click the buttons.
