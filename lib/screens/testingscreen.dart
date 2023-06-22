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
      print(jsonData);
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
              onPressed: () => _submitLeaveRequest(token!),
              child: Text('Submit'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _getallLeaveRequest(token!),
              child: Text('Submit'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LeaveRequestListScreen()),
                );
              },
              child: Text('View Leave Requests'),
            ),
          ],
        ),
      ),
    );
  }
}

class LeaveRequestListScreen extends StatefulWidget {
  @override
  _LeaveRequestListScreenState createState() => _LeaveRequestListScreenState();
}

class _LeaveRequestListScreenState extends State<LeaveRequestListScreen> {
  List<dynamic> _requestedLeaves = [];

  Future<void> _fetchRequestedLeaves() async {
    final String apiUrl =
        'https://jporter.ezeelogix.com/public/api/get-requested-leaves';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['status'] == 'Success') {
        setState(() {
          _requestedLeaves = jsonData['data']['requested_leaves'];
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
    _fetchRequestedLeaves();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Requests'),
      ),
      body: ListView.builder(
        itemCount: _requestedLeaves.length,
        itemBuilder: (context, index) {
          final requestedLeave = _requestedLeaves[index];
          return ListTile(
            title: Text(requestedLeave['leave_type']),
            subtitle: Text('Start Date: ${requestedLeave['start_date']}'),
          );
        },
      ),
    );
  }
}
