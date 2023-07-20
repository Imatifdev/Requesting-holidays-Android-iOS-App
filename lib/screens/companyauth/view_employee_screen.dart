import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:holidays/screens/companyauth/edit_employee.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import '../../models/company/viewemployeedata.dart';
import '../../viewmodel/company/compuserviewmodel.dart';
import '../../widget/constants.dart';

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:convert';

class ViewEmployee extends StatefulWidget {
  final Employee employee;
  const ViewEmployee({super.key, required this.employee});

  @override
  State<ViewEmployee> createState() => _ViewEmployeeState();
}

class _ViewEmployeeState extends State<ViewEmployee> {
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

  bool isLoading = false;

  Future<void> deleteCompanyEm(String token, Employee em) async {
    setState(() {
      isLoading = true;
    });
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
      final jsonData = json.decode(response.body);
      print(jsonData);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      print(response.statusCode);
      setState(() {
        isLoading = false;
      });
      // Error occurred
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
      fontSize = 13.0;
      title = 16;
      heading = 24; // Small screen (e.g., iPhone 4S)
    } else if (screenWidth < 375) {
      fontSize = 15.0;
      title = 24;

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

    final comViewModel = Provider.of<CompanyViewModel>(context);
    final token = comViewModel.token;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: appbar,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appbar,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              CupertinoIcons.left_chevron,
              color: Colors.black,
            )),
      ),
      body: SafeArea(
          child: SizedBox(
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            child: Column(
              children: [
                Column(
                  children: [
                    const Text(
                      "Employee Details",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ).pOnly(left: 24),
                    const SizedBox(
                      height: 25,
                    ),
                    detailCard(
                        context, "First Name", widget.employee.firstName),
                    detailCard(context, "Last Name", widget.employee.lastName),
                    detailCard(context, "Email", widget.employee.email),
                    detailCard(context, "Working Days",
                        widget.employee.getWorkingDaysAsString()),
                    detailCard(context, "Phone Number", widget.employee.phone),
                    detailCard(context, "Verified Status",
                        getStatus(widget.employee.isVerified)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                            icon: Icon(Icons.edit_note_rounded),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditEmployee(
                                    emp: widget.employee,
                                    email: widget.employee.email,
                                    first_name: widget.employee.firstName,
                                    last_name: widget.employee.lastName,
                                    mobile: widget.employee.phone),
                              ));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xffED930B),
                                padding: const EdgeInsets.all(10)),
                            label: Text(
                              "Edit",
                              style: TextStyle(
                                  color: Colors.white, fontSize: fontSize),
                            )),
                        ElevatedButton(
                            onPressed: () {
                              deleteCompanyEm(token!, widget.employee);
                            },
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(10)),
                            child: isLoading
                                ? const CircularProgressIndicator()
                                : const Text("Delete")),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  String getStatus(String status) {
    if (status == "1") {
      return "Active";
    } else {
      return "Inactive";
    }
  }

  Container detailCard(BuildContext context, String name, String detail) {
    Size size = MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    double fontSize;
    double title;
    double heading;

    // Adjust the font size based on the screen width
    if (screenWidth < 320) {
      fontSize = 13.0;
      title = 16;
      heading = 24; // Small screen (e.g., iPhone 4S)
    } else if (screenWidth < 375) {
      fontSize = 15.0;
      title = 24;

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

    return Container(
      width: size.width - 50,
      color: appbar,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name,
                  style: TextStyle(
                      fontSize: fontSize,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold)),
              Text(detail)
            ],
          ),
          Divider(
            color: Colors.grey,
            thickness: 0.5,
          )
        ],
      ),
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
