import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:holidays/models/company_leave.dart';

import 'constants.dart';

class CompanyLeaveRequestCard extends StatelessWidget {
  final CompanyLeaveRequest leave;
  const CompanyLeaveRequestCard({
    super.key,
    required this.leave,
  });

  void popUp(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: SizedBox(
                height: 200,
                width: 300,
                child: Column(
                  children: [
                    const Text(
                      'Leave Request Details',
                      style: TextStyle(
                          color: red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Leave Type",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(leave.leaveType),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Leave Status",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(leave.leaveCurrentStatus),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "From",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(leave.startDate),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "To",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(leave.endDate),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Leave Days",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(leave.totalRequestLeave.toString()),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Comment",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(leave.comment),
                      ],
                    ),
                  ],
                ),
              ),
            ));
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

      heading = 14; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else {
      fontSize = 22.0;
      title = 19;

      heading = 30; // Extra large screen or unknown device
    }

    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: InkWell(
        onTap: () {
          popUp(context);
        },
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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
                        leave.totalRequestLeave > 1
                            ? '${leave.totalRequestLeave} days Application '
                            : '${leave.totalRequestLeave} day Application ',
                        style: TextStyle(
                            fontSize: title,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: screenheight / 26.5,
                        width: screenWidth / 4.5,
                        decoration: BoxDecoration(
                            color: leave.leaveCurrentStatus == 'Rejected'
                                ? Colors.red.shade100
                                : Colors.green.shade100,
                            border: Border.all(
                              color: leave.leaveCurrentStatus == 'Rejected'
                                  ? Colors.red
                                  : Colors.green,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(leave.leaveCurrentStatus,
                              style: TextStyle(
                                  color: leave.leaveCurrentStatus == 'Rejected'
                                      ? Colors.red
                                      : Colors.green,
                                  fontSize: 11)),
                        )),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${leave.startDate} to ',
                        style:
                            TextStyle(fontSize: fontSize, color: Colors.black),
                      ),
                      Text(
                        '${leave.endDate}',
                        style:
                            TextStyle(fontSize: fontSize, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        leave.leaveType,
                        style: TextStyle(
                            fontSize: fontSize, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade300),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              popUp(context);
                            },
                            child: Icon(
                              CupertinoIcons.right_chevron,
                              size: 20,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
