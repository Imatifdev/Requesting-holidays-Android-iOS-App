// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/leave.dart';
import '../viewmodel/employee/empuserviewmodel.dart';
import 'constants.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class LeaveRequestCard extends StatelessWidget {
  final LeaveRequest leave;
  const LeaveRequestCard({
    super.key,
    required this.leave,
  });

  void popUp(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    double fontSize;
    double title;
    double heading;
    if (screenWidth < 320) {
      fontSize = 13.0;
      title = 13;
      heading = 30; // Small screen (e.g., iPhone 4S)
    } else if (screenWidth < 375) {
      fontSize = 15.0;
      title = 16;

      heading = 24; // Medium screen (e.g., iPhone 6, 7, 8)
    } else if (screenWidth < 414) {
      fontSize = 17.0;
      title = 18;

      heading = 28; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else if (screenWidth < 600) {
      fontSize = 19.0;
      title = 20;

      heading = 30; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else {
      fontSize = 22.0;
      title = 20;

      heading = 30; // Extra large screen or unknown device
    }
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: SizedBox(
                height: screenheight / 3,
                width: screenWidth - 50,
                child: Column(
                  children: [
                    Text(
                      'Leave Request Details',
                      style: TextStyle(
                          color: red,
                          fontSize: title,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Leave Type:",
                          style: TextStyle(
                              fontSize: fontSize, fontWeight: FontWeight.bold),
                        ),
                        Text(leave.leaveType),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Leave Status:",
                          style: TextStyle(
                              fontSize: fontSize, fontWeight: FontWeight.bold),
                        ),
                        Text(leave.leaveCurrentStatus),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "From:",
                          style: TextStyle(
                              fontSize: fontSize, fontWeight: FontWeight.bold),
                        ),
                        Text(leave.startDate.toString(),
                            style: TextStyle(fontSize: fontSize)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "To:",
                          style: TextStyle(
                              fontSize: fontSize, fontWeight: FontWeight.bold),
                        ),
                        Text(leave.endDate.toString(),
                            style: TextStyle(fontSize: fontSize)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Leave Days:",
                          style: TextStyle(
                              fontSize: fontSize, fontWeight: FontWeight.bold),
                        ),
                        Text(leave.totalRequestLeave.toString(),
                            style: TextStyle(fontSize: fontSize)),
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Comment",
                          style: TextStyle(
                              fontSize: fontSize, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: screenWidth - 20,
                      child: Text(
                        leave.comment,
                        softWrap: true,
                        style: TextStyle(fontSize: fontSize),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  Future<void> deleterequestLeave(String leaveid, String token) async {
    final String apiUrl =
        "https://jporter.ezeelogix.com/public/api/employee-delete-requested-leave";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: {
        'job_id': leaveid, // Change to your desired parameter values
      },
    );

    if (response.statusCode == 200) {
      // Successful API call, handle the response here
      print('API Response: ${response.body}');
    } else {
      // Handle API error
      print('API Error: ${response.statusCode}');
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

      title = 13;
      heading = 10; // Small screen (e.g., iPhone 4S)
    } else if (screenWidth < 375) {
      fontSize = 15.0;
      title = 14;

      heading = 11; // Medium screen (e.g., iPhone 6, 7, 8)
    } else if (screenWidth < 414) {
      fontSize = 17.0;
      title = 16;

      heading = 12; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else if (screenWidth < 600) {
      fontSize = 19.0;
      title = 17;

      heading = 13; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else {
      fontSize = 22.0;
      title = 19;

      heading = 15; // Extra large screen or unknown device
    }
    final empViewModel = Provider.of<EmpViewModel>(context);
    final token = empViewModel.token;
    final user = empViewModel.user;

    return Padding(
      padding: EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          popUp(context);
        },
        child: Column(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            //${leave.totalRequestLeave}
                            leave.totalRequestLeave > 1
                                ? '${leave.totalRequestLeave} days Application '
                                : '${leave.totalRequestLeave} day Application ',
                            style: TextStyle(
                                fontSize: title,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          if (leave.leaveCurrentStatus == 'Rejected')
                            Container(
                              height: screenheight / 26.5,
                              width: screenWidth / 4.5,
                              decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  border: Border.all(
                                    color: Colors.red,
                                  ),

                                  // border: Border.all(
                                  //   color: leave.leaveCurrentStatus == 'Rejected'
                                  //       ? Colors.red
                                  //       : Colors.green,
                                  // ),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Text(leave.leaveCurrentStatus,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12)),
                              )),
                            ),
                          if (leave.leaveCurrentStatus == 'Approved' ||
                              leave.leaveCurrentStatus == 'Accepted')
                            Container(
                              height: screenheight / 26.5,
                              width: screenWidth / 4.5,
                              decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  border: Border.all(
                                    color: Colors.green,
                                  ),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Text(leave.leaveCurrentStatus,
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: heading)),
                              )),
                            ),
                          if (leave.leaveCurrentStatus == 'Pending')
                            Container(
                              height: screenheight / 26.5,
                              width: screenWidth / 4.5,
                              decoration: BoxDecoration(
                                  color: Colors.yellow.shade200,
                                  border: Border.all(
                                    color: Colors.orange,
                                  ),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(leave.leaveCurrentStatus,
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: heading)),
                              )),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '${leave.startDate} to ',
                            style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            leave.endDate,
                            style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (leave.leaveType == 'Compasionate' ||
                              leave.leaveType == 'compasionate' ||
                              leave.leaveType == 'Compassionate' ||
                              leave.leaveType == 'compassionate')
                            Text(
                              "Compassionate",
                              style: TextStyle(
                                  fontSize: fontSize,
                                  color: leave.leaveType == 'Compassionate'
                                      ? Colors.red
                                      : Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          if (leave.leaveType == 'full day' ||
                              leave.leaveType == 'Full Day')
                            Text(
                              "Full Day",
                              style: TextStyle(
                                  fontSize: fontSize,
                                  color: leave.leaveType == 'compassionate'
                                      ? Colors.red
                                      : Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          if (leave.leaveType == 'half day' ||
                              leave.leaveType == 'Half Day')
                            Text(
                              "Half Day",
                              style: TextStyle(
                                  fontSize: fontSize,
                                  color: leave.leaveType == 'Compassionate'
                                      ? Colors.red
                                      : Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          if (leave.leaveType == 'Lieu' ||
                              leave.leaveType == 'lieu')
                            Text(
                              "Liue",
                              style: TextStyle(
                                  fontSize: fontSize,
                                  color: leave.leaveType == 'Lieu' ||
                                          leave.leaveType == 'lieu'
                                      ? Colors.blue
                                      : Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          //   Text(leave.leaveType),
                          Row(
                            children: [
                              if (leave.leaveCurrentStatus == 'Pending')
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          title: Text('Confirm Delete'),
                                          content: Text(
                                              'Are you sure you want to delete this leave request?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                deleterequestLeave(
                                                  leave.id.toString(),
                                                  token.toString(),
                                                );
                                              },
                                              child: Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: red,
                                  ),
                                ),
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade300),
                                child: Center(
                                  child: Icon(
                                    CupertinoIcons.right_chevron,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ).p(5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
