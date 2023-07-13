// // ignore_for_file: prefer_const_constructors

// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';

// import 'package:holidays/viewmodel/company/compuserviewmodel.dart';
// import 'package:velocity_x/velocity_x.dart';
// import '../../widget/constants.dart';

// class CompanyFinancialYearScreen extends StatefulWidget {
//   @override
//   _CompanyFinancialYearScreenState createState() =>
//       _CompanyFinancialYearScreenState();
// }

// class _CompanyFinancialYearScreenState
//     extends State<CompanyFinancialYearScreen> {
//   String financialYear = '';
//   DateTime? selectedDate;
//   int? selectedYear;
//   bool isFinancialYearSelected = false;

//   void _openDatePicker() {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           height: 300.0,
//           child: SfDateRangePicker(
//             onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
//               setState(() {
//                 selectedDate = args.value as DateTime?;
//                 selectedYear = selectedDate?.year;
//                 final startDate = DateTime(selectedYear!, 4, 1);
//                 final endDate = DateTime(selectedYear! + 1, 3, 31);
//                 final formattedStartDate = formatDate(startDate);
//                 final formattedEndDate = formatDate(endDate);
//                 financialYear = '$formattedStartDate to $formattedEndDate';
//                 isFinancialYearSelected = true;
//               });
//               Navigator.of(context).pop();
//             },
//             onCancel: () {
//               setState(() {
//                 _clearFinancialYear();
//               });
//               Navigator.of(context).pop();
//             },
//             view: DateRangePickerView.month,
//             initialSelectedDate: DateTime.now(),
//           ),
//         );
//       },
//     );
//   }

//   void _clearFinancialYear() {
//     setState(() {
//       financialYear = '';
//       selectedDate = null;
//       selectedYear = null;
//       isFinancialYearSelected = false;
//     });
//   }

//   String formatDate(DateTime date) {
//     final month = date.month.toString().padLeft(2, '0');
//     final day = date.day.toString().padLeft(2, '0');
//     return '$day-$month';
//   }

//   Future<void> newcallApi(String token, String id, String financialYear) async {
//     // Define the base URL and endpoint
//     final baseUrl = 'https://jporter.ezeelogix.com/public/api/';
//     final endpoint = 'company-create-financial-year';

//     // Prepare the request body
//     final requestBody = {
//       'company_id': id,
//       'financial_year': financialYear,
//     };

//     // Prepare the request headers
//     final headers = {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     };

//     try {
//       // Send the POST request
//       final response = await http.post(
//         Uri.parse(baseUrl + endpoint),
//         headers: headers,
//         body: requestBody,
//       );

