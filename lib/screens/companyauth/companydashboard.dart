// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_declarations, unused_element, must_be_immutable, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:holidays/screens/companyauth/companyLogin.dart';
import 'package:holidays/screens/companyauth/createnewemployee.dart';
import 'package:holidays/screens/companyauth/profile.dart';
import 'package:holidays/screens/companyauth/search_screen.dart';
import 'package:holidays/screens/companyauth/showemployes.dart';
import 'package:holidays/screens/companyauth/stripe_screen.dart';
import 'package:holidays/viewmodel/company/compuserviewmodel.dart';
import 'package:holidays/widget/popuploader.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import '../../models/company/viewemployeedata.dart';
import '../../models/company_leave.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:http/http.dart' as http;

import '../../widget/company_leave_card.dart';
import '../../widget/constants.dart';
import 'companylogo.dart';
import 'createcompanyleaves.dart';
import 'createfinancialyear.dart';
import 'getcompanyleaves.dart';

enum StateEnum{ fetching, fetched, notFetched }

class CompanyDashBoard extends StatefulWidget {
  const CompanyDashBoard({super.key});

  @override
  _CompanyDashBoardState createState() => _CompanyDashBoardState();
}

class _CompanyDashBoardState extends State<CompanyDashBoard> {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  List<CompanyLeaveRequest> leaves = [];
  List<CompanyLeaveRequest> pendingLeaves = [];
  List<CompanyLeaveRequest> approvedLeaves = [];
  List<CompanyLeaveRequest> rejectedLeaves = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int check = 0;
  int _currentIndex = 0;
  bool currentStatus = false;
  final String imgurl = "https://jporter.ezeelogix.com/public/upload/logo/";

