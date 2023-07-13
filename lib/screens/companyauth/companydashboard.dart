// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_declarations, unused_element, must_be_immutable

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:holidays/screens/companyauth/createnewemployee.dart';
import 'package:holidays/screens/companyauth/profile.dart';
import 'package:holidays/screens/companyauth/search_screen.dart';
import 'package:holidays/screens/companyauth/showemployes.dart';
import 'package:holidays/viewmodel/company/compuserviewmodel.dart';
import 'package:holidays/widget/leave_req_card.dart';
import 'package:provider/provider.dart';
import '../../models/company/viewemployeedata.dart';
import '../../models/company_leave.dart';
import '../../models/leave.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:http/http.dart' as http;

import 'companylogo.dart';
import 'createcompanyleaves.dart';
import 'createfinancialyear.dart';
import 'getcompanyleaves.dart';

class CompanyDashBoard extends StatefulWidget {
  const CompanyDashBoard({super.key});

  @override
  _CompanyDashBoardState createState() => _CompanyDashBoardState();
}

class _CompanyDashBoardState extends State<CompanyDashBoard> {
  List<CompanyLeaveRequest> leaves = [];
  List<CompanyLeaveRequest> pendingLeaves = [];
  List<CompanyLeaveRequest> approvedLeaves = [];
  List<CompanyLeaveRequest> rejectedLeaves = [];
  int check = 0;
  int _currentIndex = 0;
  final String imgurl = "https://jporter.ezeelogix.com/public/upload/logo/";

  Future<void> _getallLeaveRequest(String token, String id) async {
    final String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/company-get-all-requested-leaves';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'company_id': id,
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
            requestedLeaves.map((json) => CompanyLeaveRequest.fromJson(json)).toList();
        for (CompanyLeaveRequest leave in leaves) {
          if (leave.leaveCurrentStatus == "Pending") {
            pendingLeaves.add(leave);
          }
        }
        for (CompanyLeaveRequest leave in leaves) {
          if (leave.leaveCurrentStatus == "Accepted") {
            approvedLeaves.add(leave);
          }
        }
        for (CompanyLeaveRequest leave in leaves) {
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
    final user = empViewModel.user;
    final logoUrl = empViewModel.logoUrl;
    print('${logoUrl}${user!.logo}'); // Get the logo URL

    if (check == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _getallLeaveRequest(token!, user!.id.toString());
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
      appBar: AppBar(
        title: Text("Leave Requests"),
      ),
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.red.shade900, Colors.red.shade500],
            ),
          ),
          height: 275,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
              ),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('${logoUrl}${user!.logo}'),
              ).pOnly(left: 20, bottom: 20),
              Text(
                '${user!.firstName} ' + ' ${user.lastName}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              )
            ],
          ).pOnly(left: 20),
        ),
        SizedBox(
          height: 30,
        ),
        ListTile(
          leading: Icon(Icons.person_2),
          title: Text(
            'Profile',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(CupertinoIcons.right_chevron),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (ctx) => CompanyProfileView()));
          },
        ),
        Divider(
          color: Colors.grey,
          thickness: 0.5,
        ).pSymmetric(h: 20),
        ListTile(
          leading: Icon(Icons.home),
          title: Text(
            'Home',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(CupertinoIcons.right_chevron),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        Divider(
          color: Colors.grey,
          thickness: 0.5,
        ).pSymmetric(h: 20),
        ListTile(
          leading: Icon(Icons.home),
          title: Text(
            'Create a financial Year',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(CupertinoIcons.right_chevron),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => CompanyFinancialYearScreen()));
          },
        ),
        Divider(
          color: Colors.grey,
          thickness: 0.5,
        ).pSymmetric(h: 20),
        ListTile(
          leading: Icon(Icons.create),
          title: Text(
            'Create New Employee',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(CupertinoIcons.right_chevron),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (ctx) => MyForm()));
          },
        ),
        Divider(
          color: Colors.grey,
          thickness: 0.5,
        ).pSymmetric(h: 20),
        ListTile(
          leading: Icon(CupertinoIcons.person_3_fill),
          title: Text(
            'View All Employee',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(CupertinoIcons.right_chevron),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (ctx) => ShowEmployee()));
          },
        ),
        Divider(
          color: Colors.grey,
          thickness: 0.5,
        ).pSymmetric(h: 20),
        ListTile(
          leading: Icon(Icons.search_off),
          title: Text(
            'View Company Leaves',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(CupertinoIcons.right_chevron),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (ctx) => GetCompanyLeaves()));
          },
        ),
        Divider(
          color: Colors.grey,
          thickness: 0.5,
        ).pSymmetric(h: 20),
        ListTile(
          leading: Icon(CupertinoIcons.person_3_fill),
          title: Text(
            'Change Company Logo',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(CupertinoIcons.right_chevron),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (ctx) => CompanyLogo()));
          },
        ),
        Divider(
          color: Colors.grey,
          thickness: 0.5,
        ).pSymmetric(h: 20),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text(
            'Logout',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (ctx) => CompanyLogo()));
          },
        ),
      ])),
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
        ],
      ),
    );
  }
}

