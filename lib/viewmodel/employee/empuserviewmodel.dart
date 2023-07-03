// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:holidays/screens/companyauth/home_company.dart';
import 'package:holidays/screens/companyauth/profile.dart';
import 'package:holidays/screens/empauth/dashboard.dart';
import 'package:holidays/screens/empauth/otpscreen.dart';
import 'package:holidays/screens/empauth/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/company/compusermodel.dart';
import '../../models/emp/empusermodel.dart';
import '../../screens/companyauth/leave_requests_company.dart';
import '../../widget/popuploader.dart';

class EmpViewModel extends ChangeNotifier {
  EmpUser? _user;
  String? _token;

  EmpUser? get user => _user;
  String? get token => _token;

  Future<void> performLogin(
      String email, String password, BuildContext context) async {
    final String apiUrl = 'https://jporter.ezeelogix.com/public/api/login';
    PopupLoader.show();

    final response = await http.post(Uri.parse(apiUrl),
        body: {'email': email, 'password': password, 'user_type': '2'});
    PopupLoader.hide();

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['status'] == 'Success') {
        final userJson = jsonData['data']['user'];
        final token = jsonData['data']['token'];

        _user = EmpUser.fromJson(userJson);
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
              builder: (context) => EmpOtpScreen(
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

  Future<void> requestLeave(
    String employeeId,
    String leaveType,
    String startDate,
    String endDate,
    String totalLeaveCount,
    String comment,
  ) async {
    final String apiUrl =
        'https://jporter.ezeelogix.com/public/api/employee-request-leave';
    final token = _token;

    if (token == null) {
      // Token not available, handle the error
      return;
    }

    final headers = {
      'Accept': 'application/json',
      'Authorization': token,
    };

    final body = {
      'employee_id': employeeId,
      'leave_type': leaveType,
      'start_date': startDate,
      'end_date': endDate,
      'total_leave_count': totalLeaveCount,
      'comment': comment,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // Handle the response as needed
        print(jsonData);
      } else {
        // Handle the error
        print(_token);

        print(response.statusCode);
      }
    } catch (e) {
      // Handle any exceptions
      print('Error: $e');
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
