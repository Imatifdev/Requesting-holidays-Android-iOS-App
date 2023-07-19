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
  var startDateFormatted = "";
  var endDateFormatted = "";
  String errMsg = "";
  String errMsg2 = "";
  bool isLoading = false;
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
        startDateFormatted = DateFormat('dd-MM-yyyy').format(dateRange.start);
        print(startDateFormatted);
        _firstDate = dateRange.start;
        endDateFormatted = DateFormat('dd-MM-yyyy').format(dateRange.end);
        print(endDateFormatted);
        _lastDate = dateRange.end;
        var diff = dateRange.end.difference(dateRange.start);
        totalLeaveCount = diff.inDays + 1;
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
    setState(() {
      isLoading = true;
      errMsg = "";
      errMsg2 = "";
    });
    const String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/employee-request-leave';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'employee_id': id,
      'leave_type': leaveType,
      'start_date': startDateFormatted,
      'end_date': endDateFormatted,
      'total_leave_count': totalLeaveCount,
      'comment': comment,
    });
    if (response.statusCode == 200) {
      print("responseee: ${response.body}");
      setState(() {
        isLoading = false;
      });
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LeaveScreen()));
      // Handle success scenario
    } else {
      setState(() {
        isLoading = false;
      });
      print(response.body);
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
      title = 12;
      heading = 30; // Small screen (e.g., iPhone 4S)
    } else if (screenWidth < 375) {
      fontSize = 15.0;
      title = 14;

      heading = 24; // Medium screen (e.g., iPhone 6, 7, 8)
    } else if (screenWidth < 414) {
      fontSize = 17.0;
      title = 16;

      heading = 28; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else if (screenWidth < 600) {
      fontSize = 19.0;
      title = 18;

      heading = 30; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else {
      fontSize = 22.0;
      title = 20;

      heading = 30; // Extra large screen or unknown device
    }
    final empViewModel = Provider.of<EmpViewModel>(context);
    final token = empViewModel.token;
    final user = empViewModel.user;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: appbar,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: appbar,
      //   leading: IconButton(
      //       onPressed: () {
      //         Navigator.of(context).pop();
      //       },
      //       icon: const Icon(
      //         CupertinoIcons.left_chevron,
      //         color: Colors.black,
      //       )),
      // ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("New Leave",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold))),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all()),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20)),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.window,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: screenWidth - 123,
                                child: Expanded(
                                  child: DropdownButtonFormField<String>(
                                    focusColor: Colors.grey.shade100,
                                    dropdownColor: Colors.grey.shade100,
                                    value: selectedLeaveType,
                                    hint: Text(
                                      'Type',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: title),
                                    ),
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: 'Compassionate',
                                        child: Text(
                                          'Compassionate',
                                          style: TextStyle(fontSize: title),
                                        ),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'Lieu',
                                        child: Text(
                                          'Lieu',
                                          style: TextStyle(fontSize: title),
                                        ),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'Full Day',
                                        child: Text(
                                          'Full Day',
                                          style: TextStyle(fontSize: title),
                                        ),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'Half Day',
                                        child: Text(
                                          'Half Day',
                                          style: TextStyle(fontSize: title),
                                        ),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        selectedLeaveType = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(errMsg2,
                              style: const TextStyle(
                                color: Colors.red,
                              )),
                          const SizedBox(height: 26),
                          Divider(
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20)),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.calendar_month_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    if (endDateFormatted == "") {
                                      _selectDateRange(context);
                                    }
                                  },
                                  child: Container(
                                    height: screenheight / 14,
                                    width: screenWidth,
                                    color: Colors.grey.shade100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Text(
                                        //   endDateFormatted == ""
                                        //       ? "Calender"
                                        //       : "Selected Dates:",
                                        //   style: TextStyle(
                                        //       color: Colors.red,
                                        //       fontSize: title),
                                        // ),
                                        Text(
                                          endDateFormatted == ""
                                              ? "Select Leaves"
                                              : "$startDateFormatted to $endDateFormatted",
                                          style: TextStyle(
                                            fontSize: title,
                                          ),
                                        ),
                                      ],
                                    ).pSymmetric(v: 16, h: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(errMsg,
                              style: const TextStyle(color: Colors.red)),
                          const SizedBox(height: 30),
                          Divider(
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20)),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.edit_note_rounded,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                height: screenheight / 14,
                                width: screenWidth - 123,
                                child: Expanded(
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your cause for leave';
                                      }
                                      return null;
                                    },
                                    controller: causeController,
                                    decoration: InputDecoration(
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      label: Text(
                                        "Cause",
                                        style: TextStyle(fontSize: title),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                      hintText: 'Provide Cause of Leave',
                                    ),
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
                          InkWell(
                            onTap: () async {
                              if (_formKey.currentState!.validate() &&
                                  _firstDate != DateTime(2022, 11, 22) &&
                                  _lastDate != DateTime(2022, 11, 23) &&
                                  selectedLeaveType != null) {
                                // print(startDateFormatted);
                                //print(totalLeaveCount);
                                setState(() {
                                  errMsg = "";
                                  errMsg2 = "";
                                });
                                await _submitLeaveRequest(
                                  token!,
                                  selectedLeaveType!,
                                  startDateFormatted,
                                  endDateFormatted,
                                  user!.id.toString(),
                                  totalLeaveCount.toString(),
                                  causeController.text.trim(),
                                );
                              } else if (selectedLeaveType == null) {
                                setState(() {
                                  errMsg2 = "Please select a type";
                                });
                              } else {
                                setState(() {
                                  errMsg = "please select leave dates";
                                });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: red,
                                  borderRadius: BorderRadius.circular(10)),
                              height: screenheight / 15,
                              width: screenWidth - 100,
                              child: Center(
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Text(
                                          "Apply",
                                          style: TextStyle(
                                              fontSize: fontSize,
                                              color: Colors.white),
                                        )),
                            ),
                          ),

                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width - 50,
                          //   height: 50,
                          //   child: ElevatedButton(
                          //       style: ElevatedButton.styleFrom(
                          //         shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(10)),
                          //       ),
                          //       onPressed: () async {
                          //         if (_formKey.currentState!.validate() &&
                          //             _firstDate != DateTime(2022, 11, 22) &&
                          //             _lastDate != DateTime(2022, 11, 23) &&
                          //             selectedLeaveType != null) {
                          //           // print(startDateFormatted);
                          //           //print(totalLeaveCount);
                          //           setState(() {
                          //             errMsg = "";
                          //             errMsg2 = "";
                          //           });
                          //           await _submitLeaveRequest(
                          //             token!,
                          //             selectedLeaveType!,
                          //             startDateFormatted,
                          //             endDateFormatted,
                          //             user!.id.toString(),
                          //             totalLeaveCount.toString(),
                          //             causeController.text.trim(),
                          //           );
                          //         } else if (selectedLeaveType == null) {
                          //           setState(() {
                          //             errMsg2 = "Please select a type";
                          //           });
                          //         } else {
                          //           setState(() {
                          //             errMsg = "please select leave dates";
                          //           });
                          //         }
                          //       },
                          //       child: isLoading
                          //           ? const CircularProgressIndicator(
                          //               color: Colors.white,
                          //             )
                          //           : const Text("Apply")),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ).p(20),
          ),
        ),
      ),
    );
  }
}
