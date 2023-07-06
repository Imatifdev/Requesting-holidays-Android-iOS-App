// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_declarations, unused_element, must_be_immutable

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:holidays/screens/companyauth/api_test.dart';
import 'package:holidays/screens/companyauth/createnewemployee.dart';
import 'package:holidays/screens/companyauth/profile.dart';
import 'package:holidays/screens/companyauth/search_screen.dart';
import 'package:holidays/viewmodel/company/compuserviewmodel.dart';
import 'package:holidays/widget/leave_req_card.dart';
import 'package:provider/provider.dart';
import '../../models/leave.dart';
import '../../widget/constants.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:http/http.dart' as http;

import 'createcompanyleaves.dart';
import 'getcompanyleaves.dart';

class CompanyDashBoard extends StatefulWidget {
  const CompanyDashBoard({super.key});

  @override
  _CompanyDashBoardState createState() => _CompanyDashBoardState();
}

class _CompanyDashBoardState extends State<CompanyDashBoard> {
  List<LeaveRequest> leaves = [];
  List<LeaveRequest> pendingLeaves = [];
  List<LeaveRequest> approvedLeaves = [];
  List<LeaveRequest> rejectedLeaves = [];
  int check = 0;
  int _currentIndex = 0;

  Future<void> _getallLeaveRequest(String token) async {
    final String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/company-get-all-requested-leaves';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'company_id': '1',
    });
    if (response.statusCode == 200) {
      // Leave request successful
      final jsonData = json.decode(response.body);
      print(jsonData);
      // Handle success scenario
      List<dynamic> requestedLeaves =
          jsonData["data"]["employee_requested_leaves"];
      setState(() {
        leaves =
            requestedLeaves.map((json) => LeaveRequest.fromJson(json)).toList();
        for (LeaveRequest leave in leaves) {
          if (leave.leaveCurrentStatus == "Pending") {
            pendingLeaves.add(leave);
          }
        }
        for (LeaveRequest leave in leaves) {
          if (leave.leaveCurrentStatus == "Accepted") {
            approvedLeaves.add(leave);
          }
        }
        for (LeaveRequest leave in leaves) {
          if (leave.leaveCurrentStatus == "Rejected") {
            rejectedLeaves.add(leave);
          }
        }
      });
      print(leaves);
    } else {
      print(response.statusCode);
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
    }
  }

  @override
  Widget build(BuildContext context) {
    final empViewModel = Provider.of<CompanyViewModel>(context);
    final token = empViewModel.token;
    if (check == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _getallLeaveRequest(token!);
      });
      check = 1;
    }
    final List<Widget> _pages = [
      AllApplications(
        pendingLeaves: pendingLeaves,
      ),
      CreateCompanyLeave(),
      ApprovedApplications(),
      RejectedApplications(),
      CompanyProfileView()
    ];
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        SizedBox(
          height: 70,
        ),
        ListTile(
          title: Text(
            'Company Leaves',
            style: TextStyle(
                color: red, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (ctx) => GetCompanyLeaves()));
          },
        ),
        ListTile(
          title: Text('Create new employee'),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (ctx) => MyForm()));
          },
        ),
        // Add more ListTile widgets for additional drawer items
      ])),
      backgroundColor: backgroundColor,
      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey,
        selectedIconTheme: IconThemeData(color: Colors.red),
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner_outlined),
            label: 'Applications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Approved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.close),
            label: 'Rejected',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class AllApplications extends StatefulWidget {
  final List<LeaveRequest> pendingLeaves;
  const AllApplications({super.key, required this.pendingLeaves});

  @override
  State<AllApplications> createState() => _AllApplicationsState();
}

class _AllApplicationsState extends State<AllApplications> {
  void _changeLeaveStatus(
      String token, int companyId, int status, LeaveRequest leave) async {
    final String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/company-change-leave-request-status';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'company_id': companyId.toString(),
      'leave_request_id': leave.id.toString(),
      'leave_status': status.toString(),
    });

    if (response.statusCode == 200) {
      // Leave request successful
      final jsonData = json.decode(response.body);
      print(jsonData);
      // Handle success scenario
    } else {
      print(response.statusCode);
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
    }
  }

  @override
  Widget build(BuildContext context) {
    final empViewModel = Provider.of<CompanyViewModel>(context);
    final token = empViewModel.token;
    final companyViewModel = Provider.of<CompanyViewModel>(context);
    final user = companyViewModel.user;
    final companyId = user!.id;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Leave Requests",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              //ElevatedButton(onPressed: (){_getallLeaveRequest(token!);}, child: Text("hehe") ),
              ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("search"),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.search)
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ));
                },
              ),
            ],
          ),
        ),
        widget.pendingLeaves.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  itemCount: widget.pendingLeaves.length,
                  itemBuilder: (context, index) {
                    // String fromDate =
                    // DateFormat('EEE, MMM d, yyyy').format(leave.startDate);
                    // String toDate =
                    // DateFormat('EEE, MMM d, yyyy').format(leave.toDate);
                    LeaveRequest leave = widget.pendingLeaves[index];
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${leave.totalRequestLeave} day Application ',
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'From: ${leave.startDate}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            leave.leaveType == 'Compassionate'
                                                ? Colors.red
                                                : Colors.blue),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'To: ${leave.endDate},',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        leave.leaveType,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _changeLeaveStatus(
                                          token!, companyId, 1, leave);
                                      setState(() {
                                        widget.pendingLeaves.removeWhere(
                                            (leavez) => leavez.id == leave.id);
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Approve",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      )),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _changeLeaveStatus(
                                          token!, companyId, 2, leave);
                                      setState(() {
                                        widget.pendingLeaves.removeWhere(
                                            (leavez) => leavez.id == leave.id);
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Reject",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      )),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("No leave requests to show"),
              ),
      ],
    );
  }
}

