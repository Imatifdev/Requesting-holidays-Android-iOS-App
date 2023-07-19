// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ForgotPasswordScreen extends StatefulWidget {
//   @override
//   _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _otpController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//   bool _isOTPSent = false;
//   bool _isOTPSuccessful = false;

//   Future<void> _sendOTP() async {
//     final url = 'https://jporter.ezeelogix.com/public/api/forgot-password';

//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         'Accept': 'application/json',
//       },
//       body: {
//         'email': _emailController.text,
//         'user_type': '1',
//       },
//     );

//     if (response.statusCode == 200) {
//       setState(() {
//         _isOTPSent = true;
//       });
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Error'),
//           content: Text('Failed to send OTP. Please try again.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   Future<void> _verifyOTP() async {
//     final url = 'https://jporter.ezeelogix.com/public/api/reset-password';

//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         'Accept': 'application/json',
//       },
//       body: {
//         'otp': _otpController.text,
//         'password': _passwordController.text,
//         'user_type': '1',
//       },
//     );

//     if (response.statusCode == 200) {
//       // Password reset successful
//       setState(() {
//         _isOTPSuccessful = true;
//       });
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Error'),
//           content: Text('Failed to reset password. Please try again.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

// ignore_for_file: prefer_const_constructors

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Forgot Password'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//               ),
//             ),
//             SizedBox(height: 16.0),
//             if (!_isOTPSent)
//               ElevatedButton(
//                 onPressed: _sendOTP,
//                 child: Text('Send OTP'),
//               ),
//             if (_isOTPSent)
//               Column(
//                 children: [
//                   TextField(
//                     controller: _otpController,
//                     decoration: InputDecoration(
//                       labelText: 'OTP',
//                     ),
//                   ),
//                   SizedBox(height: 16.0),
//                   TextField(
//                     controller: _passwordController,
//                     decoration: InputDecoration(
//                       labelText: 'New Password',
//                     ),
//                     obscureText: true,
//                   ),
//                   SizedBox(height: 16.0),
//                   ElevatedButton(
//                     onPressed: _verifyOTP,
//                     child: Text('Reset Password'),
//                   ),
//                 ],
//               ),
//             if (_isOTPSuccessful)
//               Text(
//                 'Password reset successful!',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16.0,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:holidays/screens/companyauth/companyLogin.dart';
import 'package:holidays/screens/empauth/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../widget/constants.dart';

class EmpForgotPasswordScreen extends StatefulWidget {
  final String email;

  const EmpForgotPasswordScreen({super.key, required this.email});
  @override
  _EmpForgotPasswordScreenState createState() =>
      _EmpForgotPasswordScreenState();
}

class _EmpForgotPasswordScreenState extends State<EmpForgotPasswordScreen> {
  TextEditingController _otpController = TextEditingController();
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
        'user_type': '2',
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
        'otp': _otpController.text,
        'password': _passwordController.text,
        'user_type': '2',
      },
    );

    if (response.statusCode == 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (ctx) => EmpLoginPage()));
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: red,
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16.0),
            if (!_isOTPSent)
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: red),
                  onPressed: _sendOTP,
                  child: Text('Send OTP'),
                ),
              ),
            if (_isOTPSent)
              Column(
                children: [
                  TextField(
                    controller: _otpController,
                    decoration: InputDecoration(
                      labelText: 'Enter your OTP',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Set New Password',
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: red),
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