  Future<void> _getallLeaveRequest(String token, String id) async {
    // setState(() {
    //   state = StateEnum.fetching;
    // });
    final String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/company-get-all-requested-leaves';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'company_id': id,
    });
    // setState(() {
    //   state = StateEnum.fetched;
    // });
    if (response.statusCode == 200) {
      // Leave request successful
      final jsonData = json.decode(response.body);
      print(jsonData);
      // Handle success scenario
      List<dynamic> requestedLeaves =
          jsonData["data"]["employee_requested_leaves"];
      setState(() {
        leaves = requestedLeaves
            .map((json) => CompanyLeaveRequest.fromJson(json))
            .toList();
        for (CompanyLeaveRequest leave in leaves) {
          if (leave.leaveCurrentStatus == "Pending") {
            pendingLeaves.add(leave);
          }
        }
        for (CompanyLeaveRequest leave in leaves) {
          if (leave.leaveCurrentStatus == "Accepted") {
            approvedLeaves.add(leave);
          }
        }
        for (CompanyLeaveRequest leave in leaves) {
          if (leave.leaveCurrentStatus == "Rejected") {
            rejectedLeaves.add(leave);
          }
        }
      });
      print(leaves);
    } else {
      print(response.statusCode);
      // Error occurred
      print('Error: ${response.reasonPhrase}');
    //   setState(() {
    //   state = StateEnum.notFetched;
    // });
      // Handle error scenario
    }
  }

  Future<void> _getSubscriptionStatus(String token, String id) async {
    final String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/check-subscription-status';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'company_id': id,
    });
    if (response.statusCode == 200) {
      // Leave request successful
      final jsonData = json.decode(response.body);
      //print(jsonData);
      // Handle success scenario
      bool status = jsonData["data"]["status"];
      print("status: $status");
      setState(() {
        currentStatus = status;
      });
    } else {
      print(response.statusCode);
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
    }
  }

  @override
  Widget build(BuildContext context) {
    final empViewModel = Provider.of<CompanyViewModel>(context);
    final token = empViewModel.token;
    final user = empViewModel.user;
    final logoUrl = empViewModel.logoUrl;
    //print('${logoUrl}${user!.logo}'); // Get the logo URL

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (check == 0) {
        _getallLeaveRequest(token!, user!.id.toString());
        _getSubscriptionStatus(token, user.id.toString());
        check = 1;
      }
    });
    final List<Widget> _pages = [
      AllApplications(),
      CreateCompanyLeave(),
      ApprovedApplications(),
      RejectedApplications(),
      CompanyProfileView()
    ];
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Dashboard"),
        leading: IconButton(
            onPressed: () {
              if (currentStatus) {
                scaffoldKey.currentState?.openDrawer();
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Access Denied'),
                      content: Text(
                          'You do not have access. Please buy our package to get access.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => StripeScreen(),
                            ));
                            // Add code here to navigate to the Buy screen or perform the desired action
                          },
                          child: Text('Buy'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Action when Cancel button is pressed
                            Navigator.of(context).pop();
                            // Add code here to perform the desired action when Cancel is pressed
                          },
                          child: Text('Cancel'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            icon: Icon(Icons.menu_rounded)),
      ),
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.red.shade900, Colors.red.shade500],
            ),
          ),
          height: 275,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
              ),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('${logoUrl}${user!.logo}'),
              ).pOnly(left: 20, bottom: 20),
              Text(
                '${user.firstName} ' + ' ${user.lastName}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              )
            ],
          ).pOnly(left: 20),
        ),
        SizedBox(
          height: 30,
        ),
        ListTile(
          leading: Icon(Icons.person_2),
          title: Text(
            'Profile',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(CupertinoIcons.right_chevron),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (ctx) => CompanyProfileView()));
          },
        ),
        Divider(
          color: Colors.grey,
          thickness: 0.5,
        ).pSymmetric(h: 20),
        ListTile(
          leading: Icon(Icons.home),
          title: Text(
            'Home',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(CupertinoIcons.right_chevron),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        Divider(
          color: Colors.grey,
          thickness: 0.5,
        ).pSymmetric(h: 20),
        ListTile(
          leading: Icon(Icons.home),
          title: Text(
            'Create a financial Year',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(CupertinoIcons.right_chevron),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => CompanyFinancialYearScreen()));
          },
        ),
        Divider(
          color: Colors.grey,
          thickness: 0.5,
        ).pSymmetric(h: 20),
        ListTile(
          leading: Icon(Icons.create),
          title: Text(
            'Create New Employee',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(CupertinoIcons.right_chevron),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (ctx) => MyForm()));
          },
        ),
        Divider(
          color: Colors.grey,
          thickness: 0.5,
        ).pSymmetric(h: 20),
        ListTile(
          leading: Icon(CupertinoIcons.person_3_fill),
          title: Text(
            'View All Employee',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(CupertinoIcons.right_chevron),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (ctx) => ShowEmployee()));
          },
        ),
        Divider(
          color: Colors.grey,
          thickness: 0.5,
        ).pSymmetric(h: 20),
        ListTile(
          leading: Icon(Icons.search_off),
          title: Text(
            'View Company Leaves',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(CupertinoIcons.right_chevron),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (ctx) => GetCompanyLeaves()));
          },
        ),
        Divider(
          color: Colors.grey,
          thickness: 0.5,
        ).pSymmetric(h: 20),
        ListTile(
          leading: Icon(CupertinoIcons.money_dollar_circle_fill),
          title: Text(
            'Subscription',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(CupertinoIcons.right_chevron),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (ctx) => StripeScreen()));
          },
        ),
        Divider(
          color: Colors.grey,
          thickness: 0.5,
        ).pSymmetric(h: 20),
        ListTile(
          leading: Icon(CupertinoIcons.person_3_fill),
          title: Text(
            'Change Company Logo',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(CupertinoIcons.right_chevron),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (ctx) => CompanyLogo()));
          },
        ),
        Divider(
          color: Colors.grey,
          thickness: 0.5,
        ).pSymmetric(h: 20),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text(
            'Logout',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (ctx) => CompanyLoginPage()));
            Navigator.push(context,
                MaterialPageRoute(builder: (ctx) => CompanyLoginPage()));
          },
        ),
      ])),
      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey,
        selectedIconTheme: IconThemeData(color: Colors.red),
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner_outlined),
            label: 'Applications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Approved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.close),
            label: 'Rejected',
          ),
        ],
      ),
    );
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
}

class AllApplications extends StatefulWidget {
  const AllApplications({
    super.key,
  });

  @override
  State<AllApplications> createState() => _AllApplicationsState();
}

class _AllApplicationsState extends State<AllApplications> {
  StateEnum state = StateEnum.notFetched;
  final StreamController<List<CompanyLeaveRequest>>
      _leaveRequestsStreamController =
      StreamController<List<CompanyLeaveRequest>>.broadcast();
  List<CompanyLeaveRequest> leaves = [];
  List<CompanyLeaveRequest> newLeaves = [];
  int check = 0;
  List<CompanyLeaveRequest> pendingLeaves = [];
  Timer? _apiTimer;

