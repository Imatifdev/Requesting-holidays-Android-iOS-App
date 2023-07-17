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
        totalLeaveCount = diff.inDays+1;
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
                const SizedBox(height: 50,),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.window, color: Colors.white,),
                                ),
                              ),
                              SizedBox(
                                width: size.width/1.5,
                                child: DropdownButtonFormField<String>(
                                  focusColor: Colors.grey.shade100,
                                  dropdownColor:Colors.grey.shade100,
                                  value: selectedLeaveType,
                                  hint: const Text(
                                    'Type',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  items: const [
                                    DropdownMenuItem<String>(
                                      value: 'Compassionate',
                                      child: Text('Compassionate'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Lieu',
                                      child: Text('Lieu'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Full Day',
                                      child: Text('Full Day'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Half Day',
                                      child: Text('Half Day'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedLeaveType = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Text(errMsg2, style: const TextStyle(color: Colors.red)),
                          const SizedBox(height: 26),
                          Divider(color: Colors.grey.shade500,),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.calendar_month_outlined, color: Colors.white,),
                                ),
                              ),
                              const SizedBox(
                                width: 33,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: (){ 
                                    if(endDateFormatted==""){
                                      _selectDateRange(context);
                                    }
                                    },
                                  child: Container(
                                    height: 70,
                                    color: Colors.grey.shade100,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 4),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                              endDateFormatted == ""? "Calender":"Selected Dates:", style: const TextStyle(color: Colors.red),),
                                          Text(
                                            endDateFormatted == ""? "Select Leaves" :"$startDateFormatted to $endDateFormatted",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ).pOnly(top: 05),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        Text(errMsg, style: const TextStyle(color: Colors.red)),
                          const SizedBox(height: 30),
                          Divider(color: Colors.grey.shade500,),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.edit_note_rounded, color: Colors.white,size: 25,),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: size.width/1.5,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your cause for leave';
                                    }
                                    return null;
                                  },
                                  controller: causeController,
                                  decoration: InputDecoration(
                                    label: const Text("Cause"),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 10),
                                    hintText: 'Provide Cause of Leave',
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 50,
                            height: 50,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate() &&
                                      _firstDate != DateTime(2022, 11, 22) &&
                                      _lastDate != DateTime(2022, 11, 23) && selectedLeaveType!=null) {
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
                                  } 
                                  else if(selectedLeaveType==null){
                                    setState(() {
                                    errMsg2 = "Please select a type";
                                    });
                                  }
                                  else {
                                    setState(() {
                                      errMsg = "please select leave dates";
                                    });
                                  }
                                },
                                child: isLoading? const CircularProgressIndicator(color: Colors.white,) :const Text("Apply")),
                          ),
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
