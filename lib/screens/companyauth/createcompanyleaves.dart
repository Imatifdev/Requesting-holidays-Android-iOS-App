// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_declarations

import 'dart:convert';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/leave.dart';
import '../../viewmodel/company/compuserviewmodel.dart';

class CreateCompanyLeave extends StatefulWidget {
  const CreateCompanyLeave({super.key});

  @override
  State<CreateCompanyLeave> createState() => _CreateCompanyLeaveState();
}

class _CreateCompanyLeaveState extends State<CreateCompanyLeave> {
  List<DateTime> _selectedDates = [];
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDates = [args.value];
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _selectedDates = List.from(args.value);
        _dateCount = args.value.length.toString();
      } else {
        _selectedDates = [];
        _rangeCount = args.value.length.toString();
      }
    });
  }

  TextEditingController _titleController = TextEditingController();

  Future<void> newcallApi(String token, String id) async {
    // Define the base URL and endpoint
    final baseUrl = 'https://jporter.ezeelogix.com/public/api/';
    final endpoint = 'create-company-leaves';

    // Prepare the request body
    final requestBody = {
      'company_id': id,
      'title': _titleController.text,
      for (int i = 0; i < _selectedDates.length; i++)
        'selectedDatesInput[$i]': _selectedDates[i].toString(),
    };

    // Prepare the request headers
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      // Send the POST request
      final response = await http.post(
        Uri.parse(baseUrl + endpoint),
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Request successful
        final responseData = json.decode(response.body);
        // Handle the response data as needed
        print(responseData);
      } else {
        // Request failed
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      // An error occurred
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final comViewModel = Provider.of<CompanyViewModel>(context);
    final token = comViewModel.token;
    final companyViewModel = Provider.of<CompanyViewModel>(context);
    final user = companyViewModel.user;
    final companyId = user!.id;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Title:'),
            SizedBox(height: 10),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Enter title',
              ),
            ),
            SizedBox(height: 20),
            Text('Select dates:'),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Select Dates'),
              onPressed: () async {
                final initialSelectedDates = _selectedDates.isNotEmpty
                    ? _selectedDates
                    : [
                        DateTime.now()
                      ]; // Use current date as initial selection if none exists

                final pickedDates = await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Select Dates'),
                      content: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: SfDateRangePicker(
                          initialSelectedDates: initialSelectedDates,
                          selectionMode: DateRangePickerSelectionMode.multiple,
                          onSelectionChanged:
                              (DateRangePickerSelectionChangedArgs args) {
                            setState(() {
                              _selectedDates = args.value.cast<DateTime>();
                            });
                          },
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop(_selectedDates);
                          },
                        ),
                      ],
                    );
                  },
                );

                if (pickedDates != null) {
                  setState(() {
                    _selectedDates = pickedDates;
                  });
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('new Call API'),
              onPressed: () {
                if (_titleController.text.isNotEmpty &&
                    _selectedDates.isNotEmpty) {
                  newcallApi(token!, companyId.toString());
                } else {
                  print('Please fill in all fields.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}