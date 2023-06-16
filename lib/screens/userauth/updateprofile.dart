// ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, prefer_const_constructors, curly_braces_in_flow_control_structures, unused_import, duplicate_import

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:holidays/screens/userauth/updateprofile.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../models/usermodel.dart';

import '../../widget/constants.dart';
import '../../widget/custombutton.dart';
import 'login.dart';

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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
    return Scaffold(
      backgroundColor: appbar,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appbar,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.left_chevron,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                          "Settings",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
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
                            "email",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
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
                            "your name",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
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
                        leading: Icon(CupertinoIcons.phone),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text(
                            "contact",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      )),
                ]),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  children: [
                    MyCustomButton(
                        title: "Cancel",
                        borderrad: 10,
                        buttontextcolr: Colors.white,
                        onaction: () {},
                        color1: red,
                        color2: red,
                        width: 120),
                    SizedBox(
                      width: 50,
                    ),
                    MyCustomButton(
                        title: "Update",
                        borderrad: 10,
                        buttontextcolr: Colors.black,
                        onaction: () {},
                        color1: Colors.grey.shade200,
                        color2: Colors.grey.shade200,
                        width: 120),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
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
