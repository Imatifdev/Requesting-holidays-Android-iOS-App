// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../viewmodel/employee/empuserviewmodel.dart';
import '../../widget/constants.dart';
import 'dashboard.dart';
import 'package:velocity_x/velocity_x.dart';

class RequestLeave extends StatefulWidget {
  const RequestLeave({super.key});

  @override
  State<RequestLeave> createState() => _RequestLeaveState();
}

class _RequestLeaveState extends State<RequestLeave> {
  final _formKey = GlobalKey<FormState>();
  var startDateFormatted = "Select from date";
  var endDateFormatted = "Select to date";
  String errMsg = "";
  DateTime _firstDate = DateTime(2022, 11, 22);
  DateTime _lastDate = DateTime(2023, 11, 23);
  String? selectedLeaveType;
  TextEditingController causeController = TextEditingController();
  final DateTimeRange _selectedDateRange = DateTimeRange(
      start: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      end: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 1));
  int totalLeaveCount = 0;

  void _selectDateRange(BuildContext context) async {
    final dateRange = await showDateRangePicker(
      context: context,
      firstDate: _firstDate,
      lastDate: _lastDate,
      initialDateRange: _selectedDateRange,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.red,
            ),
          ),
          child: child!,
        );
      },
    );
    if (dateRange != null) {
      setState(() {
        startDateFormatted = DateFormat('d-MMM-yyyy').format(dateRange.start);
        print(startDateFormatted);
        _firstDate = dateRange.start;
        endDateFormatted = DateFormat('d-MMM-yyyy').format(dateRange.end);
        print(endDateFormatted);
        _lastDate = dateRange.end;
        var diff = dateRange.end.difference(dateRange.end);
        totalLeaveCount = diff.inDays;
      });
    }
  }

  Future<void> _submitLeaveRequest(
      String token,
      String leaveType,
      String startDate,
      String endDate,
      String id,
      String totalLeaveCount,
      String comment) async {
    const String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/employee-request-leave';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'employee_id': id,
      'leave_type': leaveType,
      'start_date': startDate,
      'end_date': endDate,
      'total_leave_count': totalLeaveCount,
      'comment': comment,
      // id: 20,
      // employee_id: 1,
      // leave_type: Compassionate,
      // start_date: 29-06-2023,
      // end_date: 29-06-2023,
      // total_request_leave: 1,
      // comment: thired,
      // status: 0,
      // created_at: 2023-06-23T12:08:41.000000Z,
      // updated_at: 2023-06-23T12:08:41.000000Z,
      // leave_current_status: Pending
    });
    if (response.statusCode == 200) {
      print("responseee: ${response.body}");
      Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => LeaveScreen()));
      // Handle success scenario
    } else {
      print(response.body);
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
    }
  }

  @override
  Widget build(BuildContext context) {
    final empViewModel = Provider.of<EmpViewModel>(context);
    final token = empViewModel.token;
    final user = empViewModel.user;

    return Scaffold(
      backgroundColor: appbar,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appbar,
        leading: IconButton(
            onPressed: () {Navigator.of(context).pop();},
            icon: const Icon(
              CupertinoIcons.left_chevron,
              color: Colors.black,
            )),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("New Leave",
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold))),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedLeaveType,
                        hint: const Text(
                          'Type',
                          style: TextStyle(color: Colors.red),
                        ),
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'Compassionate',
                            child: Text('Compassionate'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Lieu',
                            child: Text('Lieu'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedLeaveType = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text(
                            "Start:",
                            style: TextStyle(fontSize: 17, color: Colors.red),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDateRange(context),
                              child: Container(
                                height: 30,
                                color: Colors.grey.shade200,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 4),
                                  child: Text(
                                    startDateFormatted,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text(
                            "To:    ",
                            style: TextStyle(fontSize: 17, color: Colors.red),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDateRange(context),
                              child: Container(
                                height: 30,
                                color: Colors.grey.shade200,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 4),
                                  child: Text(
                                    endDateFormatted,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Cause:",
                            style: TextStyle(fontSize: 17, color: Colors.red),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your cause for leave';
                                }
                                return null;
                              },
                              controller: causeController,
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade200,
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                hintText: 'Enter Cause',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Center(
                      //   child: ElevatedButton(
                      //     style:
                      //         ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      //     onPressed: () => _selectDateRange(context),
                      //     child: const Text('Select Date'),
                      //   ),
                      // ),
                      Text(errMsg, style: const TextStyle(color: Colors.red)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  _firstDate != DateTime(2022, 11, 22) &&
                                  _lastDate != DateTime(2022, 11, 23)) {
                                await _submitLeaveRequest(
                                  token!,
                                  selectedLeaveType!,
                                  startDateFormatted,
                                  endDateFormatted,
                                  user!.id.toString(),
                                  totalLeaveCount.toString(),
                                  causeController.text.trim(),
                                );
                              } else {
                                setState(() {
                                  errMsg = "please select a valid date";
                                });
                              }
                            },
                            child: const Text("Apply")),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ).p(20),
        ),
      ),
    );
  }
}
