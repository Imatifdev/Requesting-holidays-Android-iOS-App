import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:holidays/screens/companyauth/leave_requests_company.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../models/leave.dart';
import '../../viewmodel/employee/empuserviewmodel.dart';
import 'approved_leaves.dart';
import 'declined_leaves.dart';
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:convert';

class HomeCompany extends StatefulWidget {
  @override
  _HomeCompanyState createState() => _HomeCompanyState();
}

class _HomeCompanyState extends State<HomeCompany> {
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

  int _currentIndex = 0;
  int check = 0;

  List<LeaveRequest> leaveRequests = [];
  List<LeaveRequest> approvedLeaves = [];
  List<LeaveRequest> rejectedLeaves = [];

  Future<void> _getallpendingLeaveRequest(String token, String id) async {
    const String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/employee-get-all-pending-leaves';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'employee_id': id,
    });

    if (response.statusCode == 200) {
      // Leave request successful
      final jsonDataMap = json.decode(response.body);
      print(jsonDataMap);
      List<dynamic> requestedLeaves = jsonDataMap['data']['requested_leaves'];
      setState(() {
        leaveRequests =
            requestedLeaves.map((json) => LeaveRequest.fromJson(json)).toList();
      });
      // Handle success scenario
    } else {
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
    }
  }

  Future<void> _getallapprovedLeaveRequest(String token, String id) async {
    const String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/employee-get-all-approved-leaves';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'employee_id': id,
    });

    if (response.statusCode == 200) {
      // Leave request successful
      final jsonDataMap = json.decode(response.body);
      print(jsonDataMap);
      List<dynamic> requestedLeaves = jsonDataMap['data']['requested_leaves'];
      setState(() {
        approvedLeaves =
            requestedLeaves.map((json) => LeaveRequest.fromJson(json)).toList();
      });
      // Handle success scenario
    } else {
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
    }
  }

  Future<void> _getallrejectedLeaveRequest(String token, String id) async {
    const String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/employee-get-all-rejected-leaves';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'employee_id': id,
    });

    if (response.statusCode == 200) {
      // Leave request successful
      final jsonDataMap = json.decode(response.body);
      print(jsonDataMap);
      List<dynamic> requestedLeaves = jsonDataMap['data']['requested_leaves'];
      setState(() {
        rejectedLeaves =
            requestedLeaves.map((json) => LeaveRequest.fromJson(json)).toList();
      });
      //Handle success scenario
    } else {
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
    }
  }

  @override
  Widget build(BuildContext context) {
    final empViewModel = Provider.of<EmpViewModel>(context);
    final token = empViewModel.token;
    final userId = empViewModel.user!.id;
    if (check == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _getallpendingLeaveRequest(token!, userId.toString());
        _getallapprovedLeaveRequest(token, userId.toString());
        _getallrejectedLeaveRequest(token, userId.toString());
      });
      check = 1;
    }
    final List<Widget> _screens = [
      ReceivedRequests(leaveRequests: leaveRequests),
      const Text("2"),
      ApprovedLeaves(approvedLeaves: approvedLeaves),
      DeclinedLeaves(
        rejectedLeaves: rejectedLeaves,
      )
    ];
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     ElevatedButton(onPressed: ()=>_getallapprovedLeaveRequest(token!), child: const Text("approved")),
      //     ElevatedButton(onPressed: ()=>_getallrejectedLeaveRequest(token!), child: const Text("declined")),
      //   ],
      // ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: Colors.black,
            ),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check_box,
              color: Colors.green,
            ),
            label: 'Approved',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.cancel,
              color: Colors.red,
            ),
            label: 'Declined',
          ),
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
