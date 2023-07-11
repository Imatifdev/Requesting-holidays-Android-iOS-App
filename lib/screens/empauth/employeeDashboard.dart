// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/employee/empuserviewmodel.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../widget/constants.dart';

class EmployeeDashBoard extends StatefulWidget {
  const EmployeeDashBoard({super.key});

  @override
  State<EmployeeDashBoard> createState() => _EmployeeDashBoardState();
}

class _EmployeeDashBoardState extends State<EmployeeDashBoard> {
  @override
  Widget build(BuildContext context) {
    final empViewModel = Provider.of<EmpViewModel>(context);
    final user = empViewModel.user;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: height * .1,
          ),
          Text(
            'Hi, ${user!.firstName} !',
            style: TextStyle(
                color: red, fontSize: 25, fontWeight: FontWeight.bold),
          )
        ],
      ).p(20),
    );
  }
}
