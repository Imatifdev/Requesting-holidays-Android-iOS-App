// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:holidays/screens/companyauth/companyLogin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../widget/constants.dart';

class CompanyForgotPasswordScreen extends StatefulWidget {
  final String email;

  const CompanyForgotPasswordScreen({super.key, required this.email});
  @override
  _CompanyForgotPasswordScreenState createState() =>
      _CompanyForgotPasswordScreenState();
}

class _CompanyForgotPasswordScreenState
    extends State<CompanyForgotPasswordScreen> {
  TextEditingController _otpController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();
  bool _isOTPSent = false;
  bool _isOTPSuccessful = false;

  // Future<void> _forgotpass() async {
  //   final url = 'https://jporter.ezeelogix.com/public/api/forgot-password';

  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: {
  //       'Accept': 'application/json',
  //     },
  //     body: {
  //       'email': widget.email,
  //       'user_type': '1',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       _isOTPSent = true;
  //     });
  //   } else {
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text('Error'),
  //         content: Text('Failed to send OTP. Please try again.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: Text('OK'),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }

  // Future<void> _resetPass() async {
  //   final url = 'https://jporter.ezeelogix.com/public/api/reset-password';

  //   final response = await http.post(
  //     Uri.parse(url),
  //     headers: {
  //       'Accept': 'application/json',
  //     },
  //     body: {
  //       'otp': _otpController.text,
  //       'password': _passwordController.text,
  //       'user_type': '1',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     print(response.statusCode);
  //     print(response.body);

  //     // Navigator.push(
  //     //     context, MaterialPageRoute(builder: (ctx) => CompanyLoginPage()));
  //     // // Password reset successful
  //     // setState(() {
  //     //   _isOTPSuccessful = true;
  //     // });
  //   } else {
  //     print(response.statusCode);
  //     print(response.body);
  //   }
  // }

  final String baseUrl = 'https://jporter.ezeelogix.com/public/api';
  final String resendOtpEndpoint = '/resend-otp';
  Future<void> resendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + resendOtpEndpoint),
        headers: {'Accept': 'application/json'},
        body: {'user_type': '1', 'email': email},
      );

      if (response.statusCode == 200) {
        // Success
        Fluttertoast.showToast(msg: 'OTP resend successful');
        print(response);
        print(response.statusCode);
      } else {
        // Error
        Fluttertoast.showToast(msg: 'Failed to resend OTP');
      }
    } catch (e) {
      // Exception
      Fluttertoast.showToast(msg: 'Exception: $e');
    }
  }

  bool _isPasswordVisible = false;

  Future<void> _resetPass() async {
    final url = 'https://jporter.ezeelogix.com/public/api/reset-password';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'otp': _otpController.text,
        'password': _passwordController.text,
        'user_type': '1',
      },
    );

    if (response.statusCode == 200) {
      print(response.statusCode);
      print(response.body);
      Fluttertoast.showToast(msg: 'Password Reset Successfully');

      final responseData = jsonDecode(response.body);

      if (responseData['status'] == 'Error') {
        final errorMessage = responseData['message'];

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage != null
                ? errorMessage.toString()
                : 'OTP not found.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Password reset successful
        setState(() {
          _isOTPSuccessful = true;
        });

        // Navigate to the desired screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (ctx) => CompanyLoginPage()),
        );
      }
    } else {
      print(response.statusCode);
      print(response.body);
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
            // if (!_isOTPSent)
            //   ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: red,
            //     ),
            //     onPressed: _forgotpass,
            //     child: Text('Send OTP'),
            //   ),
            Column(
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  controller: _otpController,
                  decoration: InputDecoration(
                    labelText: 'OTP',
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                ),
                SizedBox(height: 16.0),
                TextField(
                  obscureText: !_isPasswordVisible,
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                    labelText: 'Confirm Password',
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: red,
                  ),
                  onPressed: () {
                    if (_passwordController.text ==
                        _confirmPasswordController.text) {
                      _resetPass();
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Error'),
                          content: Text('Passwords do not match.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Text('Reset Password'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        resendOtp(widget.email);
                      },
                      child: Text(
                        "resend OTP ",
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    )
                  ],
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