//       if (response.statusCode == 200) {
//         // Request successful
//         final responseData = json.decode(response.body);
//         // Handle the response data as needed
//         print(responseData);
//         Fluttertoast.showToast(
//           msg: "Request successful",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.green,
//           textColor: Colors.white,
//         );
//       } else {
//         // Request failed
//         print('Request failed with status: ${response.statusCode}');
//         Fluttertoast.showToast(
//           msg: "Request failed",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//         );
//       }
//     } catch (error) {
//       // An error occurred
//       print('Error: $error');
//       Fluttertoast.showToast(
//         msg: "An error occurred",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final comViewModel = Provider.of<CompanyViewModel>(context);
//     final token = comViewModel.token;
//     final companyViewModel = Provider.of<CompanyViewModel>(context);
//     final user = companyViewModel.user;
//     final companyId = user!.id;
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         elevation: 0,
//         leading: Icon(CupertinoIcons.left_chevron, color: red),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: 30,
//             ),
//             Text(
//               "Create financial Year",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ).pOnly(left: 20),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30),
//                   child: Icon(Icons.calendar_month),
//                 ),
//                 Expanded(
//                   child: InkWell(
//                     onTap: isFinancialYearSelected
//                         ? _clearFinancialYear
//                         : _openDatePicker,
//                     child: Container(
//                       height: 50,
//                       width: 200,
//                       decoration: BoxDecoration(
//                           color: Colors.grey.shade300,
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Center(
//                         child: Text(
//                           isFinancialYearSelected
//                               ? 'Remove Financial Year'
//                               : 'Pick Financial Year',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16.0),
//             if (isFinancialYearSelected)
//               Text(
//                 'Selected Financial Year: $financialYear',
//                 style: TextStyle(fontSize: 18.0),
//               ),
//             SizedBox(height: 16.0),
//             Container(
//               height: 40,
//               width: 90,
//               decoration: BoxDecoration(
//                   color: Colors.blue, borderRadius: BorderRadius.circular(10)),
//               child: MaterialButton(
//                 onPressed: isFinancialYearSelected
//                     ? () {
//                         newcallApi(
//                           token!,
//                           companyId.toString(),
//                           financialYear,
//                         );
//                       }
//                     : null,
//                 child: Center(
//                   child: Text('Create',
//                       style: TextStyle(fontSize: 13, color: Colors.white)),
//                 ),
//               ),
//             ).pOnly(left: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:holidays/screens/companyauth/companydashboard.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:holidays/viewmodel/company/compuserviewmodel.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../widget/constants.dart';

class CompanyFinancialYearScreen extends StatefulWidget {
  @override
  _CompanyFinancialYearScreenState createState() =>
      _CompanyFinancialYearScreenState();
}

class _CompanyFinancialYearScreenState
    extends State<CompanyFinancialYearScreen> {
  String financialYear = '';
  int? selectedYear;
  bool isFinancialYearSelected = false;

  void _openDropdown() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Select Financial Year'),
          content: DropdownButton<int>(
            hint: Text("Select Year"),
            value: selectedYear,
            onChanged: (int? newValue) {
              setState(() {
                selectedYear = newValue;
                final startDate = DateTime(selectedYear!, 4, 1);
                final endDate = DateTime(selectedYear! + 1, 3, 31);
                final formattedStartDate = formatDate(startDate);
                final formattedEndDate = formatDate(endDate);
                financialYear = '$formattedStartDate to $formattedEndDate';
                isFinancialYearSelected = true;
              });
              Navigator.of(context).pop();
            },
            items: [
              DropdownMenuItem(
                value: 2022,
                child: Text('01st-apr to 31st-march'),
              ),
              DropdownMenuItem(
                value: 2023,
                child: Text('01st-jan to 31st-dec'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _clearFinancialYear() {
    setState(() {
      financialYear = '';
      selectedYear = null;
      isFinancialYearSelected = false;
    });
  }

  String formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$day-$month';
  }

  Future<void> newcallApi(String token, String id, String financialYear) async {
    // Define the base URL and endpoint
    final baseUrl = 'https://jporter.ezeelogix.com/public/api/';
    final endpoint = 'company-create-financial-year';

    // Prepare the request body
    final requestBody = {
      'company_id': id,
      'financial_year': financialYear,
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
        Fluttertoast.showToast(
          msg: "Request successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => CompanyDashBoard()));
      } else {
        // Request failed
        print('Request failed with status: ${response.statusCode}');
        Fluttertoast.showToast(
          msg: "Request failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (error) {
      // An error occurred
      print('Error: $error');
      Fluttertoast.showToast(
        msg: "An error occurred",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _showErrorMessage() {
    Fluttertoast.showToast(
      msg: "Please select a financial year",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final comViewModel = Provider.of<CompanyViewModel>(context);
    final token = comViewModel.token;
    final companyViewModel = Provider.of<CompanyViewModel>(context);
    final user = companyViewModel.user;
    final companyId = user!.id;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: Icon(CupertinoIcons.left_chevron, color: red),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              "Create Financial Year",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ).pOnly(left: 20),
            const SizedBox(height: 20),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Icon(Icons.calendar_month),
                ),
                Expanded(
                  child: InkWell(
                    onTap: isFinancialYearSelected
                        ? _clearFinancialYear
                        : _openDropdown,
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          isFinancialYearSelected
                              ? 'Remove Financial Year'
                              : 'Pick Financial Year',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            if (isFinancialYearSelected)
              Text(
                'Selected Financial Year: $financialYear',
                style: TextStyle(fontSize: 14.0),
              ),
            SizedBox(height: 16.0),
            Container(
              height: 40,
              width: 90,
              decoration: BoxDecoration(
                color: isFinancialYearSelected ? Colors.blue : Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: MaterialButton(
                onPressed: isFinancialYearSelected
                    ? () {
                        newcallApi(
                          token!,
                          companyId.toString(),
                          financialYear,
                        );
                      }
                    : _showErrorMessage,
                child: Center(
                  child: Text(
                    'Create',
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                ),
              ),
            ).pOnly(left: 20),
          ],
        ),
      ),
    );
  }
}
