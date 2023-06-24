import 'package:flutter/material.dart';
import 'package:holidays/screens/companyauth/leave_requests_company.dart';

import 'approved_leaves.dart';
import 'declined_leaves.dart';

class HomeCompany extends StatefulWidget {
  @override
  _HomeCompanyState createState() => _HomeCompanyState();
}

class _HomeCompanyState extends State<HomeCompany> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ReceivedRequests(),const Text("2"),ApprovedLeaves(),DeclinedLeaves()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, color: Colors.black,),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box, color: Colors.green,),
            label: 'Approved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cancel, color: Colors.red,),
            label: 'Declined',
          ),
        ],
      ),
    );
  }
}