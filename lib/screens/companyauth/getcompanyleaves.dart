import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../models/company/companyleavemodel.dart';
import '../../viewmodel/company/compuserviewmodel.dart';

// class ShowCompanyLeaves extends StatefulWidget {
//   const ShowCompanyLeaves({super.key});

//   @override
//   State<ShowCompanyLeaves> createState() => _ShowCompanyLeavesState();
// }

// class _ShowCompanyLeavesState extends State<ShowCompanyLeaves> {
//   List<CompanyLeave> companyLeaves = [];

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     final comViewModel = Provider.of<CompanyViewModel>(context);
//     final token = comViewModel.token;
//     final companyViewModel = Provider.of<CompanyViewModel>(context);
//     final user = companyViewModel.user;
//     final companyId = user!.id;

//     newcallApi(token!, companyId.toString());
//   }

//   Future<void> newcallApi(String token, String id) async {
//     // Define the base URL and endpoint
//     final baseUrl = 'https://jporter.ezeelogix.com/public/api/';
//     final endpoint = 'get-company-leaves';

//     // Prepare the request body
//     final requestBody = {
//       'company_id': id,
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
//         final responseData = json.decode(response.body);

//         // Create a list to store the parsed company leaves
//         List<CompanyLeave> companyLeaves = [];

//         for (var item in responseData) {
//           // Parse each item and create a CompanyLeave object
//           CompanyLeave companyLeave = CompanyLeave.fromJson(item);

//           // Add the parsed object to the list
//           companyLeaves.add(companyLeave);
//         }

//         // Print the list of company leaves
//         print(companyLeaves);
//       } else {
//         // Request failed
//         print('Request failed with status: ${response.statusCode}');
//       }
//     } catch (error) {
//       // An error occurred
//       print('Error: $error');
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
//       body: ListView.builder(
//         itemCount: companyLeaves.length,
//         itemBuilder: (context, index) {
//           CompanyLeave leave = companyLeaves[index];
//           return ListTile(
//             title: Text(leave.title),
//             subtitle: Text('Date: ${leave.date}'),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CompanyLeave {
  final int? id;
  final int? companyId;
  final String? title;
  final DateTime? date;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CompanyLeave({
    this.id,
    this.companyId,
    this.title,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  factory CompanyLeave.fromJson(Map<String, dynamic> json) {
    return CompanyLeave(
      id: json['id'] as int?,
      companyId: json['company_id'] as int?,
      title: json['title'] as String?,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  int check = 0;

  List<CompanyLeave> companyLeaves = [];

  Future<void> newcallApi(String token, String id) async {
    final baseUrl = 'https://jporter.ezeelogix.com/public/api/';
    final endpoint = 'get-company-leaves';

    final requestBody = {
      'company_id': id,
    };

    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.post(
        Uri.parse(baseUrl + endpoint),
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData is List) {
          // Store response data in CompanyLeave instances
          List<CompanyLeave> companyLeaves = [];
          for (var jsonLeave in responseData) {
            CompanyLeave leave = CompanyLeave.fromJson(jsonLeave);
            companyLeaves.add(leave);
          }

          // Print the stored data
          for (var leave in companyLeaves) {
            print(leave.id);
            print(leave.companyId);
            print(leave.title);
            print(leave.date);
            print(leave.createdAt);
            print(leave.updatedAt);
            print('---');
          }
        } else if (responseData is Map<String, dynamic>) {
          // Handle a single object response
          CompanyLeave leave = CompanyLeave.fromJson(responseData);

          // Print the stored data
          print(leave.id);
          print(leave.companyId);
          print(leave.title);
          print(leave.date);
          print(leave.createdAt);
          print(leave.updatedAt);
        } else {
          // Invalid response format
          print('Invalid response format');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
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

    if (check == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        newcallApi(token!, companyId.toString());
      });
      check = 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Company Leaves'),
      ),
      body: ListView.builder(
        itemCount: companyLeaves.length,
        itemBuilder: (context, index) {
          CompanyLeave leave = companyLeaves[index];
          return ListTile(
            title: Text(leave.title.toString()),
            subtitle: Text('Date: ${leave.date}'),
          );
        },
      ),
    );
  }
}