  Future<void> _getallLeaveRequest(String token, String id) async {
    
    try {
      setState(() {
        leaves = [];
        pendingLeaves = [];
      });
      final String requestLeaveUrl =
          'https://jporter.ezeelogix.com/public/api/company-get-all-requested-leaves';

      final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }, body: {
        'company_id': id,
      });
      if (response.statusCode == 200) {
        // Leave request successful
        final jsonData = json.decode(response.body);
        print(jsonData);
        // Handle success scenario
        List<dynamic> requestedLeaves =
            jsonData["data"]["employee_requested_leaves"];
        setState(() {
          leaves = requestedLeaves
              .map((json) => CompanyLeaveRequest.fromJson(json))
              .toList();
          for (CompanyLeaveRequest leave in leaves) {
            if (leave.leaveCurrentStatus == "Pending") {
              pendingLeaves.add(leave);
            }
          }
          newLeaves = pendingLeaves;
          // for (CompanyLeaveRequest leave in leaves) {
          //   if (leave.leaveCurrentStatus == "Accepted") {
          //     approvedLeaves.add(leave);
          //   }
          // }
          // for (CompanyLeaveRequest leave in leaves) {
          //   if (leave.leaveCurrentStatus == "Rejected") {
          //     rejectedLeaves.add(leave);
          //   }
          // }
          _leaveRequestsStreamController.add(pendingLeaves);
        });
        PopupLoader.hide();
      } else {
        print(response.statusCode);
        // Error occurred
        print('Error: ${response.reasonPhrase}');
        // Handle error scenario
      }
    } catch (e) {
      print('Error: $e');
      PopupLoader.hide();
    }
    setState(() {
      state = StateEnum.fetched;
    });
  }

  void _changeLeaveStatus(String token, int companyId, int status,
      CompanyLeaveRequest leave) async {
    final String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/company-change-leave-request-status';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'company_id': companyId.toString(),
      'leave_request_id': leave.id.toString(),
      'leave_status': status.toString(),
    });

    if (response.statusCode == 200) {
      // Leave request successful
      final jsonData = json.decode(response.body);
      print(jsonData);
      // Handle success scenario
    } else {
      print(response.statusCode);
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
    }
  }

  void startApiTimer(String token, String id) {
    // Cancel the previous timer if it exists
    _apiTimer?.cancel();

    // Start a new timer that calls _fetchLeaveRequests every 3 seconds
    _apiTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      _getallLeaveRequest(token, id);
    });
  }

  // Function to stop the periodic API calls
  void stopApiTimer() {
    _apiTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final empViewModel = Provider.of<CompanyViewModel>(context);
    final token = empViewModel.token;
    final companyViewModel = Provider.of<CompanyViewModel>(context);
    final user = companyViewModel.user;
    final companyId = user!.id;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    double fontSize;
    double title;
    double heading;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (check == 0) {
        startApiTimer(token!, user.id.toString());
        // _getSubscriptionStatus(token, user.id.toString());
        
        check = 1;
      }
    });

    // Adjust the font size based on the screen width
    if (screenWidth < 320) {
      fontSize = 11.0;
      title = 13;
      heading = 10; // Small screen (e.g., iPhone 4S)
    } else if (screenWidth < 375) {
      fontSize = 12.0;
      title = 14;

      heading = 12; // Medium screen (e.g., iPhone 6, 7, 8)
    } else if (screenWidth < 414) {
      fontSize = 15.0;
      title = 16;

      heading = 14; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else if (screenWidth < 600) {
      fontSize = 19.0;
      title = 17;

      heading = 18; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else {
      fontSize = 22.0;
      title = 19;

      heading = 30; // Extra large screen or unknown device
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => SearchScreen(),
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width - 20,
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Search",
                    style: TextStyle(
                      fontSize: 20,
                    )),
                Icon(Icons.search)
              ],
            ).centered().pSymmetric(h: 30),
          ).centered().pOnly(left: 20, right: 20, top: 20, bottom: 10),
        ),
        StreamBuilder(
          builder: (context, snapshot) {
            return Container(
              child: 
              state == StateEnum.fetched?
              newLeaves.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: newLeaves.length,
                        //reverse: true,
                        itemBuilder: (context, index) {
                          // String fromDate =
                          // DateFormat('EEE, MMM d, yyyy').format(leave.startDate);
                          // String toDate =
                          // DateFormat('EEE, MMM d, yyyy').format(leave.toDate);
                          CompanyLeaveRequest leave = newLeaves[index];
                          return Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: InkWell(
                              onTap: () {},
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.grey,
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  leave.totalRequestLeave > 1
                                                      ? '${leave.totalRequestLeave} days Application '
                                                      : '${leave.totalRequestLeave} day Application ',
                                                  style: TextStyle(
                                                      fontSize: title,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              leave.employee.firstName,
                                              style: TextStyle(
                                                  fontSize: title,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'From: ${leave.startDate}',
                                                  style: TextStyle(
                                                      fontSize: fontSize,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  'To: ${leave.endDate}',
                                                  style: TextStyle(
                                                      fontSize: fontSize,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Type: ${leave.leaveType}',
                                                  style: TextStyle(
                                                    fontSize: fontSize,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                _changeLeaveStatus(token!,
                                                    companyId, 1, leave);
                                                setState(() {
                                                  pendingLeaves.removeWhere(
                                                      (leavez) =>
                                                          leavez.id ==
                                                          leave.id);
                                                });
                                              },
                                              child: Container(
                                                height: screenheight / 26.5,
                                                width: screenWidth / 4.5,
                                                decoration: BoxDecoration(
                                                    color:
                                                        Colors.green.shade100,
                                                    border: Border.all(
                                                        color: Colors.green),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Center(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  child: Text("Approve",
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: heading)),
                                                )),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                _changeLeaveStatus(token!,
                                                    companyId, 2, leave);
                                                setState(() {
                                                  pendingLeaves.removeWhere(
                                                      (leavez) =>
                                                          leavez.id ==
                                                          leave.id);
                                                });
                                              },
                                              child: Container(
                                                height: screenheight / 26.5,
                                                width: screenWidth / 4.5,
                                                decoration: BoxDecoration(
                                                    color: Colors.red.shade100,
                                                    border: Border.all(
                                                        color: Colors.red),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Center(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  child: Text("Reject",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: heading)),
                                                )),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 200,
                        ),
                        Center(
                            child: Column(
                          children: [
                            Icon(
                              CupertinoIcons.check_mark_circled,
                              size: 50,
                              color: red,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "You currently have no pending leave requests ",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        )),
                      ],
                    ) : Center(
                      child: CircularProgressIndicator(),
                    )
            );
          },
          stream: _leaveRequestsStreamController.stream,
        ),
      ],
    );
  }
}

