# 🚀 IMMEDIATE ACTION REQUIRED - Firebase Setup

**Your app is ready, but Firebase credentials are missing.**

---

## ⚠️ The Problem

Data is not appearing in Firestore because `firebase_options.dart` still contains placeholder values:
- `YOUR_PROJECT_ID`
- `YOUR_WEB_API_KEY`
- `YOUR_APP_ID`
- etc.

**These are NOT real credentials. Firebase won't work until you add the real ones.**

---

## ✅ The Solution (3 Steps, 5 Minutes)

### Step 1: Create/Get Firebase Project

**If you DON'T have Firebase project:**
1. Go to https://firebase.google.com
2. Click "Get started"
3. Enter project name (e.g., "WalletLite")
4. Follow the setup wizard
5. Skip analytics for now

**If you ALREADY have a project:**
- Go to https://console.firebase.google.com
- Select your project

---

### Step 2: Get Your Firebase Credentials

**In Firebase Console:**
1. Click **⚙️ Project Settings** (gear icon, top left)
2. Go to **"Your apps"** section
3. Find your **Web** app
   - If not found, click "Add app" → select Web
   - Click on it to open details
4. **Copy these 6 values:**
   - API Key
   - App ID
   - Project ID
   - Messaging Sender ID
   - Database URL (optional, you can leave as empty string)
   - Storage Bucket (optional, you can leave as empty string)

---

### Step 3: Update firebase_options.dart

**File location:** `walletlite/lib/firebase_options.dart`

**Open the file and find the `web` section (around line 20-50)**

Replace the placeholder with your real credentials:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'PASTE_YOUR_API_KEY_HERE',
  appId: 'PASTE_YOUR_APP_ID_HERE',
  messagingSenderId: 'PASTE_YOUR_MESSAGING_SENDER_ID_HERE',
  projectId: 'PASTE_YOUR_PROJECT_ID_HERE',
  authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
  databaseURL: 'https://YOUR_PROJECT_ID.firebaseio.com',
  storageBucket: 'YOUR_PROJECT_ID.appspot.com',
);
```

**For Android and iOS:**
- Find `static const FirebaseOptions android` and `static const FirebaseOptions ios`
- Update their values the same way

---

### Step 4: Set Firestore Rules (Allow Writes)

**In Firebase Console:**
1. Go to **Firestore Database**
2. Click **"Rules"** tab (top)
3. **Clear everything** and paste:

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

4. Click **"Publish"** button
5. Wait 10 seconds for rules to deploy

---

## 🧪 Test It

1. **Stop the app** (Ctrl+C)
2. **Run it again:**
   ```bash
   flutter run
   ```
3. **Go to Categories page**
4. **Tap the cloud button ☁️** (top right)
5. **You should see:**
   ```
   ✓ Firebase connection successful!
   ```

---

## 📝 Add Some Data

1. **Tap the + button** to add a category
2. **Enter a name** (e.g., "Food")
3. **Check Firebase Console:**
   - Firestore Database → Collections → categories
   - You should see your category there!

---

## 🎉 Done!

Once you see data in Firebase Console, everything is working!

**From now on:**
- ✅ Every category you add → saved to Firebase
- ✅ Every expense you add → saved to Firebase
- ✅ Real-time sync across devices
- ✅ Data persists forever

---

## 📚 Full Guide

For more detailed troubleshooting, see: [DEBUG_FIRESTORE.md](DEBUG_FIRESTORE.md)

---

## 🆘 Still Having Issues?

**Run this and send the output:**
```bash
flutter run -v
```

Watch for these messages:
- `✓ Firebase initialized successfully!` ← Good
- `📝 Adding category to Firestore...` ← Operation starting
- `✗ Failed to add category` ← Check rules or credentials
