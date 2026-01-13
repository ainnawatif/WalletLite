# Firebase Credentials - Example Format

This file shows you **EXACTLY** what your real credentials should look like.

---

## What You Get from Firebase Console

When you go to Firebase Console → Project Settings → Web App, you'll see:

```json
{
  "apiKey": "AIzaSyDxxxxxxxxxxxxxxxxxxxxxxxxxx",
  "authDomain": "myproject-12345.firebaseapp.com",
  "databaseURL": "https://myproject-12345.firebaseio.com",
  "projectId": "myproject-12345",
  "storageBucket": "myproject-12345.appspot.com",
  "messagingSenderId": "1234567890",
  "appId": "1:1234567890:web:abcdef1234567890"
}
```

---

## Map to firebase_options.dart

**From the JSON above, put values like this:**

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'AIzaSyDxxxxxxxxxxxxxxxxxxxxxxxxxx',           // ← from apiKey
  appId: '1:1234567890:web:abcdef1234567890',           // ← from appId
  messagingSenderId: '1234567890',                       // ← from messagingSenderId
  projectId: 'myproject-12345',                          // ← from projectId
  authDomain: 'myproject-12345.firebaseapp.com',         // ← from authDomain
  databaseURL: 'https://myproject-12345.firebaseio.com', // ← from databaseURL
  storageBucket: 'myproject-12345.appspot.com',          // ← from storageBucket
);
```

---

## Real Example

**If your Firebase Console shows:**
```json
{
  "apiKey": "AIzaSyDe1a2b3c4d5e6f7g8h9i0j1k2l3m4n",
  "authDomain": "wallet-lite-app.firebaseapp.com",
  "databaseURL": "https://wallet-lite-app.firebaseio.com",
  "projectId": "wallet-lite-app",
  "storageBucket": "wallet-lite-app.appspot.com",
  "messagingSenderId": "987654321",
  "appId": "1:987654321:web:xyz123abc456def789"
}
```

**Then in firebase_options.dart, use:**

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'AIzaSyDe1a2b3c4d5e6f7g8h9i0j1k2l3m4n',
  appId: '1:987654321:web:xyz123abc456def789',
  messagingSenderId: '987654321',
  projectId: 'wallet-lite-app',
  authDomain: 'wallet-lite-app.firebaseapp.com',
  databaseURL: 'https://wallet-lite-app.firebaseio.com',
  storageBucket: 'wallet-lite-app.appspot.com',
);
```

---

## Key Points

1. **apiKey** - Starts with `AIzaSy...` (always)
2. **projectId** - Usually in format `name-12345` (no spaces, lowercase)
3. **appId** - Looks like `1:123456:web:abc123`
4. **messagingSenderId** - Just a number like `123456789`
5. **Don't use quotes** unless the value contains special characters
6. **Do NOT commit** real credentials to GitHub! (Add to .gitignore)

---

## Where to Find Each Value

| Field | Location in Firebase Console |
|-------|------------------------------|
| apiKey | Project Settings → Web App config → apiKey |
| projectId | Project Settings → General tab → Project ID |
| appId | Project Settings → Web App config → App ID |
| messagingSenderId | Project Settings → Web App config → messagingSenderId |
| authDomain | Project ID + `.firebaseapp.com` |
| databaseURL | `https://` + Project ID + `.firebaseio.com` |
| storageBucket | Project ID + `.appspot.com` |

---

## Android Credentials

For Android, go to **Project Settings → Android app** and copy:
- Similar structure to web app
- Also includes package name and SHA certificate fingerprints

---

## iOS Credentials

For iOS, go to **Project Settings → iOS app** and download:
- `GoogleService-Info.plist` file
- But you'll also need the same Firebase options values

---

## ⚠️ Security Warning

**NEVER share these credentials publicly!**

- Don't commit to GitHub public repo
- Don't share in Discord/Slack
- Don't paste in bug reports

**Why?** Someone could:
- Access your Firestore database
- Add/modify/delete your data
- Incur charges

**Protection:**
1. Add `lib/firebase_options.dart` to `.gitignore`
2. Use environment variables for sensitive values (advanced)
3. Use Firestore rules to restrict access (most important!)

---

## Questions?

See [FIREBASE_QUICK_FIX.md](FIREBASE_QUICK_FIX.md) for step-by-step setup.
