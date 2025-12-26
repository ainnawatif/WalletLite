# 💳 WalletLite
Simple Budget &amp; Expenses Tracker

## 👥 Group Members
| Name | Matric Number |
|------|---------------|
| Nurain Awatif Binti Ismail | 2214552 |
| Nurul Adlina Binti Roslan | 2219814 |
| Nana Aichata Mbourou Camara   |   2125102 |

---

## 📌 Project Title
**WalletLite**

---

## 📖 Introduction
Managing daily expenses is a challenge for many individuals, especially students and young adults who often struggle to track spending and control their finances. Most existing finance applications are either too complex or require paid subscriptions for basic features.

**WalletLite** is proposed as a simple, lightweight, and user-friendly mobile application that helps users track their income and expenses efficiently. The application focuses on clarity, minimal design, and essential features to encourage better financial awareness and spending habits.

---

## 🎯 Objectives
The objectives of WalletLite are:
- To allow users to record, view, and categorize daily expenses in real time
- To provide a clear overview of spending patterns
- To encourage better financial planning and budgeting


---

## 👤 Target Users
The target users of WalletLite include:
- University students
- Young working adults
- Individuals seeking simple personal finance management
- Users who prefer minimal and easy-to-use finance apps

---

## ⚙️ Features and Functionalities

### Core Modules
- **User Authentication**
  - Login and registration using Firebase Authentication
  - Secure logout functionality

- **Expense & Income Management**
  - Add, edit, and delete expenses
  - Record income transactions
  - Assign categories to transactions

- **Dashboard**
  - Display total balance, income, and expenses
  - Daily, weekly, monthly, and yearly filters
  - Expense summary visualization using charts

- **Expense Visualization**
  - Bar charts for expense trends
  - Category-based spending breakdown
 
- **Categories Management**
  - Predefined categories (Food, Transport, Groceries, Rent, etc.)
  - Add new custom categories

- **User Profile**
  - View user details
  - Secure logout

## 🎨 Proposed UI Mock-up

The UI of WalletLite is designed using **Figma**: 
<img width="1000" height="707" alt="Screenshot (812)" src="https://github.com/user-attachments/assets/8cea3a80-e8d7-4ba2-a6eb-a27fe8f8994d" />
<img width="672" height="700" alt="Screenshot (813)" src="https://github.com/user-attachments/assets/c5f5ace5-2163-4505-984b-6edf14858e9a" />
<img width="1029" height="724" alt="Screenshot (814)" src="https://github.com/user-attachments/assets/4f550c39-4222-4ca8-8c38-9217ec1a813f" />
<img width="1123" height="606" alt="Screenshot (815)" src="https://github.com/user-attachments/assets/6c9ce189-cfbb-4297-b0d6-2520478a5675" />
<img width="531" height="562" alt="Screenshot (816)" src="https://github.com/user-attachments/assets/899a6a3f-3e06-4103-9223-7b7c0887c561" />
<img width="1058" height="566" alt="Screenshot (817)" src="https://github.com/user-attachments/assets/012c99a9-b245-4989-a213-500aca5e9b08" />


## 🏗 Architecture / Technical Design
The application follows a modular widget-based architecture usibg flutter. the user interface is divided into multiple screens such as login, dashboard, transaction management, category management and user profile. Each scree is composed of smaller reusable widgets, including transaction cards category tiles, and summary components to promote code rusability and maintainability.

**1. Package & Plugins (FlutterFire)**
To implementt backend functionality, we will be using FlutterFire, a set of plugins that connect the Flutter application to Firebase services. The specific plugins integrated into WalletLite are:

- **Authenticatication (Firebase_auth):** We use this plugin to handle user identity. It enablles secure authentication mechanisms, allowing users to sign in via emails and password or identity providers like Google.

- **Database (cloud_firestore):** All transaction records and category data are store using Cloud Firestore. This is a cloud-hosted, NoSQL database that supports live synchronization, ensuring data remains updated across devices.

- **Storage (firebase_storage):** We utilize this plugin to store and retrieve user-generated content, such as profile pictures, in a secure and cost-effective object storegae service.

**2. Widget Composition & UI Layout**
The user interface is built using Composition over Inheritance, combining simple widgets to create complex layout

- **Structural Layouts:** Each main screen (e.g., Dashboard, Profile) is built upon a Scaffold widget. This provides the standard Material Design structure, including the AppBar for titles and the BottomNavigationBar for navigating between the Home, Analysis, and Profile sections.

- **Content Arrangement:**

  - **Column & Row:** These are extensively used to align elements. For example, the Transaction History uses a Column to list expenses vertically, while the Dashboard uses a Row to display "Income" and "Expense" cards side-by-side.

  - **Container:** This widget is used to style UI blocks, such as the total balance card, by applying padding, margins, and background decoration.

  - **ListView:** Used in the Transaction screen to render scrollable lists of expense items, allowing the app to handle dynamic numbers of entries efficiently.

**3. State Management & Interactivity**
To handle dynamic data and user input, the application distinguishes between two widget types:

- **Stateless Widgets:** Used for static screens where the interface does not change after being built, such as the Onboarding Screen.

- **Stateful Widgets:** Used for interactive screens like Add Expense and Login. These widgets maintain a mutable State object that tracks changes (e.g., user input or a new transaction) and calls _setState()_ to rebuild the UI and reflect the updates immediately.

- **Form Handling:** The Login and Sign Up screens utilize the Form widget combined with _TextFormField_. This allows us to manage form state and implement _validator_ logic to ensure inputs (like email format) are correct before processing


## 🗄 Data Model
The Entity Relationship Diagram (ERD) represents the database structure of the personal finance management system. The data model consists of three main entities: User, Transaction, and Category.

<img width="686" height="546" alt="ERD" src="https://github.com/user-attachments/assets/37c17fa9-d926-4782-9af4-039862634bb4" />


## 🔄 Flowchart
The sequence diagram illustrates how users interact with the personal finance management system. Users begin by logging in or registering using Firebase Authentication. Once authenticated, the system retrieves and stores user data, transactions, and categories using the Firebase database, and displays the dashboard for navigation. The diagram shows the sequence of actions for managing transactions, categories, viewing expense visualizations, and securely logging out.

<p align="center">
  <img width="510" height="851" alt="Sequence diagram"
       src="https://github.com/user-attachments/assets/e8ef3cdc-2252-4f10-8df7-17649bb2a635" />
</p>


## 📚 References
Figma Documentation: https://www.figma.com/design/grNokvbjeAjLV23XVOZXmG/WalletLite?node-id=0-1&p=f&t=LQxRLD19ImeQI6LO-0
Firebase Documentation: https://console.firebase.google.com/u/0/project/walletlite-c22d7/overview

