# Firestore Connection & Debugging Guide

## Problem: Data Not Appearing in Firestore

If your app is running but **data is NOT appearing in Firebase Firestore Console**, follow these steps:

---

## 🔍 Step 1: Test Firebase Connection

1. **Open the app** on your device or emulator
2. **Go to Categories page** (tap the folder icon)
3. **Tap the cloud upload button** (☁️ icon) in the top right
4. **Check the result:**
   - ✓ Connection Successful → Proceed to Step 2
   - ✗ Connection Failed → Proceed to Step 3

---

## ✓ Connection Successful - Check Firestore Rules

If the connection test passed but data still isn't saving:

### Issue: Firestore Rules Blocking Writes

1. **Go to Firebase Console:**
   - Open [https://firebase.google.com](https://firebase.google.com)
   - Select your project
   - Go to **Firestore Database**

2. **Check the "Rules" tab at the top**

3. **Current rule (likely):**
   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /{document=**} {
         allow read, write: if false;
       }
     }
   }
   ```

4. **Change to (for testing):**
   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /{document=**} {
         allow read, write: if true;
       }
     }
   }
   ```

5. **Click "Publish"**

6. **Wait 5-10 seconds** for rules to deploy

7. **Try adding a category in the app again**

---

## ✗ Connection Failed - Fix Firebase Options

If the connection test FAILED, your firebase credentials are missing or incorrect:

### Step 1: Get Your Firebase Credentials

1. Go to [Firebase Console](https://firebase.google.com)
2. Create a new project or select existing one
3. Go to **Project Settings** (click gear icon ⚙️)
4. Copy these values:
   - **Project ID**
   - **API Key** (under "Web API Key")
   - **Messaging Sender ID**
   - **App ID** (your web app ID)
   - **Database URL** (optional, for Realtime Database)
   - **Storage Bucket** (optional)

### Step 2: Update firebase_options.dart

**File:** `walletlite/lib/firebase_options.dart`

Find this section (around line 20-50):

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR_WEB_API_KEY', ← CHANGE THIS
  appId: 'YOUR_APP_ID', ← CHANGE THIS
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID', ← CHANGE THIS
  projectId: 'YOUR_PROJECT_ID', ← CHANGE THIS
  authDomain: 'YOUR_PROJECT_ID.firebaseapp.com', ← CHANGE THIS
  databaseURL: 'https://YOUR_PROJECT_ID.firebaseio.com', ← OPTIONAL
  storageBucket: 'YOUR_PROJECT_ID.appspot.com', ← OPTIONAL
);
```

**Replace all `YOUR_*` values with your actual Firebase credentials**

Example:
```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'AIzaSyD1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p',
  appId: '1:123456789012:web:abcdef1234567890abcd',
  messagingSenderId: '123456789012',
  projectId: 'my-wallet-app',
  authDomain: 'my-wallet-app.firebaseapp.com',
  databaseURL: 'https://my-wallet-app.firebaseio.com',
  storageBucket: 'my-wallet-app.appspot.com',
);
```

### Step 3: Do the Same for Android, iOS, etc.

Find sections for:
- `FirebaseOptions android` (around line 75)
- `FirebaseOptions ios` (around line 115)

Update their values too!

---

## 📱 Step 4: Run App with Verbose Logging

1. **Stop the app** if it's running (Ctrl+C in terminal)

2. **Run with verbose logging:**
   ```bash
   flutter run -v
   ```

3. **Watch the console output for:**
   - `✓ Firebase initialized successfully!` → Good sign
   - `📝 Adding category to Firestore...` → Category being added
   - `✓ Category added` → Success!
   - `✗ Failed to add category` → Check Firestore rules
   - `Check Firestore rules allow WRITE access!` → Rules are blocking writes

---

## 🛠️ Troubleshooting Checklist

- [ ] firebase_options.dart has REAL credential values (not `YOUR_*` placeholders)
- [ ] Firestore rules are set to `allow read, write: if true;` (for testing)
- [ ] App shows "✓ Firebase initialized successfully!" in console
- [ ] Test Connection button shows "✓ Connection Successful"
- [ ] Category can be added and appears in Firestore Console
- [ ] Internet connection is working

---

## 📊 Checking Firestore Console

1. Go to [Firebase Console](https://firebase.google.com)
2. Select your project
3. Click **Firestore Database** in left menu
4. You should see:
   ```
   collections
   └── categories
       └── [category-id]
           └── expenses (subcollection)
   ```

5. Click on a category to see its data

---

## 🐛 Debug Output Locations

**Console logs appear in three places:**

1. **VSCode Terminal** - If running `flutter run -v`
2. **Android Studio Logcat** - If using Android Studio emulator
3. **Xcode Console** - If using iOS simulator

Look for messages like:
- `📝 Adding category to Firestore...`
- `✓ Category added successfully!`
- `✗ Failed to add category`

---

## ❓ Still Not Working?

Try these fixes in order:

### 1. Clear App Cache
```bash
flutter clean
flutter pub get
```

### 2. Restart Firestore Emulator (if using emulator)
```bash
firebase emulators:start
```

### 3. Check Firestore is Enabled
- Firebase Console → Firestore Database → Create Database (if not exists)
- Select **Test Mode** or **Production Mode**
- Choose location (e.g., us-central1)

### 4. Verify API Keys
- Firebase Console → Project Settings → Service Accounts
- Make sure Web SDK is configured
- Copy exact credentials again

### 5. Check Network
- Ensure device/emulator has internet
- Check if Firebase CDN is accessible

---

## 💡 Tips

- **Local Emulator:** Use Firebase emulator for local testing (no credentials needed)
- **Production:** Update Firestore rules to proper security rules before deploying
- **Debugging:** Keep `flutter run -v` open in one terminal while testing
- **Logs:** Save console output for troubleshooting

---

## 📚 Resources

- [Firebase Documentation](https://firebase.flutter.dev/)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Flutter Firebase Integration](https://firebase.flutter.dev/docs/overview)
