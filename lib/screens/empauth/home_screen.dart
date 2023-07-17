// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:holidays/screens/empauth/pending_leaves.dart';
import 'package:holidays/screens/empauth/rejected_leaves_screen.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/employee/empuserviewmodel.dart';
import '../../widget/constants.dart';
import 'approved_leaves_screen.dart';
import 'dashboard.dart';

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
    double heading;
    double para;

    // Adjust the font size based on the screen width
    if (screenWidth < 320) {
      fontSize = 13.0;
      title = 20;
      heading = 30;
      para = 12; // Small screen (e.g., iPhone 4S)
    } else if (screenWidth < 375) {
      fontSize = 15.0;
      title = 20;
      para = 13; // Small screen (e.g., iPhone 4S)

      heading = 24; // Medium screen (e.g., iPhone 6, 7, 8)
    } else if (screenWidth < 414) {
      fontSize = 17.0;
      title = 21;
      para = 15; // Small screen (e.g., iPhone 4S)

      heading = 28; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else if (screenWidth < 600) {
      fontSize = 19.0;
      title = 23;
      para = 16; // Small screen (e.g., iPhone 4S)

      heading = 30; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else {
      fontSize = 22.0;
      title = 40;
      para = 17; // Small screen (e.g., iPhone 4S)

      heading = 30; // Extra large screen or unknown device
    }

    return SafeArea(
      child: SizedBox(
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                      height: 10,
                    ),
                    SizedBox(
                      width: size.width,
                      height: size.height / 6,
                      child: Container(
                        decoration: BoxDecoration(
                          color: red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          color: Colors.white, fontSize: para),
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
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Holiday Entitlements Requests",
                              style: TextStyle(
                                fontSize: title,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("View all your requested leaves status",
                                style: TextStyle(
                                  fontSize: para,
                                )),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
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
                            height: (size.width - 50) / 2.1,
                            width: (size.width - 50) / 2.1,
                            decoration: BoxDecoration(
                              color: red,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.list_alt_outlined,
                                  size: 60,
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
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PendingLeavesScreen(),
                            ));
                          },
                          child: Container(
                            height: (size.width - 50) / 2.1,
                            width: (size.width - 50) / 2.1,
                            decoration: BoxDecoration(
                              color: red,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.pending_actions_rounded,
                                  size: 60,
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
                    const SizedBox(
                      height: 10,
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
                            height: (size.width - 50) / 2.1,
                            width: (size.width - 50) / 2.1,
                            decoration: BoxDecoration(
                              color: red,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  size: 60,
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
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RejectedLeavesScreen(),
                            ));
                          },
                          child: Container(
                            height: (size.width - 50) / 2.1,
                            width: (size.width - 50) / 2.1,
                            decoration: BoxDecoration(
                              color: red,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cancel_outlined,
                                  size: 50,
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
            ],
          ),
        ),
      ),
    );
  }
}
