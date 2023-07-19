// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:holidays/screens/companyauth/update_company_leave.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../models/company/companyleavemodel.dart';
import '../../viewmodel/company/compuserviewmodel.dart';
import '../../widget/constants.dart';
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:convert';

class GetCompanyLeaves extends StatefulWidget {
  @override
  _GetCompanyLeavesState createState() => _GetCompanyLeavesState();
}

class _GetCompanyLeavesState extends State<GetCompanyLeaves> {
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

  int check = 0;

  List<CompanyLeave1> companyLeaves = [];

  void showConfirmationDialogfordelete(
      BuildContext context, CompanyLeave1 leave, String token) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Confirmation Message',
          style: TextStyle(color: red, fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          height: 120,
          child: Column(
            children: [
              Text('Are you sure you would like to delete this employee?'),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Go Back'),
                  ),
                  TextButton(
                    onPressed: () {
                      deleteCompanyLeave(token, leave);

                      Navigator.of(context).pop(); // Close the dialog
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
  }

  Future<void> fetchCompanyLeaves(String token, String id) async {
    const String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/get-company-leaves';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'company_id': id.toString(),
    });
    if (response.statusCode == 200) {
      // Leave request successful
      final jsonData = json.decode(response.body);
      print(jsonData);
      // Handle success scenario
      List<dynamic> requestedLeaves = jsonData["data"];
      setState(() {
        companyLeaves = requestedLeaves
            .map((json) => CompanyLeave1.fromJson(json))
            .toList();
      });
    } else {
      print(response.statusCode);
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
    }
  }

  Future<void> deleteCompanyLeave(String token, CompanyLeave1 leave) async {
    const String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/delete-company-leaves';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'company_id': leave.companyId.toString(),
      'leave_id': leave.id.toString(),
    });
    if (response.statusCode == 200) {
      // Leave request successful
      final jsonData = json.decode(response.body);
      print(jsonData);
      setState(() {
        companyLeaves.removeWhere((lev) => lev.id == leave.id);
      });
    } else {
      print(response.statusCode);
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
    }
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
        fetchCompanyLeaves(token!, companyId.toString());
      });
      check = 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Leaves'),
      ),
      body: companyLeaves.isNotEmpty
          ? ListView.builder(
              itemCount: companyLeaves.length,
              itemBuilder: (context, index) {
                CompanyLeave1 leave = companyLeaves[index];
                return ListTile(
                  leading: IconButton(
                      onPressed: () {
                        {
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
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdateCompanyLeave(
                                                      leave: leave,
                                                      token: token!),
                                            ))
                                                .then((value) {
                                              setState(() {
                                                fetchCompanyLeaves(token!,
                                                    companyId.toString());
                                              });
                                            });
                                          },
                                          child: Text('Update'),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.update)),
                  title: Text(leave.title),
                  subtitle: Text('Dates:   ${leave.date}'),
                  trailing: IconButton(
                      onPressed: () {
                        //deleteCompanyLeave(token!, leave);
                        showConfirmationDialogfordelete(context, leave, token!);
                      },
                      icon: const Icon(Icons.delete)),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
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
