import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:holidays/screens/companyauth/update_company_leave.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../models/company/companyleavemodel.dart';
import '../../viewmodel/company/compuserviewmodel.dart';

class GetCompanyLeaves extends StatefulWidget {
  @override
  _GetCompanyLeavesState createState() => _GetCompanyLeavesState();
}

class _GetCompanyLeavesState extends State<GetCompanyLeaves> {
  int check = 0;

  List<CompanyLeave1> companyLeaves = [];

  void showConfirmationDialog(BuildContext context, CompanyLeave1 leave, String token) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this leave?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              deleteCompanyLeave(token, leave);

              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}


  Future<void> fetchCompanyLeaves(String token, String id) async {
    const String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/get-company-leaves';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'company_id': id.toString(),
    });
    if (response.statusCode == 200) {
      // Leave request successful
      final jsonData = json.decode(response.body);
      print(jsonData);
      // Handle success scenario
      List<dynamic> requestedLeaves = jsonData["data"];
      setState(() {
        companyLeaves = requestedLeaves
            .map((json) => CompanyLeave1.fromJson(json))
            .toList();
      });
    } else {
      print(response.statusCode);
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
    }
  }

  Future<void> deleteCompanyLeave(String token, CompanyLeave1 leave) async {
    const String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/delete-company-leaves';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'company_id': leave.companyId.toString(),
      'leave_id': leave.id.toString(),
    });
    if (response.statusCode == 200) {
      // Leave request successful
      final jsonData = json.decode(response.body);
      print(jsonData);
      setState(() {
        companyLeaves.removeWhere((lev) => lev.id == leave.id);
      });
    } else {
      print(response.statusCode);
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
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
        fetchCompanyLeaves(token!, companyId.toString());
      });
      check = 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Leaves'),
      ),
      body: companyLeaves.isNotEmpty
          ? ListView.builder(
              itemCount: companyLeaves.length,
              itemBuilder: (context, index) {
                CompanyLeave1 leave = companyLeaves[index];
                return ListTile(
                  leading: IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (context) =>
                              UpdateCompanyLeave(leave: leave, token: token!),
                        ))
                            .then((value) {
                          setState(() {
                            fetchCompanyLeaves(token!, companyId.toString());
                          });
                        });
                      },
                      icon: const Icon(Icons.update)),
                  title: Text(leave.title),
                  subtitle: Text('Dates:   ${leave.date}'),
                  trailing: IconButton(
                      onPressed: () {
                        //deleteCompanyLeave(token!, leave);
                        showConfirmationDialog(context, leave, token!);
                      },
                      icon: const Icon(Icons.delete)),
                );
              },
            )
          : const Center(child: CircularProgressIndicator() ),
    );
  }
}
