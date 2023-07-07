// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:holidays/viewmodel/company/compuserviewmodel.dart';
import 'package:holidays/widget/constants.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../models/company/viewemployeedata.dart';

class ShowEmployee extends StatefulWidget {
  const ShowEmployee({super.key});

  @override
  State<ShowEmployee> createState() => _ShowEmployeeState();
}

class _ShowEmployeeState extends State<ShowEmployee> {
  List<Employee> showemployees = [];

  var check = 0;

  Future<void> newcallApi(String token, String id) async {
    // Define the base URL and endpoint
    final baseUrl = 'https://jporter.ezeelogix.com/public/api/';
    final endpoint = 'company-all-employees';

    // Prepare the request body
    final requestBody = {
      'company_id': id,
    };

    // Prepare the request headers
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      // Send the POST request
      final response = await http.post(
        Uri.parse(baseUrl + endpoint),
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Request successful
        final responseData = json.decode(response.body);
        // Handle the response data as needed
        print(responseData);
      } else {
        // Request failed
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      // An error occurred
      print('Error: $error');
    }
  }

  Future<ShowEmployees?> newcallApi1(String token, String id) async {
    // Define the base URL and endpoint
    final baseUrl = 'https://jporter.ezeelogix.com/public/api/';
    final endpoint = 'company-all-employees';

    // Prepare the request body
    final requestBody = {
      'company_id': id,
    };

    // Prepare the request headers
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      // Send the POST request
      final response = await http.post(
        Uri.parse(baseUrl + endpoint),
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Request successful
        final responseData = json.decode(response.body);
        print(responseData);
        // Create and return the ShowEmployees object
        List<dynamic> requestedLeaves = responseData["data"]['employee'];
        setState(() {
          showemployees =
              requestedLeaves.map((json) => Employee.fromJson(json)).toList();
        });
      } else {
        // Request failed
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      // An error occurred
      print('Error: $error');
    }

    // Return null if there was an error or the request failed
  }

  @override
  Widget build(BuildContext context) {
    final comViewModel = Provider.of<CompanyViewModel>(context);
    final token = comViewModel.token;
    final companyViewModel = Provider.of<CompanyViewModel>(context);
    final user = companyViewModel.user;
    final companyId = user!.id;
    if (check == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        newcallApi1(token!, companyId.toString());
      });
      check = 1;
    }
    final height = MediaQuery.of(context).size.height;

    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: appbar,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appbar,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.left_chevron,
              color: Colors.black,
            )),
      ),
      body: showemployees.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "All Employees",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ).pOnly(left: 24),
                SizedBox(
                  height: 25,
                ),
                Container(
                  height: height / 1.3,
                  child: ListView.builder(
                    itemCount: showemployees.length,
                    itemBuilder: (context, index) {
                      Employee leave = showemployees[index];
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              leave.firstName,
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(
                                  leave.email,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.normal),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Days",
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.normal),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  leave.phone,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: leave.isVerified == '0'
                                          ? Colors.blue
                                          : Colors.grey,
                                      radius: 5,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      leave.isVerified == '0'
                                          ? "Inactive"
                                          : "Active",
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 50,
                                      child: Center(
                                          child: Text(
                                        "Edit",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 11),
                                      )),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Color(0xffED930B)),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: 22,
                                      width: 70,
                                      child: Center(
                                          child: Text(
                                        "Delete",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 11),
                                      )),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: red),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: 22,
                                      width: 90,
                                      child: Center(
                                          child: Text(
                                        "View Employee",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 11),
                                      )),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.blueAccent),
                                    ),
                                  ],
                                ).pOnly(top: 10),
                              ],
                            )
                          ],
                        ).p(10),
                      ).pSymmetric(h: 20, v: 5);
                    },
                  ),
                ),
              ],
            )
          : const Text("No Company Leaves"),
    );
  }
}
