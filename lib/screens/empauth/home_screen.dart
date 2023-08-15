// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:holidays/models/emp/empusermodel.dart';
import 'package:holidays/screens/empauth/pending_leaves.dart';
import 'package:holidays/screens/empauth/rejected_leaves_screen.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/employee/empuserviewmodel.dart';
import '../../widget/constants.dart';
import 'approved_leaves_screen.dart';
import 'dashboard.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final empViewModel = Provider.of<EmpViewModel>(context);
    final user = empViewModel.user;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    double fontSize;
    double title;
    double para;
    double iconsize = 30;

    // Adjust the font size based on the screen width
    if (screenWidth < 320) {
      fontSize = 13.0;
      title = 17;
      iconsize = 40;
      para = 12; // Small screen (e.g., iPhone 4S)
    } else if (screenWidth < 375) {
      fontSize = 15.0;
      title = 19;
      para = 13;

      iconsize = 50; // Small screen (e.g., iPhone 4S)

// Medium screen (e.g., iPhone 6, 7, 8)
    } else if (screenWidth < 414) {
      fontSize = 17.0;
      title = 21;
      para = 15;

      iconsize = 60; // Small screen (e.g., iPhone 4S)

// Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else if (screenWidth < 600) {
      fontSize = 19.0;
      title = 23;
      para = 16;

      iconsize = 70; // Small screen (e.g., iPhone 4S)

// Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else {
      fontSize = 22.0;
      title = 40;
      para = 17; // Small screen (e.g., iPhone 4S)

// Extra large screen or unknown device
    }

    return SafeArea(
      child: SizedBox(
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Home",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: fontSize),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Hi ${user!.firstName}",
                              style: TextStyle(
                                fontSize: title,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: size.width / 1,
                          height: size.height / 6,
                          child: Container(
                            decoration: BoxDecoration(
                              color: red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 0.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Welcome",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: title,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "View all your leaves\nand request more",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: para),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    "assets/images/holiday.png",
                                    color: Colors.white,
                                    width: screenWidth / 3,
                                    height: screenheight / 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  //title column
                  SizedBox(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: screenWidth / 1.1,
                                  child: Text(
                                    "Holiday Entitlement Requests",
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: title,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ).centered(),
                                ),
                                SizedBox(
                                  width: screenWidth - 20,
                                  child: Text(
                                      "View all your requested leave status",
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: para,
                                      )).centered(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(20),
                       border: Border.all(color: red)
                       ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("You remaining Leaves",
                              style: TextStyle(color: red)),
                          Text(user.remainingLeaveQuota.toString() ,
                              style: TextStyle(
                                  color: red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold))
                        ],
                      )),
                  SizedBox(height: 20),
                  SizedBox(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LeaveScreen(),
                                ));
                              },
                              child: Container(
                                height: screenheight * 0.17,
                                width: screenWidth / 2.2,
                                decoration: BoxDecoration(
                                  color: red,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.list_alt_outlined,
                                      size: iconsize,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      height: screenheight / 90,
                                    ),
                                    Text(
                                      "All Leaves",
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth / 40,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PendingLeavesScreen(),
                                ));
                              },
                              child: Container(
                                height: screenheight * 0.17,
                                width: screenWidth / 2.2,
                                decoration: BoxDecoration(
                                  color: red,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.pending_actions_rounded,
                                      size: iconsize,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      height: screenheight / 90,
                                    ),
                                    Text(
                                      "Pending Leaves",
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenheight / 35,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ApprovedLeavesScreen(),
                                ));
                              },
                              child: Container(
                                height: screenheight * 0.17,
                                width: screenWidth / 2.2,
                                decoration: BoxDecoration(
                                  color: red,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: iconsize,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      height: screenheight / 90,
                                    ),
                                    Text(
                                      "Approved Leaves",
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth / 40,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RejectedLeavesScreen(),
                                ));
                              },
                              child: Container(
                                height: screenheight * 0.17,
                                width: screenWidth / 2.2,
                                decoration: BoxDecoration(
                                  color: red,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cancel_outlined,
                                      size: iconsize,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      height: screenheight / 90,
                                    ),
                                    Text(
                                      "Rejected Leaves",
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
