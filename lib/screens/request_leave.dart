import 'package:flutter/material.dart';
import 'package:holidays/models/leave.dart';
import 'package:intl/intl.dart';

import 'dashboard.dart';
class RequestLeave extends StatefulWidget {
  const RequestLeave({super.key});

  @override
  State<RequestLeave> createState() => _RequestLeaveState();
}


class _RequestLeaveState extends State<RequestLeave> {
  final _formKey = GlobalKey<FormState>();
  var startDateFormatted ="Select from date";
  var endDateFormatted ="Select to date";
  String errMsg = "";
  DateTime _firstDate = DateTime(2022,11,22);
  DateTime _lastDate = DateTime(2023,11,23);
  String? selectedLeaveType;
  TextEditingController causeController = TextEditingController();
  final DateTimeRange _selectedDateRange = DateTimeRange(start: DateTime( DateTime.now().year,DateTime.now().month,DateTime.now().day), end:DateTime( DateTime.now().year,DateTime.now().month,DateTime.now().day+1));
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
    if (dateRange != null){
      setState(() {
      startDateFormatted =
        DateFormat('EEE, MMM d, yyyy').format(dateRange.start);
        _firstDate = dateRange.start;
        endDateFormatted =
        DateFormat('EEE, MMM d, yyyy').format(dateRange.end);
        _lastDate = dateRange.end;
    });
    }
    }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("New Leave", style:TextStyle(fontSize:24, fontWeight: FontWeight.bold))),
              Padding(
                padding:const EdgeInsets.all(10),
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
                                value: 'Sick',
                                child: Text('Sick'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Casual',
                                child: Text('Casual'),
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
                                    contentPadding:
                                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                          Text(errMsg, style:const TextStyle(color:Colors.red)),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(size.width/4, size.height/40, size.width/4, size.height/40),
                        shape: RoundedRectangleBorder( //to set border radius to button
                  borderRadius: BorderRadius.circular(50)
                            ),),
                            onPressed: (){
                            if(_formKey.currentState!.validate() && _firstDate!=DateTime(2022,11,22) && _lastDate!=DateTime(2022,11,23)){
                              final LeaveItem leave = 
                              LeaveItem(
                                id: DateTime.now().millisecond.toString(),
                                cause: causeController.text,
                                fromDate: _firstDate,
                                toDate: _lastDate,
                                leaveType:selectedLeaveType.toString(), 
                                numberOfDays: _lastDate
                .difference(_firstDate)
                .inDays +
            1);
                              setState(() {
                                allLeaves.add(leave);
                                if (selectedLeaveType == 'Sick') {
                      sickLeaves.add(leave);
                    } else if (selectedLeaveType == 'Casual') {
                      casualLeaves.add(leave);
                    }
                              });
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  LeaveScreen()));
                            }
                            else{
                              setState(() {
                                errMsg = "please select a valid date";
                              });
                            }
                          }, child: const Text("Send Leave Request")),
                          
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}