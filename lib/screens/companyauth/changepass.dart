import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String baseUrl = 'https://jporter.ezeelogix.com/public/api';
  String verifyOtpUrl = '/verify-otp';
  String resetPasswordUrl = '/reset-password';

  Future<void> sendOTP() async {
    String apiUrl = baseUrl +
        '/resend-otp'; // Replace with your actual API endpoint for sending OTP
    Map<String, String> headers = {'Accept': 'application/json'};
    Map<String, dynamic> body = {
      'email': emailController.text,
      'user_type': '1'
    };

    try {
      var response =
          await http.post(Uri.parse(apiUrl), headers: headers, body: body);
      var jsonResponse = jsonDecode(response.body);

      // Check if OTP sending was successful
      if (jsonResponse != null &&
          jsonResponse['success'] != null &&
          jsonResponse['success']) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('OTP Sent'),
              content: Text('An OTP has been sent to your email address.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        // OTP sending failed, show error message or handle accordingly
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('OTP Sending Failed'),
              content: Text('Failed to send OTP. Please try again.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      // Handle API call error
      print('Error occurred: $error');
    }
  }

  Future<void> verifyOtp() async {
    // Remaining code remains the same as before
  }

  Future<void> resetPassword() async {
    // Remaining code remains the same as before
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            ElevatedButton(
              child: Text('Email OTP'),
              onPressed: () {
                sendOTP();
              },
            ),
            TextFormField(
              controller: otpController,
              decoration: InputDecoration(
                labelText: 'OTP',
              ),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'New Password',
              ),
              obscureText: true,
            ),
            ElevatedButton(
              child: Text('Verify OTP'),
              onPressed: () {
                verifyOtp();
              },
            ),
          ],
        ),
      ),
    );
  }
}
