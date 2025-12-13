import 'dart:ui';
import 'package:anant_flutter/main.dart';
import 'package:anant_flutter/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialPasswordUpdate extends StatefulWidget {
  const InitialPasswordUpdate({Key? key}) : super(key: key);

  @override
  _InitialPasswordUpdateState createState() => _InitialPasswordUpdateState();
}

class _InitialPasswordUpdateState extends State<InitialPasswordUpdate> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _savePassword(context) async {
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    if (_formKey.currentState!.validate()) {
      // Place your save logic here.
      final result = await client.user.updateInitialPassword(userId);
      print(result);
      final updatePassword = await client.auth.updateUser(userId, newPassword: _passwordController.text);
      print(updatePassword);
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully!')),
      );
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // Custom "Good Save Button" with gradient, rounded corners, and an icon.
  Widget _buildSaveButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF42A5F5), Color(0xFF66BB6A)], // Blue to green gradient.
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _savePassword(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A light gradient background to enhance visibility of errors.
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB3E5FC), // Light blue.
              Color(0xFFC8E6C9), // Light green.
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              // Frosted glass effect using BackdropFilter.
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Update Password',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // New Password Field with an underline style.
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            labelStyle: const TextStyle(color: Colors.black87),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black87),
                            ),
                            errorStyle: const TextStyle(color: Colors.red),
                          ),
                          style: const TextStyle(color: Colors.black87),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a new password';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // Confirm Password Field with an underline style.
                        TextFormField(
                          controller: _confirmController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: const TextStyle(color: Colors.black87),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black38),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black87),
                            ),
                            errorStyle: const TextStyle(color: Colors.red),
                          ),
                          style: const TextStyle(color: Colors.black87),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        // Use the custom gradient save button.
                        _buildSaveButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
