import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:holidays/screens/empauth/profile.dart';
import 'package:holidays/screens/empauth/request_leave.dart';

import '../../widget/constants.dart';
import 'home_screen.dart';

class EmpHome extends StatefulWidget {
  const EmpHome({Key? key}) : super(key: key);

  @override
  State<EmpHome> createState() => _EmpHomeState();
}

class _EmpHomeState extends State<EmpHome> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const RequestLeave(),
    EmpProfileView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          color: red,
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: Colors.red,
          height: 50,
          animationDuration: const Duration(milliseconds: 200),
          index: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            Icon(Icons.home, size: 30, color: Colors.white),
            Icon(Icons.add_box_outlined, size: 30, color: Colors.white),
            Icon(Icons.person_pin, size: 30, color: Colors.white),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (ctx) => const RequestLeave()),
        //     );
        //   },
        //   child: const Icon(Icons.add),
        // ),
        body: _screens[_currentIndex]);
  }
}
