import 'package:beta_pm/controllers/login_controller.dart';
import 'package:beta_pm/models/login_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final LoginController _controller = LoginController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _login() async {
    setState(() => _isLoading = true);

    final request = LoginRequest(
      email: _emailController.text,
      password: _passwordController.text,
    );

    try {
      final response = await _controller.login(request);
      // Store the response in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', response.token);

      // Navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ParticipantLoanApp()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900, // Lead color
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 50),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                SizedBox(height: 40),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Enter your email',
                  icon: Icons.email_outlined,
                ),
                SizedBox(height: 15),
                _buildPasswordField(),
                SizedBox(height: 30),
                _buildLoginButton(),
                _buildForgotPassword(),
                SizedBox(height: 50),
                _buildCopyrightText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Header section with title and description
  Widget _buildHeader() {
    return Column(
      children: [
        Icon(Icons.lock_outline, size: 100, color: Colors.white),
        SizedBox(height: 10),
        Text(
          'Welcome Back!',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Login to continue your journey',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white70,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  // Custom Password Field with obscure password functionality
  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: 'Enter your password',
        hintStyle: TextStyle(color: Colors.black45),
        prefixIcon: Icon(Icons.lock_outline, color: Colors.black45),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.black45,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      ),
    );
  }

  // Login Button with loading indicator
  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _login,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 130),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.blue.shade700, // Darker shade of blue
      ),
      child:
          _isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text(
                'LOGIN',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
    );
  }

  // Forgot Password link
  Widget _buildForgotPassword() {
    return GestureDetector(
      onTap: () {
        // Navigate to Forgot Password page or show dialog
        // Add your action here for forgot password
        print('Forgot Password clicked');
      },
      child: Text(
        'Forgot Password?',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white70,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  // Copyright Text
  Widget _buildCopyrightText() {
    return Text(
      '© 2024 Beta PLC. All Rights Reserved.',
      style: TextStyle(
        fontSize: 14,
        color: Colors.white60,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}

Widget _buildTextField({
  required TextEditingController controller,
  required String hintText,
  required IconData icon,
  bool isPassword = false,
}) {
  return TextField(
    controller: controller,
    obscureText: isPassword,
    style: TextStyle(color: Colors.black),
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.black45),
      prefixIcon: Icon(icon, color: Colors.black45),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
    ),
  );
}
