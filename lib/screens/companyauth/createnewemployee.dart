import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:holidays/viewmodel/company/compuserviewmodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  TextEditingController companyIDController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController totalLeavesController = TextEditingController();

  bool mondayChecked = false;
  bool tuesdayChecked = false;
  bool wednesdayChecked = false;
  bool thursdayChecked = false;
  bool fridayChecked = false;
  bool saturdayChecked = false;
  bool sundayChecked = false;

  void makeApiRequest(String token, String id) async {
    final url = Uri.parse(
        'https://jporter.ezeelogix.com/public/api/company-create-employee');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = {
      'company_id': id,
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'password': passwordController.text,
      'password_confirmation': confirmPasswordController.text,
      'total_leaves': totalLeavesController.text,
      'monday': mondayChecked ? '1' : '0',
      'tuesday': tuesdayChecked ? '1' : '0',
      'wednesday': wednesdayChecked ? '1' : '0',
      'thursday': thursdayChecked ? '1' : '0',
      'friday': fridayChecked ? '1' : '0',
      'saturday': saturdayChecked ? '1' : '0',
      'sunday': sundayChecked ? '1' : '0',
    };

    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200) {
      // Request successful, handle the response
      Fluttertoast.showToast(
          msg: "User Created Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      print(response.body);
    } else {
      // Request failed, handle the error
      // print('Request failed with status: ${response.statusCode}');
      Fluttertoast.showToast(
          msg: "Email is already existing",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      //print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    final comViewModel = Provider.of<CompanyViewModel>(context);
    final token = comViewModel.token;
    final companyViewModel = Provider.of<CompanyViewModel>(context);
    final user = companyViewModel.user;
    final companyId = user!.id;

    return Scaffold(
      appBar: AppBar(title: Text('Employee Form')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            TextField(
              controller: totalLeavesController,
              decoration: InputDecoration(labelText: 'Total Leaves'),
            ),
            Column(
              children: [
                CheckboxListTile(
                  title: Text('Monday'),
                  value: mondayChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      mondayChecked = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Tuesday'),
                  value: tuesdayChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      tuesdayChecked = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Wednesday'),
                  value: wednesdayChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      wednesdayChecked = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Thursday'),
                  value: thursdayChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      thursdayChecked = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Friday'),
                  value: fridayChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      fridayChecked = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Saturday'),
                  value: saturdayChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      saturdayChecked = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Sunday'),
                  value: sundayChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      sundayChecked = value!;
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                makeApiRequest(token!, companyId.toString());
              },
              child: Text("Create"),
            )
          ]),
        ),
      ),
    );
  }
}
