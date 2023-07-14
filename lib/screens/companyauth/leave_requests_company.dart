import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:holidays/models/leave.dart';

class ReceivedRequests extends StatefulWidget {
  final List<LeaveRequest> leaveRequests;
  const ReceivedRequests({super.key, required this.leaveRequests});

  @override
  State<ReceivedRequests> createState() => _ReceivedRequestsState();
}

class _ReceivedRequestsState extends State<ReceivedRequests> {
  @override
  void initState() {
    super.initState();
  }

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
                      "Leave Requests",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  )),
              //ElevatedButton(onPressed: ()=>_getallpendingLeaveRequest(token!), child:Text("get requests")),
              //leaveRequests.isNotEmpty? Text(leaveRequests[0].leaveType):Text("no requests"),
              Expanded(
                  child: ListView.builder(
                itemCount: widget.leaveRequests.length,
                itemBuilder: (context, index) {
                  LeaveRequest leave = widget.leaveRequests[index];
                  // String fromDate =
                  // DateFormat('EEE, MMM d, yyyy').format(leave.fromDate);
                  return leaveReqCard(
                    leave,
                  );
                },
              ))
            ]),
      ),
    ));
  }

  Padding leaveReqCard(LeaveRequest leave) {
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
                      child: Text(leave.startDate.toString(),
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: leave.leaveType == "Sick"
                                  ? const Color.fromRGBO(100, 121, 198, 1)
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
                          Text(leave.leaveCurrentStatus),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(55, 227, 27, 0.47)
                                          .withOpacity(0.474)),
                              onPressed: () {
                                setState(() {
                                  //approvedLeaves.add(leave);
                                  //allLeaves.removeWhere((item) => item.id == leave.id);
                                });
                              },
                              child: Text(
                                "Approve",
                                style: TextStyle(color: Colors.green[900]),
                              )),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[200]),
                              onPressed: () {
                                setState(() {
                                  //declinedLeaves.add(leave);
                                  // allLeaves.removeWhere((item) => item.id == leave.id);
                                });
                              },
                              child: Text(
                                "Decline",
                                style: TextStyle(color: Colors.red[900]),
                              )),
                        ],
                      ),
                      //IconButton(onPressed: (){}, icon:  const Icon(Icons.arrow_forward_ios_outlined, size: 10,))
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
