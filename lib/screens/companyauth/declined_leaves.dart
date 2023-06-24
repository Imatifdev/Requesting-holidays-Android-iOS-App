import 'package:flutter/material.dart';

import '../../models/leave.dart';
import 'package:intl/intl.dart';

List declinedLeaves = [];
class DeclinedLeaves extends StatefulWidget {
  const DeclinedLeaves({super.key});

  @override
  State<DeclinedLeaves> createState() => _DeclinedLeavesState();
}

class _DeclinedLeavesState extends State<DeclinedLeaves> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(child: 
      SizedBox(
        width: size.width,
        child:  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Declined Requests", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              )),
              Expanded(
                child: ListView.builder(
                  itemCount: declinedLeaves.length,
                  itemBuilder: (context, index) {
                    LeaveItem leave = declinedLeaves[index];
                    String fromDate =
                    DateFormat('EEE, MMM d, yyyy').format(leave.fromDate);
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
                                    child: Text("${leave.numberOfDays} Day of Application")),
                                    Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(fromDate, style: TextStyle( fontSize: 22, fontWeight: FontWeight.bold, color: leave.leaveType == "Sick"? const Color.fromRGBO(100, 121, 198, 1 ):Colors.red))),
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
                                            backgroundColor: Colors.white
                                          ),  
                                          onPressed: (){}, child:  Text("Declined", style: TextStyle(color: Colors.red[900]),)),
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
                  },) )
            ]),
        ),
      ));
  }
}