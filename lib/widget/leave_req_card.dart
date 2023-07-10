import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/leave.dart';

class LeaveRequestCard extends StatelessWidget {
  final LeaveRequest leave;
  const LeaveRequestCard({super.key, required this.leave});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 1,
              color: Colors.grey,
            )),
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
                    '${leave.totalRequestLeave} day Application ',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Container(
                    decoration: BoxDecoration(
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
                          )),
                    )),
                  )
                ],
              ),
              Text(
                'From: ${leave.startDate}',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: leave.leaveType == 'Compassionate'
                        ? Colors.red
                        : Colors.blue),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'To: ${leave.endDate},',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.normal),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    leave.leaveType,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade300),
                    child: Center(
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            CupertinoIcons.right_chevron,
                            size: 20,
                          )),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
