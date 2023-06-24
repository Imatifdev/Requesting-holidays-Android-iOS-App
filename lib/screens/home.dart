// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:holidays/screens/empauth/profile.dart';

import 'companyauth/profile.dart';

class HomePage extends StatefulWidget {
  static const routeName = "home";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pgindex = 0;
  void selindex(int index) {
    setState(() {});
    pgindex = index;
  }

  final List<Widget> pages = [
    EmpProfileView(),
    EmpProfileView(),
  ];
  List<int> listofpages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedFontSize: 14,
            selectedItemColor: Colors.black,
            selectedFontSize: 16,
            selectedLabelStyle: TextStyle(color: Colors.black),
            iconSize: 30,
            onTap: selindex,
            currentIndex: pgindex,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.color_lens,
                    color: Colors.grey,
                  ),
                  label: "fill Color"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                  label: "Edit Profile")
            ]),
        body: pages[pgindex]);
  }
}
