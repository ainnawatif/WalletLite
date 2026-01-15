# Firebase Setup Guide for WalletLite

## Step 1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a new project"
3. Enter project name: `WalletLite`
4. Click "Create project"
5. Wait for initialization to complete

## Step 2: Enable Firestore Database
1. In Firebase Console, go to **Build** → **Firestore Database**
2. Click **Create Database**
3. Select your location (e.g., us-central1)
4. Choose **Start in test mode** (for development)
5. Click **Create**

## Step 3: Get Your Firebase Credentials

### For Android:
1. In Firebase Console, click the gear icon (⚙️) → **Project Settings**
2. Go to **Your apps** section
3. Click on your Android app (or add one if needed)
4. Download `google-services.json`
5. Copy it to: `android/app/google-services.json`
6. Credentials are automatically applied

### For iOS:
1. Click on your iOS app in Project Settings
2. Download `GoogleService-Info.plist`
3. Open iOS project in Xcode: `ios/Runner.xcworkspace`
4. Drag and drop the plist file into Xcode (check "Copy items if needed")
5. Credentials are automatically applied

### For Web/Other Platforms:
1. In Firebase Console → Project Settings
2. Look for the web app configuration (shows as `<script>` tag)
3. Copy these values:
   - `apiKey`
   - `projectId`
   - `messagingSenderId`
   - `appId`
4. Update `lib/firebase_options.dart` with these values

## Step 4: Update Firebase Options
Edit `lib/firebase_options.dart` and replace the placeholder values with your actual Firebase credentials:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ACTUAL_API_KEY',
  appId: '1:YOUR_PROJECT_NUMBER:android:YOUR_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'walletlite-xxxxx', // Your actual project ID
  databaseURL: 'https://walletlite-xxxxx.firebaseio.com',
  storageBucket: 'walletlite-xxxxx.appspot.com',
);
```

## Step 5: Update Firestore Security Rules
1. In Firebase Console → **Firestore Database** → **Rules** tab
2. Replace the default rules with:

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow all authenticated users to read and write
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
    
    // For development (test mode), allow everyone
    // match /{document=**} {
    //   allow read, write: if true;
    // }
  }
}
```

3. Click **Publish**

## Step 6: Run the App
```bash
flutter pub get
flutter run
```

## How It Works

### Automatic Collection Creation
When you click the **Add Category** button, the app automatically:
1. Creates a `categories` collection (if it doesn't exist)
2. Adds a new document with the category name
3. Firestore auto-creates subcollections when you add expenses

### Data Structure in Firestore:
```
categories/
├── categoryId1/
│   ├── name: "Food"
│   └── expenses/
│       ├── expenseId1/
│       │   ├── title: "Lunch"
│       │   ├── amount: 25.50
│       │   └── date: "2024-01-13T10:30:00Z"
│       └── expenseId2/...
└── categoryId2/...
```

## UI Buttons & Their Functions

### Category Page
- **FAB (+ button)**: Opens dialog to add new category → Saves to Firestore
- **Delete Icon**: Deletes category and all its expenses from Firestore
- **Category Tile**: Navigate to category detail page

### Category Detail Page
- **FAB (Add Expense)**: Navigate to add expense page → Saves to Firestore
- **Delete Icon**: Delete individual expense from Firestore

### Add Expense Page
- **Save Button**: Creates expense and returns to category detail page → Auto-saves to Firestore

## Troubleshooting

### Collections not appearing in Firestore Console?
1. Check that you're logged in with the correct Firebase account
2. Make sure the app is connected to the right Firebase project
3. Check Firestore permissions/rules (should allow read/write)
4. Look at Android Studio logcat for errors

### Data not saving?
1. Check `adb logcat` in Android Studio
2. Verify Firestore rules allow write operations
3. Ensure Firebase initialization is working (check main.dart)
4. Check that `firebase_options.dart` has correct credentials

### Permissions Denied Error?
Update Firestore rules in Firebase Console:
```firestore
match /{document=**} {
  allow read, write: if true;  // Development only!
}
```

## Security Note
⚠️ The above rule allows everyone to read/write. For production:
- Implement proper authentication (Firebase Auth)
- Use user-specific security rules
- Store data under user IDs

```firestore
match /users/{userId}/{document=**} {
  allow read, write: if request.auth.uid == userId;
}
```

---

**All buttons now automatically save data to Firebase!** 🎉
When you run the app and click add buttons, collections are created automatically.
