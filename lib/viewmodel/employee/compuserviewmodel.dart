// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:holidays/screens/companyauth/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/company/compusermodel.dart';
import '../../screens/companyauth/otp.dart';
import '../../screens/empauth/dashboard.dart';
import '../../widget/popuploader.dart';

class CompanyViewModel extends ChangeNotifier {
  CompanyUser? _user;
  String? _token;

  CompanyUser? get user => _user;
  String? get token => _token;

  Future<void> performLogin(
      String email, String password, BuildContext context) async {
    final String apiUrl = 'https://jporter.ezeelogix.com/public/api/login';
    PopupLoader.show();

    final response = await http.post(Uri.parse(apiUrl),
        body: {'email': email, 'password': password, 'user_type': '1'});
    PopupLoader.hide();

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['status'] == 'Success') {
        final userJson = jsonData['data']['user'];
        final token = jsonData['data']['token'];

        _user = CompanyUser.fromJson(userJson);
        _token = token;

        // Store data in shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', _token!);
        // Serialize and store user object if needed
        print(jsonData);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LeaveScreen()),
        );
        notifyListeners();
      } else {
        // Login failed
        Fluttertoast.showToast(
            msg: "Verify your email through OTP sent to your email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CompanyOtpScreen(
                    email: email,
                  )),
        );
        print('');

        print('Login failed');
      }
    } else {
      // Error occurred
      print('Error: ${response.reasonPhrase}');
    }
  }

  Future<void> retrieveUserDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    // Retrieve and deserialize user object if stored

    // Notify listeners about the updated data
    notifyListeners();
  }

  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    // Clear any other stored user data if needed

    _user = null;
    _token = null;

    // Notify listeners about the updated data
    notifyListeners();
  }
}
