import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/leave.dart';
import '../../viewmodel/employee/empuserviewmodel.dart';
import '../../widget/leave_req_card.dart';

class RejectedLeavesScreen extends StatefulWidget {
  const RejectedLeavesScreen({super.key});

  @override
  State<RejectedLeavesScreen> createState() => _RejectedLeavesScreenState();
}

class _RejectedLeavesScreenState extends State<RejectedLeavesScreen> {
  List<LeaveRequest> leaveRequests = [];
  int check = 0;
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
        leaveRequests =
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
    //final user = empViewModel.user;
    final token = empViewModel.token;
    final empId = empViewModel.user!.id;
    if (check == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _getallrejectedLeaveRequest(token!, empId.toString());
        // _getallapprovedLeaveRequest(token, empId.toString());
        // _getallrejectedLeaveRequest(token, empId.toString());
      });
      check = 1;
    }
    return Scaffold(
      appBar: AppBar(title: const Text("All Rejected Leaves")),
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
          : const Center(
              child: Text("No Leaves"),
            ),
    );
  }
}