class AllApplications extends StatefulWidget {
  final List<CompanyLeaveRequest> pendingLeaves;
  const AllApplications({super.key, required this.pendingLeaves});

  @override
  State<AllApplications> createState() => _AllApplicationsState();
}

class _AllApplicationsState extends State<AllApplications> {
  void _changeLeaveStatus(
      String token, int companyId, int status, CompanyLeaveRequest leave) async {
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
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => SearchScreen(),
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width - 20,
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade400),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Search",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Icon(Icons.search)
              ],
            ).centered().pSymmetric(h: 20),
          ).centered().p(10),
        ),
        widget.pendingLeaves.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  itemCount: widget.pendingLeaves.length,
                  //reverse: true,
                  itemBuilder: (context, index) {
                    // String fromDate =
                    // DateFormat('EEE, MMM d, yyyy').format(leave.startDate);
                    // String toDate =
                    // DateFormat('EEE, MMM d, yyyy').format(leave.toDate);
                    CompanyLeaveRequest leave = widget.pendingLeaves[index];
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
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Text(leave.employee.firstName),
                                  Text(
                                    'From: ${leave.startDate}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            leave.leaveType == 'Compassionate'
                                                ? Colors.red
                                                : Colors.blue),
                                  ),
                                  const SizedBox(
                                    height: 05,
                                  ),
                                  Text(
                                    'To: ${leave.endDate},',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            leave.leaveType == 'Compassionate'
                                                ? Colors.red
                                                : Colors.blue,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        leave.leaveType,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
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
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 300,
                  ),
                  Center(
                      child: Text(
                    "No leaves to show",
                    style: TextStyle(color: Colors.black),
                  )),
                ],
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
  List<Employee> empstatus = [];
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
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => SearchScreen(),
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width - 20,
            height: 41,
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade400),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Search",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Icon(Icons.search)
              ],
            ).centered().pSymmetric(h: 20),
          ).centered().p(10),
        ),
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
                    return LeaveRequestCard(
                      leave: leave,
                    );
                  },
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 300,
                  ),
                  Center(child: CircularProgressIndicator()),
                ],
              ),
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

  Future<void> _getApprovedLeaves(String token, String id) async {
    final String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/company-get-all-requested-leaves';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'company_id': id,
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
    final user = empViewModel.user;
    if (check == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _getApprovedLeaves(token!, user!.id.toString());
      });
      check = 1;
    }
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => SearchScreen(),
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width - 20,
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade400),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Search",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Icon(Icons.search)
              ],
            ).centered().pSymmetric(h: 20),
          ).centered().p(10),
        ),
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
                    return LeaveRequestCard(
                      leave: leave,
                    );
                  },
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 300,
                  ),
                  Center(child: CircularProgressIndicator()),
                ],
              ),
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
