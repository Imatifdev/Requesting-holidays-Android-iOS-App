// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/leave.dart';
import 'constants.dart';
import 'package:velocity_x/velocity_x.dart';

class LeaveRequestCard extends StatelessWidget {
  final LeaveRequest leave;
  const LeaveRequestCard({
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
                        Text(leave.startDate.toString()),
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
                        Text(leave.endDate.toString()),
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
    return Padding(
      padding: const EdgeInsets.all(5.0),
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
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            height: 35,
                            width: 80,
                            decoration: BoxDecoration(
                                color: leave.leaveCurrentStatus == 'Rejected'
                                    ? Colors.red.shade100
                                    : Colors.green.shade100,
                                // border: Border.all(
                                //   color: leave.leaveCurrentStatus == 'Rejected'
                                //       ? Colors.red
                                //       : Colors.green,
                                // ),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(leave.leaveCurrentStatus,
                                  style: TextStyle(
                                      color:
                                          leave.leaveCurrentStatus == 'Rejected'
                                              ? Colors.red
                                              : Colors.green,
                                      fontSize: 12)),
                            )),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '${leave.startDate.day} to ',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            '${leave.endDate}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            leave.leaveType,
                            style: TextStyle(
                                fontSize: 14,
                                color: leave.leaveType == 'Compassionate'
                                    ? Colors.red
                                    : Colors.blue,
                                fontWeight: FontWeight.bold),
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
                            )),
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
