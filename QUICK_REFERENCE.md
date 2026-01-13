# ⚡ Firebase Setup - Quick Reference Card

**Print this and keep by your desk!**

---

## 🎯 Your Mission (Total Time: 15 minutes)

- [ ] Get Firebase credentials (5 min)
- [ ] Update `firebase_options.dart` (3 min)
- [ ] Set Firestore rules (2 min)
- [ ] Test connection (1 min)
- [ ] Add sample data (1 min)
- [ ] Verify in Firebase (3 min)

---

## 📍 Go Here

**Firebase Console:** https://console.firebase.google.com

**Project Settings:** Click ⚙️ in top-left corner

**Your Apps Section:** Scroll down to "Your apps"

**Firestore Rules:** Cloud Firestore → Rules tab (top)

---

## 📋 Copy These 6 Values

```
From Firebase Console → Project Settings → Web App:

API Key:              ___________________________
App ID:               ___________________________
Project ID:           ___________________________
Messaging Sender ID:  ___________________________
Auth Domain:          ___________________________
Storage Bucket:       ___________________________
```

---

## ✏️ Update This File

**File:** `walletlite/lib/firebase_options.dart`

**Find these lines (around line 20):**

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR_WEB_API_KEY',           ← REPLACE WITH API Key
  appId: 'YOUR_APP_ID',                 ← REPLACE WITH App ID
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID', ← REPLACE
  projectId: 'YOUR_PROJECT_ID',         ← REPLACE WITH Project ID
  authDomain: 'YOUR_PROJECT_ID.firebaseapp.com', ← REPLACE
  databaseURL: 'https://YOUR_PROJECT_ID.firebaseio.com', ← REPLACE
  storageBucket: 'YOUR_PROJECT_ID.appspot.com',  ← REPLACE
);
```

**Do the same for:**
- `static const FirebaseOptions android = ...`
- `static const FirebaseOptions ios = ...`

**Then save** (Ctrl+S)

---

## 📜 Copy-Paste This Rule

**Go to:** Firebase Console → Cloud Firestore → Rules tab

**Delete everything, paste this:**

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

**Click:** Publish

**Wait:** 10-30 seconds

---

## ▶️ Run & Test

```bash
flutter run
```

**Once app opens:**
1. Go to **Categories** (folder icon)
2. Tap **☁️** (cloud button, top right)
3. See **"✓ Connection successful!"** → GOOD ✅

---

## ✅ Final Verification

**In app:**
- [ ] Tap + to add category "Food"
- [ ] Tap Add
- [ ] See success message

**In Firebase Console:**
- [ ] Go to Cloud Firestore
- [ ] Go to Collections
- [ ] You should see:
  ```
  collections/
  └── categories/
      └── (auto-id)
          └── name: "Food"
  ```
- [ ] ✅ If you see it → DONE!

---

## 🆘 Quick Troubleshooting

| Error | Fix |
|-------|-----|
| ✗ Connection failed | Credentials wrong or not updated |
| Permission denied | Rules not published (click Publish) |
| Data not appearing | Wait 30 seconds, refresh Firebase |
| App crashes | Run `flutter run -v` to see errors |

---

## 📊 After It Works

Your Firestore structure becomes:

```
collections/
├── categories/
│   ├── id1: {name: "Food"}
│   │   └── expenses/
│   │       ├── exp1: {amount: 50, desc: "Lunch"}
│   │       └── exp2: {amount: 25, desc: "Coffee"}
│   └── id2: {name: "Transport"}
│       └── expenses/
│           └── exp1: {amount: 100, desc: "Gas"}
```

All **automatic** - you just use the app!

---

## 🔑 Key Points

✅ **DO:**
- Replace ALL `YOUR_*` values with real credentials
- Update Android AND iOS sections too
- Click Publish on Firestore rules
- Wait 30 seconds after publishing rules
- Use `flutter run`, not `flutter run web`

❌ **DON'T:**
- Leave any `YOUR_` placeholders
- Use credentials from tutorials (use YOUR project)
- Skip updating Android/iOS sections
- Forget to click Publish on rules
- Try to manually create collections

---

## 📱 What Works After Setup

| Action | Result |
|--------|--------|
| Click + category | Saves to Firestore ✓ |
| Add expense | Saves to Firestore ✓ |
| Delete item | Removed from Firestore ✓ |
| Refresh app | Data still there ✓ |
| Second device | Sees same data ✓ |

---

## 📚 Need More Help?

- **5-min guide?** → Read: `FIREBASE_QUICK_FIX.md`
- **Step-by-step?** → Read: `SETUP_CHECKLIST.md`
- **Why no data?** → Read: `WHY_NO_DATA_IN_FIRESTORE.md`
- **Full details?** → Read: `DEBUG_FIRESTORE.md`
- **Credentials?** → Read: `CREDENTIALS_MAPPING.md`

---

## ⏱️ Timeline

- Collect credentials: 5 min
- Update file: 3 min
- Set rules: 2 min
- Test: 5 min
- **Total: 15 minutes**

**Start now!** ⚡
