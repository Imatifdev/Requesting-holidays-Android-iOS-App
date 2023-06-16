// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:intl/intl.dart';

class LeaveScreen extends StatefulWidget {
  @override
  _LeaveScreenState createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<LeaveItem> _allLeaves = [];
  List<LeaveItem> _sickLeaves = [];
  List<LeaveItem> _casualLeaves = [];
  DateTime? _firstDate;
  DateTime? _lastDate;
  DateTimeRange? _selectedDateRange;
  int? _numberOfDays;
  @override
  void initState() {
    super.initState();
    _firstDate = DateTime.now().subtract(Duration(days: 365));
    _lastDate = DateTime.now().add(Duration(days: 365));
    _selectedDateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(days: 1)),
    );
    _numberOfDays =
        _selectedDateRange!.end.difference(_selectedDateRange!.start).inDays +
            1;
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

    if (dateRange != null) {
      setState(() {
        _selectedDateRange = dateRange;
        _numberOfDays = _selectedDateRange!.end
                .difference(_selectedDateRange!.start)
                .inDays +
            1;
      });
    }
  }

  void _openLeaveDialog() {
    final startDateFormatted =
        DateFormat('EEE, MMM d, yyyy').format(_selectedDateRange!.start);
    final endDateFormatted =
        DateFormat('EEE, MMM d, yyyy').format(_selectedDateRange!.end);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedLeaveType;
        DateTime? leaveFromDate;
        DateTime? leaveToDate;
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
                            '${startDateFormatted}',
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
                            '${endDateFormatted}',
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
                    cause: causeController.text,
                  );

                  setState(() {
                    _allLeaves.add(leaveItem);

                    if (selectedLeaveType == 'Sick') {
                      _sickLeaves.add(leaveItem);
                    } else if (selectedLeaveType == 'Casual') {
                      _casualLeaves.add(leaveItem);
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
                      onTap: _openLeaveDialog,
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
          _buildLeaveList(_allLeaves),
          _buildLeaveList(_sickLeaves),
          _buildLeaveList(_casualLeaves),
        ],
      ),
    );
  }

  Widget _buildLeaveList(List<LeaveItem> leaves) {
    final startDateFormatted =
        DateFormat('EEE, MMM d,').format(_selectedDateRange!.start);
    final endDateFormatted =
        DateFormat('EEE, MMM d, yyyy').format(_selectedDateRange!.end);

    if (leaves.isEmpty) {
      return Center(
        child: Text('No leaves to display'),
      );
    }

    return ListView.builder(
      itemCount: leaves.length,
      itemBuilder: (context, index) {
        final leaveItem = leaves[index];

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
                        '$_numberOfDays Day Application',
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
                    'From: ${startDateFormatted}',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: leaveItem.leaveType == 'Sick'
                            ? Colors.red
                            : Colors.blue),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'To: ${endDateFormatted},',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${leaveItem.leaveType}',
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

class LeaveItem {
  final String leaveType;
  final DateTime fromDate;
  final DateTime toDate;
  final String cause;

  LeaveItem({
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.cause,
  });
}
