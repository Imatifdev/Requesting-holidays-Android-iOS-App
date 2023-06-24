// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:holidays/screens/request_leave.dart';
import 'package:intl/intl.dart';

import '../models/leave.dart';


  List<LeaveItem> allLeaves = [
    LeaveItem(id:"ujdncm5415sd" ,leaveType: "Sick", fromDate: DateTime(2023,2,12), toDate: DateTime(2023,2,14), cause: "Need time to help others", numberOfDays: 3),
    LeaveItem(id:"dc5d15c1dc1d" ,leaveType: "Casual", fromDate: DateTime(2023,2,15), toDate: DateTime(2023,2,18), cause: "Need time to heal", numberOfDays: 3),
    LeaveItem(id:"fv6e25cs51c5" ,leaveType: "Casual", fromDate: DateTime(2023,2,17), toDate: DateTime(2023,2,19), cause: "Need time for holidays", numberOfDays: 3),
    LeaveItem(id:"5d1f6e8f45f1" ,leaveType: "Casual", fromDate: DateTime(2023,2,21), toDate: DateTime(2023,2,24), cause: "Need time for health issues", numberOfDays: 3),
    LeaveItem(id:"98d4fv651v6r" ,leaveType: "Sick", fromDate: DateTime(2023,2,25), toDate: DateTime(2023,2,27), cause: "Need time visit my grandmother", numberOfDays: 3),
    LeaveItem(id:"7d51fvfv51fv" ,leaveType: "Casual", fromDate: DateTime(2023,3,1), toDate: DateTime(2023,3,4), cause: "Need time to go to college", numberOfDays: 3),
  ];
  List<LeaveItem> sickLeaves = [];
  List<LeaveItem> casualLeaves = [];
class LeaveScreen extends StatefulWidget {
  @override
  _LeaveScreenState createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  DateTime? _firstDate;
  DateTime? _lastDate;
  DateTimeRange   _selectedDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(days: 1)),
    );
  @override
  void initState() {
    super.initState();
    // _firstDate = DateTime.now().subtract(Duration(days: 365));
    // _lastDate = DateTime.now().add(Duration(days: 365));
  
    // _numberOfDays =
    //     _selectedDateRange!.end.difference(_selectedDateRange!.start).inDays +
    //        1;
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  void _selectDateRange(BuildContext context) async {
    final dateRange = await showDateRangePicker(
      context: context,
      firstDate: _firstDate!,
      lastDate: _lastDate!,
      initialDateRange: _selectedDateRange,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.red, // Customize the primary color
            ),
          ),
          child: child!,
        );
      },
    );

    // if (dateRange != null) {
    //   setState(() {
    //     _selectedDateRange = dateRange;
    //     _numberOfDays = _selectedDateRange!.end
    //             .difference(_selectedDateRange!.start)
    //             .inDays +
    //         1;
    //   });
    // }
  }
/* 
  void _openLeaveDialog() {
    final startDateFormatted =
        DateFormat('EEE, MMM d, yyyy').format(_selectedDateRange!.start);
    final endDateFormatted =
        DateFormat('EEE, MMM d, yyyy').format(_selectedDateRange!.end);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedLeaveType;
        TextEditingController causeController = TextEditingController();

        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('New Leave'),
          content: Container(
            height: 400,
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedLeaveType,
                  hint: Text(
                    'Type',
                    style: TextStyle(color: Colors.red),
                  ),
                  items: [
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
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      "Start:",
                      style: TextStyle(fontSize: 17, color: Colors.red),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Container(
                        height: 30,
                        color: Colors.grey.shade200,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 4),
                          child: Text(
                            startDateFormatted,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      "To:    ",
                      style: TextStyle(fontSize: 17, color: Colors.red),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Container(
                        height: 30,
                        color: Colors.grey.shade200,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 4),
                          child: Text(
                            endDateFormatted,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      "Cause:",
                      style: TextStyle(fontSize: 17, color: Colors.red),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextField(
                        controller: causeController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          hintText: 'Enter Cause',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => _selectDateRange(context),
                    child: Text('Select Date'),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            MaterialButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child: Text('Apply'),
              onPressed: () {
                if (selectedLeaveType != null && _selectedDateRange != null) {
                  final leaveItem = LeaveItem(
                    leaveType: selectedLeaveType!,
                    fromDate: _selectedDateRange!.start,
                    toDate: _selectedDateRange!.end,
                    cause: causeController.text, numberOfDays: 5,
                  );

                  setState(() {
                    allLeaves.add(leaveItem);

                    if (selectedLeaveType == 'Sick') {
                      sickLeaves.add(leaveItem);
                    } else if (selectedLeaveType == 'Casual') {
                      casualLeaves.add(leaveItem);
                    }

                    Navigator.of(context).pop();
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.left_chevron,
            color: Colors.red,
          ),
          onPressed: () {},
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 40),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Leaves",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => RequestLeave(),));
                      },
                      //_openLeaveDialog,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)),
                        height: 30,
                        width: 30,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Text(
                      "All ",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  Tab(
                    child: Row(
                      children: [
                        CircleAvatar(radius: 5, backgroundColor: Colors.red),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Sick ",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        )
                      ],
                    ),
                  ),
                  Tab(
                    child: Expanded(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 5,
                            backgroundColor: Color(0xff6479C6),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Casual",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLeaveList(allLeaves),
          _buildLeaveList(sickLeaves),
          _buildLeaveList(casualLeaves),
        ],
      ),
    );
  }

  Widget _buildLeaveList(List<LeaveItem> leaves) {
    return ListView.builder(
      itemCount: leaves.length,
      itemBuilder: (context, index) {
        final leave = leaves[index];
        String fromDate =
        DateFormat('EEE, MMM d, yyyy').format(leave.fromDate);
        String toDate = 
        DateFormat('EEE, MMM d, yyyy').format(leave.toDate);
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
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${leave.numberOfDays} Day Application',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10)),
                        height: 20,
                        width: 60,
                        child: Center(
                            child: Text("Status",
                                style:
                                    TextStyle(color: Colors.green.shade100))),
                      )
                    ],
                  ),
                  Text(
                    'From: $fromDate',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: leave.leaveType == 'Sick'
                            ? Colors.red
                            : Colors.blue),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'To: $toDate,',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        leave.leaveType,
                        style: TextStyle(
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
                              icon: Icon(
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
      },
    );
  }
}