// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class OTPVerificationPage extends StatefulWidget {
//   @override
//   _OTPVerificationPageState createState() => _OTPVerificationPageState();
// }

// class _OTPVerificationPageState extends State<OTPVerificationPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _otpController = TextEditingController();
//   String _otpStatus = '';

//   Future<void> sendOTP() async {
//     final String email = _emailController.text;
//     final String apiUrl = 'http://jporter.ezeelogix.com/public/api/send-otp';

//     final http.Response response = await http.post(
//       Uri.parse(apiUrl),
//       body: {'email': email, 'user_type': '1'},
//     );

//     if (response.statusCode == 200) {
//       // OTP sent successfully
//       setState(() {
//         _otpStatus = 'OTP sent successfully. Please check your email.';
//       });
//     } else {
//       // Failed to send OTP
//       setState(() {
//         _otpStatus = 'Failed to send OTP. Please try again...';
//       });
//     }
//   }

//   Future<void> verifyOTP() async {
//     final String otp = _otpController.text;
//     final String apiUrl = 'http://jporter.ezeelogix.com/public/api/verify-otp';

//     final http.Response response = await http.post(
//       Uri.parse(apiUrl),
//       body: {'otp': otp, 'user_type': '1'},
//     );

//     if (response.statusCode == 200) {
//       // OTP verification successful
//       setState(() {
//         _otpStatus = 'OTP verification successful!';
//       });
//       // Proceed with password reset or other actions
//     } else {
//       // OTP verification failed
//       setState(() {
//         _otpStatus = 'OTP verification failed. Please try again.';
//       });
//     }
//   }

// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('OTP Versification'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(
//                 labelText: 'Enter Email',
//               ),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: sendOTP,
//               child: Text('Send OTP'),
//             ),
//             SizedBox(height: 16.0),
//             TextField(
//               controller: _otpController,
//               decoration: InputDecoration(
//                 labelText: 'Enter OTP',
//               ),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: verifyOTP,
//               child: Text('Verify OTP'),
//             ),
//             SizedBox(height: 16.0),
//             Text(
//               _otpStatus,
//               style: TextStyle(
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holidays/screens/companyauth/companyLogin.dart';
import 'package:holidays/screens/companyauth/setpass.dart';
import 'package:holidays/screens/empauth/login.dart';
import 'package:holidays/screens/empauth/profile.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import '../../widget/constants.dart';
import 'compforgotpass.dart';

final String baseUrl = 'https://jporter.ezeelogix.com/public/api';
final String resendOtpEndpoint = '/resend-otp';
final String verifyOtpEndpoint = '/verify-otp';

class CompanyOtpScreen extends StatefulWidget {
  final String email;

  const CompanyOtpScreen({super.key, required this.email});
  @override
  _CompanyOtpScreenState createState() => _CompanyOtpScreenState();
}

class _CompanyOtpScreenState extends State<CompanyOtpScreen> {
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
            context, MaterialPageRoute(builder: (ctx) => CompanyLoginPage()));
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: red),
        backgroundColor: backgroundColor,
        title: Text(
          'OTP',
          style: TextStyle(fontSize: 20, color: red),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: otpController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                filled: true,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                fillColor: Colors.grey.shade300,
                hintText: 'Enter OTP',
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: red,
                  ),
                  onPressed: () {
                    resendOtp('1', widget.email);
                  },
                  child: Text('Resend OTP'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: red,
                  ),
                  onPressed: () {
                    verifyOtp('1', otpController.text);
                  },
                  child: Text('Verify OTP'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
