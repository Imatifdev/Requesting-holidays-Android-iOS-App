import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:holidays/models/stripe_service.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../viewmodel/company/compuserviewmodel.dart';
import '../../widget/constants.dart';
import 'companydashboard.dart';

class StripeScreen extends StatefulWidget {
  const StripeScreen({super.key});

  @override
  State<StripeScreen> createState() => _StripeScreenState();
}

class _StripeScreenState extends State<StripeScreen> {
  int EmpNum = 0;
  int check = 0;

  Future<int> getEmployees(String token, String id) async {
    // Define the base URL and endpoint
    final baseUrl = 'https://jporter.ezeelogix.com/public/api/';
    final endpoint = 'company-all-employees';

    // Prepare the request body
    final requestBody = {
      'company_id': id,
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
        print(responseData);
        // Create and return the ShowEmployees object
        List<dynamic> requestedLeaves = responseData["data"]['employee'];
        setState(() {
          EmpNum = requestedLeaves.length;
                 });
      } else {
        // Request failed
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      // An error occurred
      print('Error: $error');
    }

    return EmpNum;
  }
  
  @override
  Widget build(BuildContext context) {
    final comViewModel = Provider.of<CompanyViewModel>(context);
    final token = comViewModel.token;
    final user = comViewModel.user;
    final companyId = user!.id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
       if (check == 0){
        getEmployees(token!,companyId.toString());
        check = 1;
       }
      });
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Payment"),
      //   elevation: 0,
      // ),
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
              const Align(
                alignment: Alignment.topLeft,
                child:  Text("Order Summary", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
              const SizedBox(height:10),
              SizedBox(
                        width: size.width-20,
                        height: size.height / 6,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/crd.png",
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      
                                      Text(
                                        "Premium Plan",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text("\$2 ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                          Text("/ Employee"),
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        "Cancel Plan",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Plan Duration", style: TextStyle(fontSize: 18),),
                          Text("1 month", style: TextStyle(fontSize: 18, color: Colors.red),)
                        ],
                      ),
                      const SizedBox(height: 20,),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total Employees", style: TextStyle(fontSize: 18),),
                          Text(EmpNum.toString(), style: const TextStyle(fontSize: 18, color: Colors.red),)
                        ],
                      ),
                      const Divider(color: Colors.black,),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total Amount", style: TextStyle(fontSize: 18),),
                          Text("\$${EmpNum*2}", style: const TextStyle(fontSize: 18, color: Colors.red),)
                        ],
                      ),
                      const SizedBox(height: 20,),
                      ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                      ),
                      onPressed: ()async{
                        var items = [
                          {
                            "productPrice":EmpNum*2,
                            "productName":"Employees",
                            "qty":1,
                          },
                        ];
                       await StripeService.stripePaymentCheckout(
                          items, 500, 
                          context, 
                          mounted, 
                          onSuccess: (String token)
                          {
                            print("SUCCESS token:$token");
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CompanyDashBoard()));
                          },
                          onCancel: ()
                          {
                            print("CANCEL");
                          },
                          onError: (e)
                          {
                            print("ERROR ${e.toString()}");
                          }
                        
                        );
                      }, 
                      child: Text("Pay \$${EmpNum*2}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),) ),
                  
              ]
            ),
          ),
        )
      ),
      // Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //      Padding(
      //        padding: const EdgeInsets.all(8.0),
      //        child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //          children: [
      //            const Text("Your Total Employees:", style:  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
      //            Text(EmpNum.toString(), style:  TextStyle(fontSize: 22, color: Theme.of(context).primaryColor),)
      //          ],
      //        ),
      //      ),
      //      Center(
      //       child: CircleAvatar(
      //         backgroundColor: Theme.of(context).primaryColor,
      //         radius: 60,
      //         child: Text("\$${EmpNum*2}", style: const TextStyle(fontSize: 44, color: Colors.white),)),
      //      ),
      //      const SizedBox(height:10),
      //      Column(
      //        children: [
      //          Center(
      //             child: Container(
      //               decoration: BoxDecoration(
      //                 border: Border.all(
      //                   width: 2,
      //                   color: Theme.of(context).primaryColor),
      //                 borderRadius: BorderRadius.circular(10)
      //               ),
      //               child: ElevatedButton(
      //                 style: ElevatedButton.styleFrom(
      //                   backgroundColor: Colors.white,
      //                   shape: RoundedRectangleBorder(
      //                      borderRadius: BorderRadius.circular(10),
      //                   ),
      //                   padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      //                 ),
      //                 onPressed: ()async{
      //                   var items = [
      //                     {
      //                       "productPrice":EmpNum*2,
      //                       "productName":"Employees",
      //                       "qty":1,
      //                     },
      //                   ];
      //                  await StripeService.stripePaymentCheckout(
      //                     items, 500, 
      //                     context, 
      //                     mounted, 
      //                     onSuccess: (String token)
      //                     {
      //                       print("SUCCESS token:$token");
      //                       Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CompanyDashBoard()));
      //                     },
      //                     onCancel: ()
      //                     {
      //                       print("CANCEL");
      //                     },
      //                     onError: (e)
      //                     {
      //                       print("ERROR ${e.toString()}");
      //                     }
                        
      //                   );
      //                 }, 
      //                 child: Text("Pay \$${EmpNum*2}", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),) ),
      //             ),
      //           ),
      //          Text("Your total amount employees are $EmpNum and your total due payment is \$${EmpNum*2}", textAlign: TextAlign.center , style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
      //        ],
      //      ),
      //     ],
      //   ),
      // ),
    );
  }
}