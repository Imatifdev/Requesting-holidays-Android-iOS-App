import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:holidays/screens/companyauth/search_screen.dart';
import 'package:holidays/widget/leave_req_card.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../models/leave.dart';
import '../../viewmodel/company/compuserviewmodel.dart';
import '../../widget/date_range_picker.dart';

class ApiTest extends StatefulWidget {
  const ApiTest({super.key});

  @override
  State<ApiTest> createState() => _ApiTestState();
}

class _ApiTestState extends State<ApiTest> {
  String? startDate;
  String? endDate;
  List<LeaveRequest> leaveRequests = [];
  String selectedFilter = 'Current Month';

  void _handleDateRangeSelected(String? startDate, String? endDate) {
    setState(() {
      this.startDate = startDate;
      this.endDate = endDate;
    });
  }

  Future<void> _getLeaveRequestByDate(String token) async {
    const String requestLeaveUrl =
        "https://jporter.ezeelogix.com/public/api/company-search-leave-request-by-dates";

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'company_id': '1',
      "start_date": startDate,
      "end_date": endDate
    });

    if (response.statusCode == 400) {
      final jsonData = json.decode(response.body);
      if (jsonData['message'] == 'No leaves found within the given range') {
        setState(() {
          leaveRequests = [];
        });
        print('No leaves found within the given range');
      }
    } else if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("responsessss: $jsonData");
      if (jsonData["status"] == "Error") {
        setState(() {
          leaveRequests = [];
        });
      } else {
        List<dynamic> requestedLeaves = jsonData['data']['requested_leaves'];
        setState(() {
          leaveRequests = requestedLeaves
              .map((json) => LeaveRequest.fromJson(json))
              .toList();
        });
        print(leaveRequests);
        // Handle success scenario
      }
    } else {
      print(response.statusCode);
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
    }
  }

  Future<void> _getLeaveRequestByFilter(String token, String filter) async {
    const String requestLeaveUrl =
        "https://jporter.ezeelogix.com/public/api/company-search-leave-request-by-filter";

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'company_id': '1',
      "filter_type": filter.toLowerCase()
    });

    if (response.statusCode == 400) {
      final jsonData = json.decode(response.body);
      if (jsonData['message'] == 'No leaves found within the given range') {
        setState(() {
          leaveRequests = [];
        });
        print('No leaves found within the given range');
      }
    } else if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("responsessss: $jsonData");
      if (jsonData["status"] == "Error") {
        setState(() {
          leaveRequests = [];
        });
      } else {
        List<dynamic> requestedLeaves = jsonData['data']['requested_leaves'];
        setState(() {
          leaveRequests = requestedLeaves
              .map((json) => LeaveRequest.fromJson(json))
              .toList();
        });
        print(leaveRequests);
        // Handle success scenario
      }
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ));
                },
                child: const Text("search screen")),
            ElevatedButton(
                onPressed: () {
                  _getLeaveRequestByFilter(token!, selectedFilter);
                },
                child: const Text("Search api")),
            DateRangePickerWidget(
              onDateRangeSelected: _handleDateRangeSelected,
            ),
            Text(
              'Selected Filter: $selectedFilter',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedFilter,
              hint: const Text('Select Filter'),
              items: <String>[
                'Current Month',
                'Tomorrow',
                'Current Week',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedFilter = newValue ?? '';
                });
              },
            ),
            leaveRequests.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                    itemCount: leaveRequests.length,
                    itemBuilder: (context, index) {
                      LeaveRequest leave = leaveRequests[index];
                      //  return LeaveRequestCard(leave: leave);
                    },
                  ))
                : const Text("No leave requests in the given range")
          ],
        ),
      )),
    );
  }
}
