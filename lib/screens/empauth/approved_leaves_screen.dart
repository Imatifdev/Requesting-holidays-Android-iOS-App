import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/leave.dart';
import '../../viewmodel/employee/empuserviewmodel.dart';
import '../../widget/leave_req_card.dart';

class ApprovedLeavesScreen extends StatefulWidget {
  const ApprovedLeavesScreen({super.key});

  @override
  State<ApprovedLeavesScreen> createState() => _ApprovedLeavesScreenState();
}

class _ApprovedLeavesScreenState extends State<ApprovedLeavesScreen> {
  List<LeaveRequest> leaveRequests = [];
  int check = 0;
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

  @override
  Widget build(BuildContext context) {
    final empViewModel = Provider.of<EmpViewModel>(context);
    //final user = empViewModel.user;
    final token = empViewModel.token;
    final empId = empViewModel.user!.id;
    if (check == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _getallapprovedLeaveRequest(token!, empId.toString());
        // _getallapprovedLeaveRequest(token, empId.toString());
        // _getallrejectedLeaveRequest(token, empId.toString());
      });
      check = 1;
    }
    return Scaffold(
      appBar: AppBar(title: const Text("All Approved Leaves")),
      body: leaveRequests.isNotEmpty
          ? ListView.builder(
              itemCount: leaveRequests.length,
              itemBuilder: (context, index) {
                final leave = leaveRequests[index];
                return LeaveRequestCard(
                  leave: leave,
                );
              },
            )
          : Center(
              child: Text("No Holday Entitlements"),
            ),
    );
  }
}
