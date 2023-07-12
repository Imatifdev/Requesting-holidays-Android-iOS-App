import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:holidays/viewmodel/company/compuserviewmodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

import '../../widget/constants.dart';
import 'companydashboard.dart';

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
  Map<int, bool> selectedDays = {};
  List<int> dayValues = List<int>.filled(7, 0);

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
      "monday": dayValues[0].toString(),
      "tuesday": dayValues[1].toString(),
      "wednesday": dayValues[2].toString(),
      "thursday": dayValues[3].toString(),
      "friday": dayValues[4].toString(),
      "saturday": dayValues[5].toString(),
      "sunday": dayValues[6].toString(),
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
      Navigator.push(
          context, MaterialPageRoute(builder: (ctx) => CompanyDashBoard()));
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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('Employee Form')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              right:
                                  BorderSide(width: 1.0, color: Colors.black),
                            ),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: red,
                          )),
                    ),
                    labelText: 'First Name',
                  ),
                  obscureText: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              right:
                                  BorderSide(width: 1.0, color: Colors.black),
                            ),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: red,
                          )),
                    ),
                    labelText: 'Last Name',
                  ),
                  obscureText: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              right:
                                  BorderSide(width: 1.0, color: Colors.black),
                            ),
                          ),
                          child: const Icon(
                            Icons.email,
                            color: red,
                          )),
                    ),
                    labelText: 'Email',
                  ),
                  obscureText: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              right:
                                  BorderSide(width: 1.0, color: Colors.black),
                            ),
                          ),
                          child: const Icon(
                            Icons.phone,
                            color: red,
                          )),
                    ),
                    labelText: 'Phone',
                  ),
                  obscureText: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              right:
                                  BorderSide(width: 1.0, color: Colors.black),
                            ),
                          ),
                          child: const Icon(
                            Icons.lock,
                            color: red,
                          )),
                    ),
                    labelText: 'Password',
                  ),
                  obscureText: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              right:
                                  BorderSide(width: 1.0, color: Colors.black),
                            ),
                          ),
                          child: const Icon(
                            Icons.lock,
                            color: red,
                          )),
                    ),
                    labelText: 'Confirm Password',
                  ),
                  obscureText: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: totalLeavesController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              right:
                                  BorderSide(width: 1.0, color: Colors.black),
                            ),
                          ),
                          child: const Icon(
                            Icons.note_alt,
                            color: red,
                          )),
                    ),
                    labelText: 'Total Leaves',
                  ),
                  obscureText: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Working Days",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),

                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: size.height / 9,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(5.0),
                        child: dayCard(index),
                      );
                    },
                  ),
                ),
                // Column(
                //   children: [
                //     CheckboxListTile(
                //       title: Text('Monday'),
                //       value: mondayChecked,
                //       onChanged: (bool? value) {
                //         setState(() {
                //           mondayChecked = value!;
                //         });
                //       },
                //     ),
                //     CheckboxListTile(
                //       title: Text('Tuesday'),
                //       value: tuesdayChecked,
                //       onChanged: (bool? value) {
                //         setState(() {
                //           tuesdayChecked = value!;
                //         });
                //       },
                //     ),
                //     CheckboxListTile(
                //       title: Text('Wednesday'),
                //       value: wednesdayChecked,
                //       onChanged: (bool? value) {
                //         setState(() {
                //           wednesdayChecked = value!;
                //         });
                //       },
                //     ),
                //     CheckboxListTile(
                //       title: Text('Thursday'),
                //       value: thursdayChecked,
                //       onChanged: (bool? value) {
                //         setState(() {
                //           thursdayChecked = value!;
                //         });
                //       },
                //     ),
                //     CheckboxListTile(
                //       title: Text('Friday'),
                //       value: fridayChecked,
                //       onChanged: (bool? value) {
                //         setState(() {
                //           fridayChecked = value!;
                //         });
                //       },
                //     ),
                //     CheckboxListTile(
                //       title: Text('Saturday'),
                //       value: saturdayChecked,
                //       onChanged: (bool? value) {
                //         setState(() {
                //           saturdayChecked = value!;
                //         });
                //       },
                //     ),
                //     CheckboxListTile(
                //       title: Text('Sunday'),
                //       value: sundayChecked,
                //       onChanged: (bool? value) {
                //         setState(() {
                //           sundayChecked = value!;
                //         });
                //       },
                //     ),
                //   ],
                // ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      print(dayValues);
                      makeApiRequest(token!, companyId.toString());
                    },
                    child: Text("Create"),
                  ),
                )
              ]),
        ),
      ),
    );
  }

  Container dayCard(int index) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: [
            Text(
              _getDayOfWeek(index),
              style: const TextStyle(fontSize: 12),
            ),
            Checkbox(
              value: dayValues[index] == 1,
              onChanged: (bool? value) {
                setState(() {
                  dayValues[index] = value! ? 1 : 0;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getDayOfWeek(int index) {
    switch (index) {
      case 0:
        return 'SUN';
      case 1:
        return 'MON';
      case 2:
        return 'TUE';
      case 3:
        return 'WED';
      case 4:
        return 'THU';
      case 5:
        return 'FRI';
      case 6:
        return 'SAT';
      default:
        return '';
    }
  }
}
