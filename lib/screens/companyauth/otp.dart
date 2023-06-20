import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OTPVerificationPage extends StatefulWidget {
  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String _otpStatus = '';

  Future<void> sendOTP() async {
    final String email = _emailController.text;
    final String apiUrl = 'http://jporter.ezeelogix.com/public/api/send-otp';

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      body: {'email': email, 'user_type': '1'},
    );

    if (response.statusCode == 200) {
      // OTP sent successfully
      setState(() {
        _otpStatus = 'OTP sent successfully. Please check your email.';
      });
    } else {
      // Failed to send OTP
      setState(() {
        _otpStatus = 'Failed to send OTP. Please try again...';
      });
    }
  }

  Future<void> verifyOTP() async {
    final String otp = _otpController.text;
    final String apiUrl = 'http://jporter.ezeelogix.com/public/api/verify-otp';

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      body: {'otp': otp, 'user_type': '1'},
    );

    if (response.statusCode == 200) {
      // OTP verification successful
      setState(() {
        _otpStatus = 'OTP verification successful!';
      });
      // Proceed with password reset or other actions
    } else {
      // OTP verification failed
      setState(() {
        _otpStatus = 'OTP verification failed. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Enter Email',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: sendOTP,
              child: Text('Send OTP'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: 'Enter OTP',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: verifyOTP,
              child: Text('Verify OTP'),
            ),
            SizedBox(height: 16.0),
            Text(
              _otpStatus,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
