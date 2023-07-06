// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:holidays/models/company/companyleavemodel.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
class UpdateCompanyLeave extends StatefulWidget {
  final CompanyLeave1 leave;
  final String token;
  const UpdateCompanyLeave({super.key, required this.leave, required this.token});

  @override
  State<UpdateCompanyLeave> createState() => _UpdateCompanyLeaveState();
}

class _UpdateCompanyLeaveState extends State<UpdateCompanyLeave> {
  final _formKey = GlobalKey<FormState>();
  List<DateTime> _selectedDates = [];
  String dateError = "";
  String formattedDates="";
  bool isLoading = false;
  String errorAPI = "";
  final TextEditingController _titleController = TextEditingController();
  
  void selectDates()async{
    final initialSelectedDates = _selectedDates.isNotEmpty
                    ? _selectedDates
                    : [
                        DateTime.now()
                      ];
                   await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Select Dates'),
                      content: SizedBox(
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
                          child: const Text('OK'),
                          onPressed: () {
                            setState(() {
                                             for (int i = 0; i < _selectedDates.length; i++) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDates[i]);
    formattedDates += formattedDate;

    // Add a comma separator if it's not the last date
    if (i < _selectedDates.length - 1) {
      formattedDates += ', ';
    }
  }
                            });
                            print(_selectedDates);
                            Navigator.of(context).pop(_selectedDates);
                          },
                        ),
                      ],
                    );
                  },
                );
  }   
  
  Future<void> editCompanyLeave(String token, String companyId, String leaveId) async {
    setState(() {
      isLoading = true;
    });
    // Define the base URL and endpoint
    const baseUrl = 'https://jporter.ezeelogix.com/public/api/';
    const endpoint = 'edit-company-leaves';

    // Prepare the request body
    final requestBody = {
      'company_id': companyId,
      'leave_id': leaveId,
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
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
        print(responseData);
      } else {
        // Request failed
        print('Request failed with status: ${response.statusCode}');
        setState(() {
          isLoading = false;
          errorAPI = 'Request failed with status: ${response.statusCode}';
        });
      }
    } catch (error) {
      // An error occurred
      setState(() {
          isLoading = false;
          errorAPI = 'Error: $error';
        });
      print('Error: $error');
    }
  }

  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Company Leaves"),),
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                     const Padding(
                        padding:  EdgeInsets.all(10.0),
                        child: Text("Title", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold ),),
                      ),
                      Expanded(
                        child: TextFormField(
                            //keyboardType: TextInputType.visiblePassword,
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: 'Leave Title',
                              filled: true,
                              fillColor: Colors.grey[200],
                               border:  OutlineInputBorder(
                          borderRadius:  BorderRadius.circular(15.0),
                          borderSide:  const BorderSide(),
                        ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter leave title';
                              }
                              return null;
                            },
                          ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                     const Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: Text("Dates", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold ),),
                      ),
                      Expanded(
                        child: 
                        InkWell(
                          onTap: (){
                            selectDates();
                          },
                          child: Container(
                            height: size.height/15,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:BorderRadius.circular(15),
                            ),
                            child: Center(child: formattedDates == ""? const Text("Select Dates"): Text(formattedDates) ),
                          ),
                        ),
                        ),
                    ],
                  ),
                  Text(dateError, style: const TextStyle(color: Colors.red),),
                  const SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: (){
                      if(_formKey.currentState!.validate() && _selectedDates.isNotEmpty){
                        setState(() {
                          dateError = "";
                        });
                        editCompanyLeave(
                          widget.token,
                          widget.leave.companyId.toString(),
                          widget.leave.id.toString() 
                        );
                      }else{
                        setState(() {
                          dateError = "Please Select Dates";
                        });
                      }
                    }, 
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20)
                    ),
                    child: isLoading? const CircularProgressIndicator(color: Colors.white,):const Text("Save Leave")),
                  Text(errorAPI, style: TextStyle(color: Colors.red),),
                  TextButton(onPressed: (){
                    Navigator.of(context).pop();
                  },child: const Text("Cancel"),)
                ],
              ),
            ),
          ),
        ) ),
    );
  }
}