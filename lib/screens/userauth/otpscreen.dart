import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holidays/screens/userauth/login.dart';
import 'package:holidays/screens/userauth/profile.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

final String baseUrl = 'https://jporter.ezeelogix.com/public/api';
final String resendOtpEndpoint = '/resend-otp';
final String verifyOtpEndpoint = '/verify-otp';

class EmpOtpScreen extends StatefulWidget {
  final String email;

  const EmpOtpScreen({super.key, required this.email});
  @override
  _EmpOtpScreenState createState() => _EmpOtpScreenState();
}

class _EmpOtpScreenState extends State<EmpOtpScreen> {
  TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  Future<void> resendOtp(String userType, String email) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + resendOtpEndpoint),
        headers: {'Accept': 'application/json'},
        body: {'user_type': userType, 'email': widget.email},
      );

      if (response.statusCode == 200) {
        // Success
        Fluttertoast.showToast(msg: 'OTP resend successful');
      } else {
        // Error
        Fluttertoast.showToast(msg: 'Failed to resend OTP');
      }
    } catch (e) {
      // Exception
      Fluttertoast.showToast(msg: 'Exception: $e');
    }
  }

  Future<void> verifyOtp(String userType, String otp) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + verifyOtpEndpoint),
        headers: {'Accept': 'application/json'},
        body: {'user_type': userType, 'otp': otp},
      );

      if (response.statusCode == 200) {
        // Success
        Fluttertoast.showToast(
            msg: 'OTP verification successful, You can login now');
        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => EmpLoginPage()));
      } else {
        // Error
        Fluttertoast.showToast(msg: 'OTP verification failed');
      }
    } catch (e) {
      // Exception
      Fluttertoast.showToast(msg: 'Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Example'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: otpController,
              decoration: InputDecoration(
                labelText: 'OTP',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                resendOtp('2', widget.email);
              },
              child: Text('Resend OTP'),
            ),
            ElevatedButton(
              onPressed: () {
                verifyOtp('2', otpController.text);
              },
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
