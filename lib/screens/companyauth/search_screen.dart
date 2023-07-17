import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import '../../models/company/viewemployeedata.dart';
import '../../models/leave.dart';
import '../../viewmodel/company/compuserviewmodel.dart';
import '../../widget/constants.dart';
import '../../widget/date_range_picker.dart';
import '../../widget/leave_req_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  String? startDate;
  String? endDate;
  bool isLoading = false;
  List<LeaveRequest> dateLeaveRequests = [];
  List<LeaveRequest> monthLeaveRequests = [];
  List<LeaveRequest> weekLeaveRequests = [];
  List<LeaveRequest> tomorrowLeaveRequests = [];
  List<Employee> empstatus = [];
  late TabController _tabController;
  String listName = "";
  int currentIndex = 0;
  int check = 0;
  bool isFilter = true;

  Future<void> _getLeaveRequestByDate(String token, String id) async {
    setState(() {
      isLoading = true;
      isFilter = false;
    });
    const String requestLeaveUrl =
        "https://jporter.ezeelogix.com/public/api/company-search-leave-request-by-dates";

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'company_id': id,
      "start_date": startDate,
      "end_date": endDate
    });

    if (response.statusCode == 400) {
      final jsonData = json.decode(response.body);
      if (jsonData['message'] == 'No leaves found within the given range') {
        setState(() {
          dateLeaveRequests = [];
          isLoading = false;
        });
        print('No leaves found within the given range');
      }
    } else if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("responsessss: $jsonData");
      if (jsonData["status"] == "Error") {
        setState(() {
          dateLeaveRequests = [];
          isLoading = false;
        });
      } else {
        List<dynamic> requestedLeaves = jsonData['data']['requested_leaves'];
        setState(() {
          listName = "$startDate to $endDate";
          dateLeaveRequests = requestedLeaves
              .map((json) => LeaveRequest.fromJson(json))
              .toList();
          isLoading = false;
        });
        print(dateLeaveRequests);
        // Handle success scenario
      }
    } else {
      print(response.statusCode);
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      setState(() {
        isLoading = false;
      });
      // Handle error scenario
    }
  }

  void _getLeaveRequestByFilter(String token, String filter) async {
    setState(() {
      isLoading = true;
    });
    const String requestLeaveUrl =
        "https://jporter.ezeelogix.com/public/api/company-search-leave-request-by-filter";

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'company_id': '1',
      "filter_type": filter.toLowerCase()
    });

    if (response.statusCode == 400) {
      final jsonData = json.decode(response.body);
      if (jsonData['message'] == 'No leaves found within the given range') {
        setState(() {
          if (filter == "Current Month") {
            monthLeaveRequests = [];
          } else if (filter == "Tomorrow") {
            tomorrowLeaveRequests = [];
          } else if (filter == "Current Week") {
            weekLeaveRequests = [];
          }
          isLoading = false;
        });
        print('No leaves found within the given range');
      }
    } else if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("responsessss: $jsonData");
      if (jsonData["status"] == "Error") {
        setState(() {
          if (filter == "Current Month") {
            monthLeaveRequests = [];
          } else if (filter == "Tomorrow") {
            tomorrowLeaveRequests = [];
          } else if (filter == "Current Week") {
            weekLeaveRequests = [];
          }
          isLoading = false;
        });
      } else {
        List<dynamic> requestedLeaves = jsonData['data']['requested_leaves'];
        setState(() {
          if (filter == "Current Month") {
            monthLeaveRequests = requestedLeaves
                .map((json) => LeaveRequest.fromJson(json))
                .toList();
            ;
          } else if (filter == "Tomorrow") {
            tomorrowLeaveRequests = requestedLeaves
                .map((json) => LeaveRequest.fromJson(json))
                .toList();
            ;
          } else if (filter == "Current Week") {
            weekLeaveRequests = requestedLeaves
                .map((json) => LeaveRequest.fromJson(json))
                .toList();
            ;
          }
          isLoading = false;
        });
        if (filter == "Current Month") {
          print(monthLeaveRequests);
        } else if (filter == "Tomorrow") {
          print(tomorrowLeaveRequests);
        } else if (filter == "Current Week") {
          print(weekLeaveRequests);
        }
        // Handle success scenario
      }
    } else {
      print(response.statusCode);
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      setState(() {
        isLoading = false;
      });
      // Handle error scenario
    }
  }

  void _handleDateRangeSelected(String? startDate, String? endDate) {
    setState(() {
      this.startDate = startDate;
      this.endDate = endDate;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comViewModel = Provider.of<CompanyViewModel>(context);
    final token = comViewModel.token;
    final user = comViewModel.user;
    final companyId = user!.id;
    if (check == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _getLeaveRequestByFilter(token!, "Current Month");
        _getLeaveRequestByFilter(token, "Current Week");
        _getLeaveRequestByFilter(token, "Tomorrow");
      });
      check = 1;
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appbar,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              CupertinoIcons.left_chevron,
              color: Colors.black,
            )),
      ),
      backgroundColor: appbar,
      body: SafeArea(
        child: SizedBox(
            width: size.width,
            child: Column(children: [
              const Text(
                "Search Leave Requests",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ).pOnly(left: 24),
              const SizedBox(
                height: 25,
              ),
              DateRangePickerWidget(
                onDateRangeSelected: _handleDateRangeSelected,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                print(companyId.toString());
                                print(startDate);
                                print(endDate);
                                _getLeaveRequestByDate(
                                    token!, companyId.toString());
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 15)),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text("Search"))
                        ],
                      ),
                      isFilter
                          ? Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Search By",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Container(
                                //     decoration: BoxDecoration(
                                //       border: Border.all()
                                //     ),
                                //     child: Row(
                                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //       children: [
                                //         InkWell(
                                //           onTap: (){
                                //             setState(() {
                                //               currentIndex = 0;
                                //             });
                                //           },
                                //           child: Container(
                                //             color: currentIndex == 0? Colors.red :Colors.white,
                                //             child: Padding(
                                //               padding: const EdgeInsets.all(8.0),
                                //               child: Text("Tomorrow",style: TextStyle(color:currentIndex == 0? Colors.white :Colors.black,), ),
                                //             ),
                                //           ),
                                //         ),
                                //         InkWell(
                                //           onTap: (){
                                //             setState(() {
                                //               currentIndex = 1;
                                //             });
                                //           },
                                //           child: Container(
                                //             color: currentIndex == 1? Colors.red :Colors.white,
                                //             child: Padding(
                                //               padding: const EdgeInsets.all(8.0),
                                //               child: Text("This Week",style: TextStyle(color:currentIndex == 1? Colors.white :Colors.black,), ),
                                //             ),
                                //           ),
                                //         ),
                                //         InkWell(
                                //           onTap: (){
                                //             setState(() {
                                //               currentIndex = 2;
                                //             });
                                //           },
                                //           child: Container(
                                //             color: currentIndex == 2? Colors.red :Colors.white,
                                //             child: Padding(
                                //               padding: const EdgeInsets.all(8.0),
                                //               child: Text("This Week",style: TextStyle(color:currentIndex == 2? Colors.white :Colors.black,), ),
                                //             ),
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                DefaultTabController(
                                  length: 3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.red),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: const TabBar(
                                          indicatorColor: Colors.red,
                                          labelColor: Colors.red,
                                          unselectedLabelColor: Colors.black,
                                          tabs: [
                                            Tab(
                                              text: 'Tomorrow',
                                            ),
                                            Tab(text: 'This Week'),
                                            Tab(text: 'This Month'),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height / 2,
                                        child: Expanded(
                                          child: TabBarView(
                                            children: [
                                              Center(
                                                  child: tomorrowLeaveRequests
                                                          .isNotEmpty
                                                      ? ListView.builder(
                                                          itemCount:
                                                              tomorrowLeaveRequests
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            LeaveRequest leave =
                                                                tomorrowLeaveRequests[
                                                                    index];
                                                            // Employee emp =
                                                            //     empstatus[
                                                            //         index];
                                                            return LeaveRequestCard(
                                                              leave: leave,
                                                            );
                                                          },
                                                        )
                                                      : const Text(
                                                          "No Leave Requests for tomorrow")),
                                              Center(
                                                  child: weekLeaveRequests
                                                          .isNotEmpty
                                                      ? ListView.builder(
                                                          itemCount:
                                                              weekLeaveRequests
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            LeaveRequest leave =
                                                                weekLeaveRequests[
                                                                    index];
                                                            // Employee emp =
                                                            //     empstatus[
                                                            //         index];

                                                            return LeaveRequestCard(
                                                              leave: leave,
                                                            );
                                                          },
                                                        )
                                                      : const Text(
                                                          "No Leave Requests for this week")),
                                              Center(
                                                  child: monthLeaveRequests
                                                          .isNotEmpty
                                                      ? ListView.builder(
                                                          itemCount:
                                                              monthLeaveRequests
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            LeaveRequest leave =
                                                                monthLeaveRequests[
                                                                    index];
                                                            // Employee emp =
                                                            //     empstatus[
                                                            //         index];

                                                            return LeaveRequestCard(
                                                              leave: leave,
                                                            );
                                                          },
                                                        )
                                                      : const Text(
                                                          "No leave requests for this month")),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          : Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "$startDate to $endDate",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            isFilter = true;
                                          });
                                        },
                                        child: const Text("View Filters"))
                                  ],
                                ),
                                dateLeaveRequests.isNotEmpty
                                    ? SizedBox(
                                        height: size.height / 1.8,
                                        child: ListView.builder(
                                          itemCount: dateLeaveRequests.length,
                                          itemBuilder: (context, index) {
                                            LeaveRequest leave =
                                                dateLeaveRequests[index];

                                            return LeaveRequestCard(
                                              leave: leave,
                                            );
                                          },
                                        ),
                                      )
                                    : const Text(
                                        "No leave requests for this date")
                              ],
                            )
                    ],
                  ))
            ])),
      ),
      // TabBarView(
      //   controller: _tabController,
      //   children: [
      //     ByDate(),
      //     ByFilter(),
      //   ],
      // ),
    );
  }
}

