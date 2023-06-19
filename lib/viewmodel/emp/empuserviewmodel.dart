import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/emp/empusermodel.dart';

class EmpViewModel extends ChangeNotifier {
  EmpUser? _user;
  String? _token;

  EmpUser? get user => _user;
  String? get token => _token;

  Future<void> performLogin(String email, String password) async {
    final String apiUrl = 'https://jporter.ezeelogix.com/public/api/login';

    final response = await http.post(Uri.parse(apiUrl), body: {
      'email': email,
      'password': password,
    });

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

        // Notify listeners about the updated data
        notifyListeners();
      } else {
        // Login failed
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
}
