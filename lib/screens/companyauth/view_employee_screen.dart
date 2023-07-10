import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:holidays/screens/companyauth/edit_employee.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import '../../models/company/viewemployeedata.dart';
import '../../viewmodel/company/compuserviewmodel.dart';
import '../../widget/constants.dart';


class ViewEmployee extends StatefulWidget {
  final Employee employee;
  const ViewEmployee({super.key, required this.employee});

  @override
  State<ViewEmployee> createState() => _ViewEmployeeState();
}

class _ViewEmployeeState extends State<ViewEmployee> {
  bool isLoading = false;

  Future<void> deleteCompanyEm(String token, Employee em) async {
    setState(() {
      isLoading = true;
    });
    const String requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/company-delete-employee';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'company_id': em.companyId.toString(),
      'employee_id': em.id.toString(),
    });
    if (response.statusCode == 200) {
      // Leave request successful
      final jsonData = json.decode(response.body);
      print(jsonData);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      print(response.statusCode);
      setState(() {
        isLoading = false;
      });
      // Error occurred
      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
    }
  }
  

  @override
  Widget build(BuildContext context) {
    final comViewModel = Provider.of<CompanyViewModel>(context);
    final token = comViewModel.token;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: appbar,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appbar,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              CupertinoIcons.left_chevron,
              color: Colors.black,
            )),
      ),
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const Text(
                    "Employee Details",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ).pOnly(left: 24),
                  const SizedBox(
                    height: 25,
                  ),
                  detailCard(context,"First Name", widget.employee.firstName),
                  detailCard(context,"Last Name", widget.employee.lastName),
                  detailCard(context,"Email", widget.employee.email),
                  detailCard(context,"Working Days", widget.employee.getWorkingDaysAsString()),
                  detailCard(context,"Phone Number", widget.employee.phone),
                  detailCard(context,"Verified Status", getStatus(widget.employee.isVerified)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditEmployee(emp: widget.employee,email: widget.employee.email, first_name: widget.employee.firstName, last_name: widget.employee.lastName,mobile: widget.employee.phone),));
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        padding:const EdgeInsets.all(10)
                      ),
                      child: const Text("Edit", style: TextStyle(color: Colors.black),)),
                    ElevatedButton(
                      onPressed: (){
                        deleteCompanyEm(token!,widget.employee);
                      }, 
                      style: ElevatedButton.styleFrom(
                        padding:const EdgeInsets.all(10)
                      ),
                      child: isLoading? const CircularProgressIndicator():const Text("Delete")),
                  ],)
              ],
            ),
          ),
        ) ),
    );
  }

  String getStatus(String status){
    if(status == "1"){
      return "Active";
    }else{
      return "Inactive";
    }
  }

  Container detailCard(BuildContext context, String name, String detail) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width-50,
                  color: appbar,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(name, style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                          Text(detail)
                        ],
                      ),
                      const Divider()
                    ],
                  ),
                );
  }
}