class ByDate extends StatefulWidget {
  @override
  State<ByDate> createState() => _ByDateState();
}

class _ByDateState extends State<ByDate> {
  String? startDate;
  String? endDate;
  bool isLoading = false;
  List<LeaveRequest> leaveRequests = [];
  List<Employee> empstatus = [];

  void _handleDateRangeSelected(String? startDate, String? endDate) {
    setState(() {
      this.startDate = startDate;
      this.endDate = endDate;
    });
  }

  Future<void> _getLeaveRequestByDate(String token) async {
    setState(() {
      isLoading = true;
    });
    const String requestLeaveUrl =
        "https://jporter.ezeelogix.com/public/api/company-search-leave-request-by-dates";

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'company_id': '1',
      "start_date": startDate,
      "end_date": endDate
    });

    if (response.statusCode == 400) {
      final jsonData = json.decode(response.body);
      if (jsonData['message'] == 'No leaves found within the given range') {
        setState(() {
          leaveRequests = [];
          isLoading = false;
        });
        print('No leaves found within the given range');
      }
    } else if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("responsessss: $jsonData");
      if (jsonData["status"] == "Error") {
        setState(() {
          leaveRequests = [];
          isLoading = false;
        });
      } else {
        List<dynamic> requestedLeaves = jsonData['data']['requested_leaves'];
        setState(() {
          leaveRequests = requestedLeaves
              .map((json) => LeaveRequest.fromJson(json))
              .toList();
          isLoading = false;
        });
        print(leaveRequests);
        // Handle success scenario
      }
    } else {
      print(response.statusCode);
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      setState(() {
        isLoading = false;
      });
      // Handle error scenario
    }
  }

  @override
  Widget build(BuildContext context) {
    final empViewModel = Provider.of<CompanyViewModel>(context);
    final token = empViewModel.token;
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        DateRangePickerWidget(
          onDateRangeSelected: _handleDateRangeSelected,
        ),
        SizedBox(
          height: 40,
          width: size.width / 2,
          child: ElevatedButton(
              onPressed: () {
                if (startDate != null && endDate != null) {
                  _getLeaveRequestByDate(token!);
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    //to set border radius to button
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text("Search")),
        ),
        leaveRequests.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                itemCount: leaveRequests.length,
                itemBuilder: (context, index) {
                  LeaveRequest leave = leaveRequests[index];

                  return LeaveRequestCard(
                    leave: leave,
                  );
                },
              ))
            : const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("No leave requests in the given range"),
              )
      ],
    );
  }
}