class CreateApplications extends StatelessWidget {
  const CreateApplications({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page 2'),
    );
  }
}

class ApprovedApplications extends StatefulWidget {
  ApprovedApplications({super.key});

  @override
  State<ApprovedApplications> createState() => _ApprovedApplicationsState();
}

class _ApprovedApplicationsState extends State<ApprovedApplications> {
  List<CompanyLeaveRequest> leaves = [];
  List<CompanyLeaveRequest> approvedLeaves = [];
  List<Employee> empstatus = [];
  int check = 0;

  Future<void> _getApprovedLeaves(String token, String id) async {
    final String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/company-get-all-requested-leaves';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'company_id': id,
    });

    if (response.statusCode == 200) {
      // Leave request successful
      final jsonData = json.decode(response.body);
      print(jsonData);
      // Handle success scenario
      List<dynamic> requestedLeaves =
          jsonData["data"]["employee_requested_leaves"];
      setState(() {
        leaves = requestedLeaves
            .map((json) => CompanyLeaveRequest.fromJson(json))
            .toList();
        for (CompanyLeaveRequest leave in leaves) {
          if (leave.leaveCurrentStatus == "Accepted") {
            approvedLeaves.add(leave);
          }
        }
      });
      print(leaves);
    } else {
      print(response.statusCode);
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    double fontSize;
    double title;
    double heading;

    // Adjust the font size based on the screen width
    if (screenWidth < 320) {
      fontSize = 13.0;
      title = 13;
      heading = 10; // Small screen (e.g., iPhone 4S)
    } else if (screenWidth < 375) {
      fontSize = 15.0;
      title = 14;

      heading = 12; // Medium screen (e.g., iPhone 6, 7, 8)
    } else if (screenWidth < 414) {
      fontSize = 17.0;
      title = 16;

      heading = 14; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else if (screenWidth < 600) {
      fontSize = 19.0;
      title = 17;

      heading = 18; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else {
      fontSize = 22.0;
      title = 19;

      heading = 30; // Extra large screen or unknown device
    }

    final empViewModel = Provider.of<CompanyViewModel>(context);
    final token = empViewModel.token;
    final user = empViewModel.user;
    if (check == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _getApprovedLeaves(token!, user!.id.toString());
      });
      check = 1;
    }
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => SearchScreen(),
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width - 20,
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Search",
                    style: TextStyle(
                      fontSize: 20,
                    )),
                Icon(Icons.search)
              ],
            ).centered().pSymmetric(h: 30),
          ).centered().pOnly(left: 20, right: 20, top: 20, bottom: 10),
        ),
        approvedLeaves.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  itemCount: approvedLeaves.length,
                  itemBuilder: (context, index) {
                    // String fromDate =
                    // DateFormat('EEE, MMM d, yyyy').format(leave.startDate);
                    // String toDate =
                    // DateFormat('EEE, MMM d, yyyy').format(leave.toDate);
                    CompanyLeaveRequest leave = approvedLeaves[index];
                    return CompanyLeaveRequestCard(
                      leave: leave,
                    );
                  },
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 300,
                  ),
                  Center(child: CircularProgressIndicator()),
                ],
              ),
      ],
    );
  }
}

