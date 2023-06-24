import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LeaveRequest {
  final int id;
  final int employeeId;
  final String leaveType;
  final String startDate;
  final String endDate;
  final int totalRequestLeave;
  final String comment;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String leaveCurrentStatus;

  LeaveRequest({
    required this.id,
    required this.employeeId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.totalRequestLeave,
    required this.comment,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.leaveCurrentStatus,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'],
      employeeId: json['employee_id'],
      leaveType: json['leave_type'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      totalRequestLeave: json['total_request_leave'],
      comment: json['comment'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      leaveCurrentStatus: json['leave_current_status'],
    );
  }
}

class LeaveRequestsScreen1 extends StatefulWidget {
  @override
  _LeaveRequestsScreen1State createState() => _LeaveRequestsScreen1State();
}

class _LeaveRequestsScreen1State extends State<LeaveRequestsScreen1> {
  List<LeaveRequest> _leaveRequests = [];

  Future<void> _fetchLeaveRequests() async {
    final String apiUrl =
        'https://jporter.ezeelogix.com/public/api/employee-get-all-requested-leaves';

    final response = await http.post(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['status'] == 'Success') {
        final List<dynamic> leaveRequestsJson =
            jsonData['data']['requested_leaves'];
        final List<LeaveRequest> leaveRequests = leaveRequestsJson
            .map((leaveJson) => LeaveRequest.fromJson(leaveJson))
            .toList();

        setState(() {
          _leaveRequests = leaveRequests;
        });
      } else {
        // Error occurred
        print('Error: ${jsonData['message']}');
      }
    } else {
      // Error occurred
      print('Error: ${response.reasonPhrase}');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLeaveRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Requests 1'),
      ),
      body: ListView.builder(
        itemCount: _leaveRequests.length,
        itemBuilder: (context, index) {
          final leaveRequest = _leaveRequests[index];

          return ListTile(
            title: Text('Leave Type: ${leaveRequest.leaveType}'),
            subtitle: Text('Start Date: ${leaveRequest.startDate}'),
          );
        },
      ),
    );
  }
}
