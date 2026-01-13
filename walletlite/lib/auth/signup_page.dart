import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F4D6B),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inventory_2, color: Colors.white, size: 60),
            const SizedBox(height: 16),

            const Text(
              "Create an account",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Please enter your details",
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 30),

            _input("Email"),
            _input("User name"),
            _input("Password", obscure: true),
            _input("Confirm Password", obscure: true),

            const SizedBox(height: 20),

            _button("Continue"),

            const SizedBox(height: 10),
            const Text("OR", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 10),

            _googleButton("Sign up with Google"),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text(
                "Already have an account? Log in",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(String hint, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _button(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black45,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () {},
      child: Text(text),
    );
  }

  Widget _googleButton(String text) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () {},
      icon: const Icon(Icons.g_mobiledata, color: Colors.red),
      label: Text(text, style: const TextStyle(color: Colors.black)),
    );
  }
}
