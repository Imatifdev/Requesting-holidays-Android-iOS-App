import 'package:flutter/material.dart';

import '../../models/leave.dart';
import 'package:intl/intl.dart';

class ApprovedLeaves extends StatefulWidget {
  final List approvedLeaves;
  const ApprovedLeaves({super.key, required this.approvedLeaves});

  @override
  State<ApprovedLeaves> createState() => _ApprovedLeavesState();
}

class _ApprovedLeavesState extends State<ApprovedLeaves> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: SizedBox(
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Approved Requests",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  )),
              Expanded(
                  child: ListView.builder(
                reverse: true,
                itemCount: widget.approvedLeaves.length,
                itemBuilder: (context, index) {
                  LeaveRequest leave =
                      widget.approvedLeaves.reversed.toList()[index];
                  // String fromDate =
                  // DateFormat('EEE, MMM d, yyyy').format(leave.startDate);
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        "${leave.totalRequestLeave} Day of Application")),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(leave.startDate.day.toString(),
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: leave.leaveType == "Sick"
                                                ? const Color.fromRGBO(
                                                    100, 121, 198, 1)
                                                : Colors.red))),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(leave.leaveType)),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      children: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                            ),
                                            onPressed: () {},
                                            child: Text(
                                              "Approved",
                                              style: TextStyle(
                                                  color: Colors.green[900]),
                                            )),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ))
            ]),
      ),
    ));
  }
}
