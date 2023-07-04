import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../models/leave.dart';
import '../../viewmodel/company/compuserviewmodel.dart';
import '../../widget/date_range_picker.dart';
import '../../widget/leave_req_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Leave Requests'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
             Tab(text: 'Search by Date'),
             Tab(text: 'Search by Filter'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ByDate(),
          ByFilter(),
        ],
      ),
    );
  }
}

class ByDate extends StatefulWidget {
  @override
  State<ByDate> createState() => _ByDateState();
}
class _ByDateState extends State<ByDate> {
  String? startDate;
  String? endDate;
  bool isLoading = false;
  List<LeaveRequest> leaveRequests = [];

  void _handleDateRangeSelected(String? startDate, String? endDate) {
    setState(() {
      this.startDate = startDate;
      this.endDate = endDate;
    });
  }
  
  Future<void> _getLeaveRequestByDate(String token) async {
  setState(() {
    isLoading = true;
  });
  const String requestLeaveUrl =
      "https://jporter.ezeelogix.com/public/api/company-search-leave-request-by-dates";

  final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  }, body: {
    'company_id': '1',
    "start_date": startDate,
    "end_date": endDate
  });

  if (response.statusCode == 400) {
    final jsonData = json.decode(response.body);
    if (jsonData['message'] == 'No leaves found within the given range') {
      setState(() {
        leaveRequests = [];
        isLoading = false;
      });
      print('No leaves found within the given range');
    }
  } else if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    print("responsessss: $jsonData");
    if(jsonData["status"] == "Error"){
      setState(() {
        leaveRequests = [];
        isLoading = false;
      });
    }
    else{
      List<dynamic> requestedLeaves = jsonData['data']['requested_leaves'];
    setState(() {
      leaveRequests =
          requestedLeaves.map((json) => LeaveRequest.fromJson(json)).toList();
      isLoading = false;    
    });
    print(leaveRequests);
    // Handle success scenario
    }
  } else {
    print(response.statusCode);
    // Error occurred
    print('Error: ${response.reasonPhrase}');
    setState(() {
    isLoading = false;
  });
    // Handle error scenario
  }
}
  

  @override
  Widget build(BuildContext context) {
    final empViewModel = Provider.of<CompanyViewModel>(context);
    final token = empViewModel.token;
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        DateRangePickerWidget(
                onDateRangeSelected: _handleDateRangeSelected,
              ),
        SizedBox(
          height: 40,
          width: size.width/2,
          child: ElevatedButton(onPressed: (){
            if(startDate!=null && endDate !=null){
              _getLeaveRequestByDate(token!);
            }
          },
          style: ElevatedButton.styleFrom(
             shape: RoundedRectangleBorder( //to set border radius to button
                borderRadius: BorderRadius.circular(30)
            ),
          ),
          child: isLoading? const CircularProgressIndicator(color: Colors.white,):const Text("Search")),
        ),      
        leaveRequests.isNotEmpty? Expanded(child: 
            ListView.builder(
              itemCount: leaveRequests.length,
              itemBuilder: (context, index) {
               LeaveRequest leave = leaveRequests[index]; 
                return LeaveRequestCard(leave: leave);
              }, )
            ): const Padding(
              padding:  EdgeInsets.all(8.0),
              child: Text("No leave requests in the given range"),
            )      
      ],
    );
  }
}

class ByFilter extends StatefulWidget {
  @override
  State<ByFilter> createState() => _ByFilterState();
}

class _ByFilterState extends State<ByFilter> {
  List<LeaveRequest>leaveRequests = [];
  String selectedFilter = 'Current Month';
  bool isLoading = false;

  Future<void> _getLeaveRequestByFilter(String token, String filter) async {
  setState(() {
    isLoading = true;
  });
  const String requestLeaveUrl =
      "https://jporter.ezeelogix.com/public/api/company-search-leave-request-by-filter";

  final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  }, body: {
    'company_id': '1',
    "filter_type": filter.toLowerCase()
  });

  if (response.statusCode == 400) {
    final jsonData = json.decode(response.body);
    if (jsonData['message'] == 'No leaves found within the given range') {
      setState(() {
        leaveRequests = [];
        isLoading = false;
      });
      print('No leaves found within the given range');
    }
  } else if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    print("responsessss: $jsonData");
    if(jsonData["status"] == "Error"){
      setState(() {
        leaveRequests = [];
        isLoading = false;
      });
    }
    else{
      List<dynamic> requestedLeaves = jsonData['data']['requested_leaves'];
    setState(() {
      leaveRequests =
          requestedLeaves.map((json) => LeaveRequest.fromJson(json)).toList();
      isLoading = false;    
    });
    print(leaveRequests);
    // Handle success scenario
    }
  } else {
    print(response.statusCode);
    // Error occurred
    print('Error: ${response.reasonPhrase}');
    setState(() {
    isLoading = false;
  });
    // Handle error scenario
  }
}


  @override
  Widget build(BuildContext context) {
    final empViewModel = Provider.of<CompanyViewModel>(context);
    final token = empViewModel.token;
    Size size = MediaQuery.of(context).size;
    return  Column(
      children: [const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Select Filter",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold ,color: Theme.of(context).primaryColor),),
                DropdownButton<String>(
                  value: selectedFilter,
                  hint: const Text('Select Filter'),
                  items: <String>[
                    'Current Month',
                    'Tomorrow',
                    'Current Week',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedFilter = newValue ?? '';
                    });
                  },
                ),
              ],
            ),  
            // Text(
            //   'Selected Filter: $selectedFilter',
            //   style: const TextStyle(fontSize: 18),
            // ),
            SizedBox(
          height: 40,
          width: size.width/2,
          child: ElevatedButton(onPressed: (){
            _getLeaveRequestByFilter(token!,selectedFilter);
          },
          style: ElevatedButton.styleFrom(
             shape: RoundedRectangleBorder( //to set border radius to button
                borderRadius: BorderRadius.circular(30)
            ),
          ),
          child: isLoading? const CircularProgressIndicator(color: Colors.white,):const Text("Search")),
        ),
            leaveRequests.isNotEmpty? Expanded(child: 
            ListView.builder(
              itemCount: leaveRequests.length,
              itemBuilder: (context, index) {
               LeaveRequest leave = leaveRequests[index]; 
                return LeaveRequestCard(leave: leave);
              }, )
            ): const Text("No leave requests for the given filter")
      ],
    );
  }
}
