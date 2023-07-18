// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:holidays/screens/companyauth/companyLogin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../widget/constants.dart';

class CompanyResetPasswordScreen extends StatefulWidget {
  final String email;

  const CompanyResetPasswordScreen({super.key, required this.email});
  @override
  _CompanyResetPasswordScreenState createState() =>
      _CompanyResetPasswordScreenState();
}

class _CompanyResetPasswordScreenState
    extends State<CompanyResetPasswordScreen> {
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    double fontSize;
    double title;
    double heading;

    // Adjust the font size based on the screen width
    if (screenWidth < 320) {
      fontSize = 13.0;
      title = 20;
      heading = 30; // Small screen (e.g., iPhone 4S)
    } else if (screenWidth < 375) {
      fontSize = 15.0;
      title = 26;

      heading = 24; // Medium screen (e.g., iPhone 6, 7, 8)
    } else if (screenWidth < 414) {
      fontSize = 17.0;
      title = 28;

      heading = 28; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else if (screenWidth < 600) {
      fontSize = 19.0;
      title = 36;

      heading = 30; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else {
      fontSize = 22.0;
      title = 40;

      heading = 30; // Extra large screen or unknown device
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: red,
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                TextFormField(
                  controller: _otpController,
                  maxLength: 4,
                  decoration: InputDecoration(
                    hintText: "OTP",
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),

                      borderRadius:
                          BorderRadius.circular(20), // Set border radius here
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),

                      borderRadius:
                          BorderRadius.circular(20), // Set border radius here
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius:
                          BorderRadius.circular(20), // Set border radius here
                    ),
                    filled: true,
                    fillColor: const Color(0xffeceff6),
                    contentPadding: const EdgeInsets.all(8),
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
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
                    hintText: "Confirm Password",
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),

                      borderRadius:
                          BorderRadius.circular(20), // Set border radius here
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),

                      borderRadius:
                          BorderRadius.circular(20), // Set border radius here
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius:
                          BorderRadius.circular(20), // Set border radius here
                    ),
                    filled: true,
                    fillColor: const Color(0xffeceff6),
                    contentPadding: const EdgeInsets.all(8),
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !_isPasswordVisible,
                ),
                SizedBox(height: 16.0),
                TextFormField(
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
                    hintText: "Confirm Password",
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),

                      borderRadius:
                          BorderRadius.circular(20), // Set border radius here
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),

                      borderRadius:
                          BorderRadius.circular(20), // Set border radius here
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius:
                          BorderRadius.circular(20), // Set border radius here
                    ),
                    filled: true,
                    fillColor: const Color(0xffeceff6),
                    contentPadding: const EdgeInsets.all(8),
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !_isPasswordVisible,
                ),
                SizedBox(height: 16.0),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: red,
                //   ),
                //   onPressed: () {
                //     if (_passwordController.text ==
                //         _confirmPasswordController.text) {
                //       _resetPass();
                //     } else {
                //       showDialog(
                //         context: context,
                //         builder: (context) => AlertDialog(
                //           title: Text('Error'),
                //           content: Text('Passwords do not match.'),
                //           actions: [
                //             TextButton(
                //               onPressed: () => Navigator.pop(context),
                //               child: Text('OK'),
                //             ),
                //           ],
                //         ),
                //       );
                //     }
                //   },
                //   child: Text('Reset Password'),
                // ),
                Center(
                    child: InkWell(
                  onTap: () {
                    if (_passwordController.text ==
                        _confirmPasswordController.text) {
                      _resetPass();
                    } else {
                      Fluttertoast.showToast(
                        msg: 'Password do not match ',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: red, borderRadius: BorderRadius.circular(10)),
                    height: screenheight / 15,
                    width: screenWidth - 100,
                    child: Center(
                      child: Text(
                        "Reset Password",
                        style:
                            TextStyle(color: Colors.white, fontSize: fontSize),
                      ),
                    ),
                  ),
                )),

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