class RejectedApplications extends StatefulWidget {
  const RejectedApplications({super.key});

  @override
  State<RejectedApplications> createState() => _RejectedApplicationsState();
}

class _RejectedApplicationsState extends State<RejectedApplications> {
  List<CompanyLeaveRequest> leaves = [];
  List<CompanyLeaveRequest> rejectedLeaves = [];
  int check = 0;

  Future<void> _getApprovedLeaves(String token, String id) async {
    final String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/company-get-all-requested-leaves';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'company_id': id,
    });

    if (response.statusCode == 200) {
      // Leave request successful
      final jsonData = json.decode(response.body);
      print(jsonData);
      // Handle success scenario
      List<dynamic> requestedLeaves =
          jsonData["data"]["employee_requested_leaves"];
      setState(() {
        leaves = requestedLeaves
            .map((json) => CompanyLeaveRequest.fromJson(json))
            .toList();
        for (CompanyLeaveRequest leave in leaves) {
          if (leave.leaveCurrentStatus == "Rejected") {
            rejectedLeaves.add(leave);
          }
        }
      });
      print(leaves);
    } else {
      print(response.statusCode);
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
    }
  }

  @override
  Widget build(BuildContext context) {
    final empViewModel = Provider.of<CompanyViewModel>(context);
    final token = empViewModel.token;
    final user = empViewModel.user;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    double fontSize;
    double title;
    double heading;

    // Adjust the font size based on the screen width
    if (screenWidth < 320) {
      fontSize = 13.0;
      title = 13;
      heading = 10; // Small screen (e.g., iPhone 4S)
    } else if (screenWidth < 375) {
      fontSize = 15.0;
      title = 14;

      heading = 12; // Medium screen (e.g., iPhone 6, 7, 8)
    } else if (screenWidth < 414) {
      fontSize = 17.0;
      title = 16;

      heading = 14; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else if (screenWidth < 600) {
      fontSize = 19.0;
      title = 17;

      heading = 18; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else {
      fontSize = 22.0;
      title = 19;

      heading = 30; // Extra large screen or unknown device
    }

    if (check == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _getApprovedLeaves(token!, user!.id.toString());
      });
      check = 1;
    }
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => SearchScreen(),
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width - 20,
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Search",
                    style: TextStyle(
                      fontSize: 20,
                    )),
                Icon(Icons.search)
              ],
            ).centered().pSymmetric(h: 30),
          ).centered().pOnly(left: 20, right: 20, top: 20, bottom: 10),
        ),
        rejectedLeaves.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  itemCount: rejectedLeaves.length,
                  itemBuilder: (context, index) {
                    CompanyLeaveRequest leave = rejectedLeaves[index];
                    // String fromDate =
                    // DateFormat('EEE, MMM d, yyyy').format(leave.startDate);
                    // String toDate =
                    // DateFormat('EEE, MMM d, yyyy').format(leave.toDate);
                    return CompanyLeaveRequestCard(
                      leave: leave,
                    );
                  },
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 300,
                  ),
                  Center(child: CircularProgressIndicator()),
                ],
              ),
      ],
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(10.0),
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
      ),
    );
  }
}