class CreateApplications extends StatelessWidget {
  const CreateApplications({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page 2'),
    );
  }
}

class ApprovedApplications extends StatefulWidget {
  ApprovedApplications({super.key});

  @override
  State<ApprovedApplications> createState() => _ApprovedApplicationsState();
}

class _ApprovedApplicationsState extends State<ApprovedApplications> {
  List<LeaveRequest> leaves = [];
  List<LeaveRequest> approvedLeaves = [];
  int check = 0;

  Future<void> _getApprovedLeaves(String token) async {
    final String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/company-get-all-requested-leaves';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'company_id': '1',
    });

    if (response.statusCode == 200) {
      // Leave request successful
      final jsonData = json.decode(response.body);
      print(jsonData);
      // Handle success scenario
      List<dynamic> requestedLeaves =
          jsonData["data"]["employee_requested_leaves"];
      setState(() {
        leaves =
            requestedLeaves.map((json) => LeaveRequest.fromJson(json)).toList();
        for (LeaveRequest leave in leaves) {
          if (leave.leaveCurrentStatus == "Accepted") {
            approvedLeaves.add(leave);
          }
        }
      });
      print(leaves);
    } else {
      print(response.statusCode);
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
    }
  }

  @override
  Widget build(BuildContext context) {
    final empViewModel = Provider.of<CompanyViewModel>(context);
    final token = empViewModel.token;
    if (check == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _getApprovedLeaves(token!);
      });
      check = 1;
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Approved Leave",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              //ElevatedButton(onPressed: (){_getallLeaveRequest(token!);}, child: Text("hehe") ),
              ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("search"),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.search)
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ));
                },
              ),
            ],
          ),
        ),
        // Container(
        //   margin: EdgeInsets.symmetric(horizontal: 20.0),
        //   decoration: BoxDecoration(
        //     color: Colors.grey.shade400,
        //     borderRadius: BorderRadius.circular(25.0),
        //   ),
        //   child: TextField(
        //     decoration: InputDecoration(
        //       hintText: 'Search',
        //       border: InputBorder.none,
        //       prefixIcon: Icon(Icons.search),
        //       contentPadding: EdgeInsets.symmetric(vertical: 12.0),
        //     ),
        //   ),
        // ),
        approvedLeaves.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  itemCount: approvedLeaves.length,
                  itemBuilder: (context, index) {
                    // String fromDate =
                    // DateFormat('EEE, MMM d, yyyy').format(leave.startDate);
                    // String toDate =
                    // DateFormat('EEE, MMM d, yyyy').format(leave.toDate);
                    LeaveRequest leave = approvedLeaves[index];
                    return LeaveRequestCard(leave: leave);
                  },
                ),
              )
            : Text("No leaves to show"),
      ],
    );
  }
}

class RejectedApplications extends StatefulWidget {
  const RejectedApplications({super.key});

  @override
  State<RejectedApplications> createState() => _RejectedApplicationsState();
}

class _RejectedApplicationsState extends State<RejectedApplications> {
  List<LeaveRequest> leaves = [];
  List<LeaveRequest> rejectedLeaves = [];
  int check = 0;

  Future<void> _getApprovedLeaves(String token) async {
    final String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/company-get-all-requested-leaves';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'company_id': '1',
    });

    if (response.statusCode == 200) {
      // Leave request successful
      final jsonData = json.decode(response.body);
      print(jsonData);
      // Handle success scenario
      List<dynamic> requestedLeaves =
          jsonData["data"]["employee_requested_leaves"];
      setState(() {
        leaves =
            requestedLeaves.map((json) => LeaveRequest.fromJson(json)).toList();
        for (LeaveRequest leave in leaves) {
          if (leave.leaveCurrentStatus == "Rejected") {
            rejectedLeaves.add(leave);
          }
        }
      });
      print(leaves);
    } else {
      print(response.statusCode);
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
    }
  }

  @override
  Widget build(BuildContext context) {
    final empViewModel = Provider.of<CompanyViewModel>(context);
    final token = empViewModel.token;
    if (check == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _getApprovedLeaves(token!);
      });
      check = 1;
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rejected Leave",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              //ElevatedButton(onPressed: (){_getallLeaveRequest(token!);}, child: Text("hehe") ),
              ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("search"),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.search)
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ));
                },
              ),
              ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("search"),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.search)
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchScreen(),
                    ));
                  }),
            ],
          ),
        ),
        // Container(
        //   margin: EdgeInsets.symmetric(horizontal: 20.0),
        //   decoration: BoxDecoration(
        //     color: Colors.grey.shade400,
        //     borderRadius: BorderRadius.circular(25.0),
        //   ),
        //   child: TextField(
        //     decoration: InputDecoration(
        //       hintText: 'Search',
        //       border: InputBorder.none,
        //       prefixIcon: Icon(Icons.search),
        //       contentPadding: EdgeInsets.symmetric(vertical: 12.0),
        //     ),
        //   ),
        // ),
        rejectedLeaves.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  itemCount: rejectedLeaves.length,
                  itemBuilder: (context, index) {
                    LeaveRequest leave = rejectedLeaves[index];
                    // String fromDate =
                    // DateFormat('EEE, MMM d, yyyy').format(leave.startDate);
                    // String toDate =
                    // DateFormat('EEE, MMM d, yyyy').format(leave.toDate);
                    return LeaveRequestCard(leave: leave);
                  },
                ),
              )
            : Center(
                child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("No leaves to show"),
              )),
      ],
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(10.0),
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
      ),
    );
  }
}