class ByFilter extends StatefulWidget {
  @override
  State<ByFilter> createState() => _ByFilterState();
}

class _ByFilterState extends State<ByFilter> {
  List<LeaveRequest> leaveRequests = [];
  List<Employee> empstatus = [];

  String selectedFilter = 'Current Month';
  bool isLoading = false;

  Future<void> _getLeaveRequestByFilter(String token, String filter) async {
    setState(() {
      isLoading = true;
    });
    const String requestLeaveUrl =
        "https://jporter.ezeelogix.com/public/api/company-search-leave-request-by-filter";

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'company_id': '1',
      "filter_type": filter.toLowerCase()
    });

    if (response.statusCode == 400) {
      final jsonData = json.decode(response.body);
      if (jsonData['message'] == 'No leaves found within the given range') {
        setState(() {
          leaveRequests = [];
          isLoading = false;
        });
        print('No leaves found within the given range');
      }
    } else if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("responsessss: $jsonData");
      if (jsonData["status"] == "Error") {
        setState(() {
          leaveRequests = [];
          isLoading = false;
        });
      } else {
        List<dynamic> requestedLeaves = jsonData['data']['requested_leaves'];
        setState(() {
          leaveRequests = requestedLeaves
              .map((json) => LeaveRequest.fromJson(json))
              .toList();
          isLoading = false;
        });
        print(leaveRequests);
        // Handle success scenario
      }
    } else {
      print(response.statusCode);
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      setState(() {
        isLoading = false;
      });
      // Handle error scenario
    }
  }

  @override
  Widget build(BuildContext context) {
    final empViewModel = Provider.of<CompanyViewModel>(context);
    final token = empViewModel.token;
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Select Filter",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
            DropdownButton<String>(
              value: selectedFilter,
              hint: const Text('Select Filter'),
              items: <String>[
                'Current Month',
                'Tomorrow',
                'Current Week',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedFilter = newValue ?? '';
                });
              },
            ),
          ],
        ),
        // Text(
        //   'Selected Filter: $selectedFilter',
        //   style: const TextStyle(fontSize: 18),
        // ),
        SizedBox(
          height: 40,
          width: size.width / 2,
          child: ElevatedButton(
              onPressed: () {
                _getLeaveRequestByFilter(token!, selectedFilter);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    //to set border radius to button
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text("Search")),
        ),
        leaveRequests.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                itemCount: leaveRequests.length,
                itemBuilder: (context, index) {
                  LeaveRequest leave = leaveRequests[index];
                  return LeaveRequestCard(
                    leave: leave,
                  );
                },
              ))
            : const Text("No leave requests for the given filter")
      ],
    );
  }
}
