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

  void popUp(BuildContext context){
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
                                     const SizedBox(height: 10,),
                                           Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                            const Text("Leave Type", style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold ),),
                                            Text(leave.leaveType),
                                           ],),
                                           Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                            const Text("Leave Status", style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold ),),
                                            Text(leave.leaveCurrentStatus),
                                           ],),
                                           Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                            const Text("From", style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold ),),
                                            Text(leave.startDate),
                                           ],),
                                           Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                            const Text("To", style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold ),),
                                            Text(leave.endDate),
                                           ],),
                                           Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                            const Text("Total Leave Days", style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold ),),
                                            Text(leave.totalRequestLeave.toString()),
                                           ],),
                                           Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                            const Text("Comment", style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold ),),
                                            Text(leave.comment),
                                           ],),
                                          ],
                                        ),
                                      ),
                                    ));
        }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(13.0),
      child: InkWell(
        onTap:(){popUp(context);},
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),),
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
                  Text(
                    'To: ${leave.endDate}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: leave.leaveType == 'Compassionate'
                            ? Colors.red
                            : Colors.blue),
                  ),
                  const SizedBox(
                    height: 10,
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
                              onPressed: (){popUp(context);},
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
        ),
      ),
    );
  }
}
