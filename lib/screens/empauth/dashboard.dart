// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields

import 'dart:convert';
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
import '../../widget/constants.dart';
import '../../widget/leave_req_card.dart';

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
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  Future<void> _getallLeaveRequest(String token, String id) async {
    //final empViewModel = Provider.of<EmpViewModel>(context);
    //final user = empViewModel.user;

    const String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/employee-get-all-requested-leaves';

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
      print('Errorrrrr: ${response.reasonPhrase}');
      // Handle error scenario
    }
  }

  Future<void> _getallapprovedLeaveRequest(String token, String id) async {
    // final empViewModel = Provider.of<EmpViewModel>(context);
    // final user = empViewModel.user;

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
    // final empViewModel = Provider.of<EmpViewModel>(context);
    // final user = empViewModel.user;

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    double fontSize;
    double title;
    double heading;

    // Adjust the font size based on the screen width
    if (screenWidth < 320) {
      fontSize = 13.0;
      title = 22;
      heading = 30; // Small screen (e.g., iPhone 4S)
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
      title = 30;

      heading = 30; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else {
      fontSize = 22.0;
      title = 34;

      heading = 30; // Extra large screen or unknown device
    }
    final empViewModel = Provider.of<EmpViewModel>(context);
    //final user = empViewModel.user;
    final token = empViewModel.token;
    final empId = empViewModel.user!.id;
    final height = MediaQuery.of(context).size.height;

    final width = MediaQuery.of(context).size.width;
    if (check == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _getallLeaveRequest(token!, empId.toString());
        _getallapprovedLeaveRequest(token, empId.toString());
        _getallrejectedLeaveRequest(token, empId.toString());
      });
      check = 1;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: red),
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              CupertinoIcons.left_chevron,
              size: 34,
            )),

        // leading: IconButton(
        //   icon: Icon(
        //     CupertinoIcons.profile_circled,
        //     color: Colors.grey,
        //   ),
        //   onPressed: () {
        //     Navigator.push(
        //         context, MaterialPageRoute(builder: (ctx) => EmpProfileView()));
        //   },
        // ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 30),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Leaves",
                      style: TextStyle(
                          fontSize: title, fontWeight: FontWeight.bold),
                    ),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.of(context).push(MaterialPageRoute(
                    //         builder: (context) => EmpHome(),
                    //       ));
                    //     },
                    //     child: Text("test")),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RequestLeave(),
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: red,
                            borderRadius: BorderRadius.circular(05)),
                        height: screenheight / 20,
                        width: screenWidth / 10,
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
                indicatorColor: Colors.white,
                tabs: [
                  Center(
                    child: Text(
                      "All",
                      style: TextStyle(color: Colors.red, fontSize: fontSize),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Compas..",
                      style: TextStyle(color: Colors.red, fontSize: fontSize),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Liue",
                      style: TextStyle(color: Colors.red, fontSize: fontSize),
                    ),
                  ),
                  // Tab(
                  //   child: SizedBox(
                  //     child: Text(
                  //       "Approved",
                  //       style: TextStyle(fontSize: 14, color: Colors.black),
                  //     ),
                  //   ),
                  // ),
                  // Tab(
                  //   child: SizedBox(
                  //     child: Text(
                  //       "Rejected",
                  //       style: TextStyle(fontSize: 14, color: Colors.black),
                  //     ),
                  //   ),
                  // ),
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
//          _buildLeaveList(approvedLeaves),
          //        _buildLeaveList(rejectedLeaves),
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
              return LeaveRequestCard(
                leave: leave,
              );
            },
          )
        : Center(
            child: Text("No Leaves"),
          );
  }
}
