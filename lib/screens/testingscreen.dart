import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

import '../viewmodel/employee/empuserviewmodel.dart';

class RequestLeaveScreen extends StatefulWidget {
  @override
  _RequestLeaveScreenState createState() => _RequestLeaveScreenState();
}

class _RequestLeaveScreenState extends State<RequestLeaveScreen> {
  String _startDate = '';
  String _endDate = '';
  String _leaveType = '';
  String _totalLeaveCount = '';
  String _comment = '';
  Future<void> _submitLeaveRequest(String token) async {
    final String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/employee-request-leave';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'employee_id': '1',
      'leave_type': _leaveType,
      'start_date': _startDate,
      'end_date': _endDate,
      'total_leave_count': _totalLeaveCount,
      'comment': _comment,
    });
    if (response.statusCode == 200) {
      // Leave request successful
      final jsonData = json.decode(response.body);
      final leaveRequest = LeaveRequest.fromJson(jsonData);
      print(leaveRequest); // Print the leave request data
      // Handle success scenario
    } else {
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
    }
  }

  Future<void> _getallLeaveRequest(String token) async {
    final String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/employee-get-all-requested-leaves';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'employee_id': '1',
    });

    if (response.statusCode == 200) {
      // Leave request successful
      final jsonData = json.decode(response.body);
      print(jsonData);
      // Handle success scenario
    } else {
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
    }
  }

  Future<void> _getallpendingLeaveRequest(String token) async {
    final String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/employee-get-all-pending-leaves';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'employee_id': '1',
    });

    if (response.statusCode == 200) {
      // Leave request successful
      final jsonData = json.decode(response.body);
      print(jsonData);
      // Handle success scenario
    } else {
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
    }
  }

  Future<void> _getallapprovedLeaveRequest(String token) async {
    final String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/employee-get-all-approved-leaves';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'employee_id': '1',
    });

    if (response.statusCode == 200) {
      // Leave request successful
      final jsonData = json.decode(response.body);
      print(jsonData);
      // Handle success scenario
    } else {
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
    }
  }

  Future<void> _getallrejectedLeaveRequest(String token) async {
    final String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/employee-get-all-rejected-leaves';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'employee_id': '1',
    });

    if (response.statusCode == 200) {
      // Leave request successful
      final jsonData = json.decode(response.body);
      print(jsonData);
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
    final token = empViewModel.token;

    return Scaffold(
      appBar: AppBar(
        title: Text('Request Leave'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Start Date'),
              onChanged: (value) {
                setState(() {
                  _startDate = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'End Date'),
              onChanged: (value) {
                setState(() {
                  _endDate = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Leave Type'),
              onChanged: (value) {
                setState(() {
                  _leaveType = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Total Leave Count'),
              onChanged: (value) {
                setState(() {
                  _totalLeaveCount = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Comment'),
              onChanged: (value) {
                setState(() {
                  _comment = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                print("object,s,");
                _submitLeaveRequest(token!);
                print("object");
              },
              child: Text('leave request'),
            ),
            ElevatedButton(
              onPressed: () => _getallapprovedLeaveRequest(token!),
              child: Text('Approved'),
            ),
            ElevatedButton(
              onPressed: () => _getallpendingLeaveRequest(token!),
              child: Text('Pending'),
            ),
            ElevatedButton(
              onPressed: () => _getallrejectedLeaveRequest(token!),
              child: Text('rejected'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _getallLeaveRequest(token!),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class LeaveRequest {
  final int id;
  final String leaveType;
  final String startDate;
  final String endDate;
  final int totalLeaveCount;
  final String comment;

  LeaveRequest({
    required this.id,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.totalLeaveCount,
    required this.comment,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'],
      leaveType: json['leave_type'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      totalLeaveCount: json['total_leave_count'],
      comment: json['comment'],
    );
  }
}

class YourWidget extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  String _displayedLeaveType = '';
  String _displayedStartDate = '';
  String _displayedEndDate = '';

  // Rest of your widget code and the _submitLeaveRequest function

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Leave Type: $_displayedLeaveType'),
        Text('Start Date: $_displayedStartDate'),
        Text('End Date: $_displayedEndDate'),
        // Display other leave request data as needed
      ],
    );
  }
}
