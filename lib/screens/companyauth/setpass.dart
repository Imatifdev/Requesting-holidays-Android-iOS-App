import 'package:flutter/material.dart';
import 'package:holidays/screens/companyauth/companyLogin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../widget/constants.dart';

class SetCompPass extends StatefulWidget {
  final String email;
  final String otp;

  const SetCompPass({super.key, required this.email, required this.otp});
  @override
  _SetCompPassState createState() => _SetCompPassState();
}

class _SetCompPassState extends State<SetCompPass> {
  TextEditingController _passwordController = TextEditingController();
  bool _isOTPSent = false;
  bool _isOTPSuccessful = false;

  Future<void> _sendOTP() async {
    final url = 'https://jporter.ezeelogix.com/public/api/forgot-password';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'email': widget.email,
        'user_type': '1',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _isOTPSent = true;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to send OTP. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _verifyOTP() async {
    final url = 'https://jporter.ezeelogix.com/public/api/reset-password';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'otp': widget.otp,
        'password': _passwordController.text,
        'user_type': '1',
      },
    );

    if (response.statusCode == 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (ctx) => CompanyLoginPage()));
      // Password reset successful
      setState(() {
        _isOTPSuccessful = true;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to reset password. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: red,
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0),
            if (!_isOTPSent)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: red,
                ),
                onPressed: _sendOTP,
                child: Text('Send OTP'),
              ),
            if (_isOTPSent)
              Column(
                children: [
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: red,
                    ),
                    onPressed: _verifyOTP,
                    child: Text('Reset Password'),
                  ),
                ],
              ),
            if (_isOTPSuccessful)
              Text(
                'Password reset successful!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
