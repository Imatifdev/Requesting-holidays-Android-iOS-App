// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:holidays/screens/companyauth/edit_employee.dart';
import 'package:holidays/screens/companyauth/view_employee_screen.dart';
import 'package:holidays/viewmodel/company/compuserviewmodel.dart';
import 'package:holidays/widget/constants.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../models/company/viewemployeedata.dart';
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:convert';

class ShowEmployee extends StatefulWidget {
  const ShowEmployee({super.key});

  @override
  State<ShowEmployee> createState() => _ShowEmployeeState();
}

class _ShowEmployeeState extends State<ShowEmployee> {
  late StreamSubscription subscription;

  bool isDeviceConnected = false;
  bool isAlertSet = false;
  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

  List<Employee> showemployees = [];
  var check = 0;

  Future<void> getEmployees(String token, String id) async {
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

  Future<void> deleteCompanyEm(String token, Employee em) async {
    const String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/company-delete-employee';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'company_id': em.companyId.toString(),
      'employee_id': em.id.toString(),
    });
    if (response.statusCode == 200) {
      // Leave request successful
      Fluttertoast.showToast(
          msg: "Employee Deleted Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      final jsonData = json.decode(response.body);
      print(jsonData);
      setState(() {
        showemployees.removeWhere((empy) => empy.id == em.id);
      });

      Navigator.pop(context);
    } else {
      print(response.statusCode);
      // Error occurred
      Fluttertoast.showToast(
          msg: "Employee could not deleted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
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
      fontSize = 11.0;
      title = 16;
      heading = 10; // Small screen (e.g., iPhone 4S)
    } else if (screenWidth < 375) {
      fontSize = 12.0;
      title = 20;

      heading = 12; // Medium screen (e.g., iPhone 6, 7, 8)
    } else if (screenWidth < 414) {
      fontSize = 15.0;
      title = 22;

      heading = 14; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else if (screenWidth < 600) {
      fontSize = 19.0;
      title = 26;

      heading = 18; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else {
      fontSize = 22.0;
      title = 19;

      heading = 30; // Extra large screen or unknown device
    }

    final comViewModel = Provider.of<CompanyViewModel>(context);
    final token = comViewModel.token;
    final user = comViewModel.user;
    final companyId = user!.id;
    if (check == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getEmployees(token!, companyId.toString());
      });
      check = 1;
    }
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: appbar,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appbar,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
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
                  style:
                      TextStyle(fontSize: title, fontWeight: FontWeight.bold),
                ).pOnly(left: 24),
                SizedBox(
                  height: 25,
                ),
                Container(
                  height: height / 1.3,
                  child: ListView.builder(
                    itemCount: showemployees.length,
                    itemBuilder: (context, index) {
                      Employee employee = showemployees[index];
                      return empCard(token!, companyId.toString(), employee)
                          .pSymmetric(h: 20, v: 5);
                    },
                  ),
                ),
              ],
            )
          : Center(child: const CircularProgressIndicator()),
    );
  }

  Container empCard(String token, String companyId, Employee emp) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    double fontSize;
    double title;
    double heading;

    // Adjust the font size based on the screen width
    if (screenWidth < 320) {
      fontSize = 11.0;
      title = 16;
      heading = 10; // Small screen (e.g., iPhone 4S)
    } else if (screenWidth < 375) {
      fontSize = 12.0;
      title = 20;

      heading = 12; // Medium screen (e.g., iPhone 6, 7, 8)
    } else if (screenWidth < 414) {
      fontSize = 15.0;
      title = 22;

      heading = 14; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else if (screenWidth < 600) {
      fontSize = 19.0;
      title = 26;

      heading = 18; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else {
      fontSize = 22.0;
      title = 19;

      heading = 30; // Extra large screen or unknown device
    }

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: Colors.grey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            emp.firstName,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                emp.email,
                style: TextStyle(
                    fontSize: fontSize, fontWeight: FontWeight.normal),
              ),
              // SizedBox(
              //   width: 10,
              // ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        emp.isVerified == '0' ? Colors.blue : Colors.grey,
                    radius: 5,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    emp.isVerified == '0' ? "Inactive" : "Active",
                    style: TextStyle(
                        fontSize: fontSize, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: screenWidth / 6,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xffED930B)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      title: Text(
                                        'Confirmation Message',
                                        style: TextStyle(
                                            color: red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: SizedBox(
                                        height: 140,
                                        child: Column(
                                          children: [
                                            Text(
                                                'Are you sure you would like to Edit this employee details?'),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Go Back'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditEmployee(
                                                        emp: emp,
                                                        email: emp.email
                                                            .toString(),
                                                        first_name:
                                                            emp.firstName,
                                                        last_name: emp.lastName,
                                                        mobile: emp.phone,
                                                      ),
                                                    ))
                                                        .then((value) {
                                                      setState(() {
                                                        getEmployees(
                                                            token,
                                                            companyId
                                                                .toString());
                                                      });
                                                    });
                                                  },
                                                  child: Text(
                                                    'Edit ',
                                                    style: TextStyle(
                                                        fontSize: fontSize),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ));
                          },
                          child: Center(
                              child: Text(
                            "Edit",
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          )),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Text(
                              'Confirmation Message',
                              style: TextStyle(
                                  color: red, fontWeight: FontWeight.bold),
                            ),
                            content: SizedBox(
                              height: 120,
                              child: Column(
                                children: [
                                  Text(
                                      'Are you sure you would like to delete this employee?'),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Go Back'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          deleteCompanyEm(token, emp);
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );

//                        deleteCompanyEm(token, emp);
                      },
                      child: Container(
                        width: screenWidth / 6,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5), color: red),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          )),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ViewEmployee(employee: emp),
                        ));
                      },
                      child: Container(
                        width: screenWidth / 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.blueAccent),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                            "View Employee",
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          )),
                        ),
                      ),
                    ),
                  ],
                ).pOnly(top: 10),
              ),
            ],
          )
        ],
      ).p(10),
    );
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
}
