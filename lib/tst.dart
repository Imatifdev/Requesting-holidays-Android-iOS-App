import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage3 extends StatefulWidget {
  @override
  _LoginPage3State createState() => _LoginPage3State();
}

class _LoginPage3State extends State<LoginPage3> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> performLogin() async {
    final String apiUrl = 'https://jporter.ezeelogix.com/public/api/login';

    final response = await http.post(Uri.parse(apiUrl), body: {
      'email': emailController.text,
      'password': passwordController.text,
      'user_type': '1'
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['status'] == 'Success') {
        final user = jsonData['data']['user'];
        final token = jsonData['data']['token'];

        // User data
        final userId = user['id'];
        final firstName = user['first_name'];
        final lastName = user['last_name'];
        final phone = user['phone'];
        final email = user['email'];

        // Store user data in shared preferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('userId', userId.toString());
        prefs.setString('firstName', firstName);
        prefs.setString('lastName', lastName);
        prefs.setString('phone', phone);
        prefs.setString('email', email);

        // Token
        print('Token: $token');

        // Navigate to the next screen or perform any desired action
        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => ProfilePage()));
      } else {
        // Login failed
        print('Login failed');
      }
    } else {
      // Error occurred
      print('Error: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: performLogin,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('firstName') ?? '';
      lastName = prefs.getString('lastName') ?? '';
      email = prefs.getString('email') ?? '';
      phone = prefs.getString('phone') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('First Name: $firstName'),
            SizedBox(height: 10.0),
            Text('Last Name: $lastName'),
            SizedBox(height: 10.0),
            Text('Email: $email'),
            SizedBox(height: 10.0),
            Text('Phone: $phone'),
          ],
        ),
      ),
    );
  }
}
