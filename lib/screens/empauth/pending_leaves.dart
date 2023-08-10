import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:holidays/screens/companyauth/companydashboard.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/leave.dart';
import '../../viewmodel/employee/empuserviewmodel.dart';
import '../../widget/constants.dart';
import '../../widget/leave_req_card.dart';

class PendingLeavesScreen extends StatefulWidget {
  const PendingLeavesScreen({super.key});

  @override
  State<PendingLeavesScreen> createState() => _PendingLeavesScreenState();
}

class _PendingLeavesScreenState extends State<PendingLeavesScreen> {
  List<LeaveRequest> leaveRequests = [];
  List<LeaveRequest> leavesRejected = [];
  int check = 0;
  StateEnum state = StateEnum.notFetched;
  
  Future<void> _getallLeaveRequest(String token, String id) async {
    //final empViewModel = Provider.of<EmpViewModel>(context);
    //final user = empViewModel.user;
    setState(() {
      state = StateEnum.fetching;
    });
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
          if (request.leaveCurrentStatus == "Pending") {
            leavesRejected.add(request);
          }
        }
        state = StateEnum.fetched;
      });
      // Handle success scenario
    } else {
      // Error occurred
      print('Errorrrrr: ${response.reasonPhrase}');
      setState(() {
        state = StateEnum.fetched;
      });
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
        _getallLeaveRequest(token!, empId.toString());
        // _getallapprovedLeaveRequest(token, empId.toString());
        // _getallrejectedLeaveRequest(token, empId.toString());
      });
      check = 1;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("All Pending Leaves")),
      body: 
      state == StateEnum.fetched?
      leavesRejected.isNotEmpty
          ? ListView.builder(
              itemCount: leavesRejected.length,
              itemBuilder: (context, index) {
                final leave = leavesRejected[index];
                return LeaveRequestCard(
                  leave: leave,
                );
              },
            )
          : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 200,
                        ),
                        Center(
                            child: Column(
                          children: [
                            Icon(
                              CupertinoIcons.check_mark_circled,
                              size: 50,
                              color: red,
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "You currently have no pending leave requests ",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        )),
                      ],
                    ) : const Center(child: CircularProgressIndicator(),) 
    );
  }
}
