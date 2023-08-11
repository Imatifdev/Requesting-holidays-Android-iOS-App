// ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, prefer_const_constructors, curly_braces_in_flow_control_structures, unused_import, duplicate_import

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:holidays/screens/companyauth/companyLogin.dart';
import 'package:holidays/screens/companyauth/compforgotpass.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/company/compuserviewmodel.dart';
import '../../widget/constants.dart';
import '../../widget/custombutton.dart';
import '../empauth/login.dart';
import 'package:hive/hive.dart';

import 'changepass.dart';
import 'companydashboard.dart';
import 'forgotpass.dart';

class CompanyProfileView extends StatefulWidget {
  @override
  State<CompanyProfileView> createState() => _CompanyProfileViewState();
}

class _CompanyProfileViewState extends State<CompanyProfileView> {
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    double fontSize;
    double title;
    double iconsize = 10;
    // Adjust the font size based on the screen width
    if (screenWidth < 320) {
      fontSize = 13.0;
      title = 18;
      iconsize = 20;
// Small screen (e.g., iPhone 4S)
    } else if (screenWidth < 375) {
      fontSize = 15.0;
      title = 24;

      iconsize = 23;
// Medium screen (e.g., iPhone 6, 7, 8)
    } else if (screenWidth < 414) {
      fontSize = 17.0;
      title = 26;

      iconsize = 27;
// Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else if (screenWidth < 600) {
      fontSize = 19.0;
      title = 30;

      iconsize = 30;
// Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else {
      fontSize = 22.0;
      title = 40;

// Extra large screen or unknown device
    }

    final companyViewModel = Provider.of<CompanyViewModel>(context);
    final user = companyViewModel.user;

    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: backgroundColor,
      //   leading: IconButton(
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //       icon: Icon(
      //         CupertinoIcons.left_chevron,
      //         color: Colors.black,
      //       )),
      // ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: screenheight * 0.08,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${user?.firstName} ${user?.lastName}',
                          style: TextStyle(
                              fontSize: title, fontWeight: FontWeight.bold),
                        ),
                        CircleAvatar(
                          radius: iconsize,
                          child: Icon(CupertinoIcons.person),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height / 14,
                      width: MediaQuery.of(context).size.width,
                      child: ListTile(
                        leading: Icon(Icons.mark_email_read_sharp),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text(
                            '${user?.email}',
                            style: TextStyle(fontSize: fontSize),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 50,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 14,
                    width: MediaQuery.of(context).size.width,
                    child: ListTile(
                      leading: Icon(CupertinoIcons.person_alt_circle),
                      title: Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          '${user?.phone}',
                          style: TextStyle(fontSize: fontSize),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 50,
                  ),
                  // Container(
                  //   height: MediaQuery.of(context).size.height / 14,
                  //   width: MediaQuery.of(context).size.width,
                  //   child: ListTile(
                  //     leading: Icon(CupertinoIcons.person_alt_circle),
                  //     title: Padding(
                  //       padding: const EdgeInsets.only(left: 30),
                  //       child: Text(
                  //         '${user?.id}',
                  //         style: TextStyle(fontSize: 14),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ]),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: MyCustomButton(
                    title: "Reset Password",
                    borderrad: 10,
                    buttontextcolr: Colors.white,
                    onaction: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => CompanyForgitPassword()));
                    },
                    color1: red,
                    color2: red,
                    width: MediaQuery.of(context).size.width - 40),
              ),
              const SizedBox(
                height: 30,
              ),
              // InkWell(
              //   onTap: () {
              //     // companyViewModel.signOut();
              //     Fluttertoast.showToast(
              //         msg: "User LogOut",
              //         toastLength: Toast.LENGTH_SHORT,
              //         gravity: ToastGravity.BOTTOM,
              //         timeInSecForIosWeb: 1,
              //         backgroundColor: Colors.green,
              //         textColor: Colors.white,
              //         fontSize: 16.0);
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (ctx) => CompanyLoginPage()));
              //   },
              //   child: Container(
              //     height: 50,
              //     width: MediaQuery.of(context).size.width * .70,
              //     decoration: BoxDecoration(),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Icon(
              //           Icons.logout_outlined,
              //           color: red,
              //           size: 30,
              //         ),
              //         SizedBox(
              //           width: 10,
              //         ),
              //         Text(
              //           "Sign Out",
              //           style: TextStyle(color: red),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => CompanyLoginPage()));

                  Fluttertoast.showToast(
                      msg: "User LogOut",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
                child: Container(
                  height: screenheight / 15,
                  width: screenWidth - 100,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.red),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout_outlined,
                        color: red,
                        size: iconsize,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Sign Out",
                        style: TextStyle(color: red, fontSize: fontSize),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ]),
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
