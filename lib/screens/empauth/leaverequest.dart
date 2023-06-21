import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../../viewmodel/employee/empuserviewmodel.dart';

class EmpProfileViewreq extends StatefulWidget {
  @override
  _EmpProfileViewreqState createState() => _EmpProfileViewreqState();
}

class _EmpProfileViewreqState extends State<EmpProfileViewreq> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _employeeIdController = TextEditingController();
  TextEditingController _leaveTypeController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _totalLeaveCountController = TextEditingController();
  TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _employeeIdController.dispose();
    _leaveTypeController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _totalLeaveCountController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EmpViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _employeeIdController,
                  decoration: InputDecoration(labelText: 'Employee ID'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Employee ID is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _leaveTypeController,
                  decoration: InputDecoration(labelText: 'Leave Type'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Leave Type is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _startDateController,
                  decoration: InputDecoration(labelText: 'Start Date'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Start Date is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _endDateController,
                  decoration: InputDecoration(labelText: 'End Date'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'End Date is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _totalLeaveCountController,
                  decoration: InputDecoration(labelText: 'Total Leave Count'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Total Leave Count is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _commentController,
                  decoration: InputDecoration(labelText: 'Comment'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Comment is required';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final employeeId = _employeeIdController.text;
                      final leaveType = _leaveTypeController.text;
                      final startDate = _startDateController.text;
                      final endDate = _endDateController.text;
                      final totalLeaveCount = _totalLeaveCountController.text;
                      final comment = _commentController.text;

                      viewModel.requestLeave(
                        employeeId,
                        leaveType,
                        startDate,
                        endDate,
                        totalLeaveCount,
                        comment,
                      );
                    }
                  },
                  child: Text('Request Leave'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
