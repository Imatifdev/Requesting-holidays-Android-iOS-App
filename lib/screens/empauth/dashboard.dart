// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields

import 'dart:convert';
import 'package:holidays/screens/empauth/profile.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
//import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:holidays/screens/empauth/request_leave.dart';
//import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/leave.dart';
import '../../viewmodel/employee/empuserviewmodel.dart';

class LeaveScreen extends StatefulWidget {
  @override
  _LeaveScreenState createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  // DateTime? _firstDate;
  // DateTime? _lastDate;
  // DateTimeRange   _selectedDateRange = DateTimeRange(
  //     start: DateTime.now(),
  //     end: DateTime.now().add(Duration(days: 1)),
  //   );
  int check = 0;
  List<LeaveRequest> leaveRequests = [];
  List<LeaveRequest> commpassionateLeaves = [];
  List<LeaveRequest> lieuLeaves = [];
  List<LeaveRequest> approvedLeaves = [];
  List<LeaveRequest> rejectedLeaves = [];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  Future<void> _getallLeaveRequest(String token) async {
    //final empViewModel = Provider.of<EmpViewModel>(context);
    //final user = empViewModel.user;

    const String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/employee-get-all-requested-leaves';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'employee_id': 1.toString(),
    });

    if (response.statusCode == 200) {
      // Leave request successful
      final jsonDataMap = json.decode(response.body);
      print(jsonDataMap);
      List<dynamic> requestedLeaves = jsonDataMap['data']['requested_leaves'];
      setState(() {
        leaveRequests =
            requestedLeaves.map((json) => LeaveRequest.fromJson(json)).toList();

        for (LeaveRequest request in leaveRequests) {
          if (request.leaveType == "Compassionate") {
            commpassionateLeaves.add(request);
          } else if (request.leaveType == "Lieu") {
            lieuLeaves.add(request);
          }
        }
      });
      // Handle success scenario
    } else {
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
    }
  }

  Future<void> _getallapprovedLeaveRequest(String token) async {
    // final empViewModel = Provider.of<EmpViewModel>(context);
    // final user = empViewModel.user;

    const String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/employee-get-all-approved-leaves';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'employee_id': 1.toString(),
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

  Future<void> _getallrejectedLeaveRequest(String token) async {
    // final empViewModel = Provider.of<EmpViewModel>(context);
    // final user = empViewModel.user;

    const String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/employee-get-all-rejected-leaves';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'employee_id': 1.toString(),
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
    if (check == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _getallLeaveRequest(token!);
        _getallapprovedLeaveRequest(token);
        _getallrejectedLeaveRequest(token);
      });
      check = 1;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.left_chevron,
            color: Colors.red,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.profile_circled,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => EmpProfileView()));
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 40),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Leaves",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RequestLeave(),
                        ));
                      },
                      //_openLeaveDialog,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)),
                        height: 30,
                        width: 30,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Text(
                      "All ",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      child: Text(
                        "Compassionate",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Lieu",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      child: Text(
                        "Approved",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      child: Text(
                        "Rejected",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLeaveList(leaveRequests),
          _buildLeaveList(commpassionateLeaves),
          _buildLeaveList(lieuLeaves),
          _buildLeaveList(approvedLeaves),
          _buildLeaveList(rejectedLeaves),
          //_buildLeaveList(lieuLeaves),
        ],
      ),
    );
  }

  Widget _buildLeaveList(List<LeaveRequest> leaves) {
    return leaves.isNotEmpty
        ? ListView.builder(
            itemCount: leaves.length,
            itemBuilder: (context, index) {
              final leave = leaves[index];
              // String fromDate =
              // DateFormat('EEE, MMM d, yyyy').format(leave.startDate);
              // String toDate =
              // DateFormat('EEE, MMM d, yyyy').format(leave.toDate);
              return Padding(
                padding: const EdgeInsets.all(13.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              //${leave.totalRequestLeave}
                              '${leave.totalRequestLeave} day Application ',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: leave.leaveCurrentStatus == 'Pending'
                                      ? Colors.red
                                      : Colors.green,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(leave.leaveCurrentStatus,
                                    style: TextStyle(
                                        color: leave.leaveCurrentStatus ==
                                                'Pending'
                                            ? Colors.red.shade100
                                            : Colors.green.shade100)),
                              )),
                            )
                          ],
                        ),
                        Text(
                          'From: ${leave.startDate}',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: leave.leaveType == 'Compassionate'
                                  ? Colors.red
                                  : Colors.blue),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'To: ${leave.endDate},',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              leave.leaveType,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade300),
                              child: Center(
                                child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      CupertinoIcons.right_chevron,
                                      size: 20,
                                    )),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        : Center(
            child: Text("No Leaves"),
          );
  }
}
