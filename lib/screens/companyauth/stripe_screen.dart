// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:holidays/models/stripe_service.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import '../../viewmodel/company/compuserviewmodel.dart';
import '../../widget/constants.dart';
import 'companydashboard.dart';

class StripeScreen extends StatefulWidget {
  const StripeScreen({super.key});

  @override
  State<StripeScreen> createState() => _StripeScreenState();
}

class _StripeScreenState extends State<StripeScreen> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  int EmpNum = 0;
  int check = 0;
  OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.7),
      width: 2.0,
    ),
  );

  Future<int> cancelSubscription(String token, String id) async {
    // Define the base URL and endpoint
    const baseUrl = 'https://jporter.ezeelogix.com/public/api/';
    const endpoint = 'cancel-subscription';

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
        // List<dynamic> requestedLeaves = responseData["data"]['employee'];
        // setState(() {
        //   EmpNum = requestedLeaves.length;
        //          });
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

  Future<int> getEmployees(String token, String id) async {
    // Define the base URL and endpoint
    const baseUrl = 'https://jporter.ezeelogix.com/public/api/';
    const endpoint = 'company-all-employees';

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

  Future<void> sendStripeApiRequest(String token, String id) async {
    // Define the base URL and endpoint
    const baseUrl = 'https://jporter.ezeelogix.com/public/api/';
    const endpoint = 'payment';

    // Prepare the request body
    final requestBody = {
      'company_id': id,
      'card_number': cardNumber,
      'card_expiry': expiryDate,
      'card_cvc': cvvCode,
      'name': cardHolderName,
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
        final responseData = json.encode(response.body);
        print("responseeee $responseData");
        Fluttertoast.showToast(
          msg: "You have Subscribed this Plan Successfuly",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (ctx) => const CompanyDashBoard()));

        // Create and return the ShowEmployees object
        // List<dynamic> requestedLeaves = responseData["data"]['employee'];
        // setState(() {
        //   EmpNum = requestedLeaves.length;
        //          });
      } else {
        // Request failed
        final responseData = json.decode(response.body);
        print("responseeee" + responseData);
        print('Request failed with status: ${response.statusCode}');
        Fluttertoast.showToast(
          msg: "Your Package is already Subscribed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (ctx) => const CompanyDashBoard()));
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
    final user = comViewModel.user;
    final companyId = user!.id;
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //    if (check == 0){
    //     getEmployees(token!,companyId.toString());
    //     check = 1;
    //    }
    //   });
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: SizedBox(
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Row(
                children: [
                  IconButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: red) ,
                  ),
                  const Text(
                    "Subsrcibe to Plan",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              CreditCardWidget(
                glassmorphismConfig: Glassmorphism(
                    blurX: 2.0,
                    blurY: 2.0,
                    gradient:
                        const LinearGradient(colors: [Colors.red, Colors.red])),
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: false,
                onCreditCardWidgetChange:
                    (CreditCardBrand) {}, //true when you want to show cvv(back) view
                //cardType: CardType.mastercard ,
                isChipVisible: false,
              ),
              const Divider(
                color: Colors.black,
              ),
              // const Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text("Plan Duration", style: TextStyle(fontSize: 18),),
              //     Text("1 month", style: TextStyle(fontSize: 18, color: Colors.red),)
              //   ],
              // ),
              // const SizedBox(height: 20,),
              //  Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     const Text("Total Employees", style: TextStyle(fontSize: 18),),
              //     Text(EmpNum.toString(), style: const TextStyle(fontSize: 18, color: Colors.red),)
              //   ],
              // ),
              // const Divider(color: Colors.black,),
              //  Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     const Text("Total Amount", style: TextStyle(fontSize: 18),),
              //     Text("\$${EmpNum*2}", style: const TextStyle(fontSize: 18, color: Colors.red),)
              //   ],
              // ),
              // const SizedBox(height: 20,),
              CreditCardForm(
                formKey: _formKey,
                obscureCvv: true,
                obscureNumber: true,
                cardNumber: cardNumber,
                cvvCode: cvvCode,
                isHolderNameVisible: true,
                isCardNumberVisible: true,
                isExpiryDateVisible: true,
                cardHolderName: cardHolderName,
                expiryDate: expiryDate,
                themeColor: Colors.red,
                textColor: Colors.black,
                cardNumberDecoration: InputDecoration(
                  labelText: 'Number',
                  hintText: 'XXXX XXXX XXXX XXXX',
                  hintStyle: const TextStyle(color: Colors.black),
                  labelStyle: const TextStyle(color: Colors.black),
                  prefixIcon: const Icon(Icons.credit_card),
                  focusedBorder: border,
                  enabledBorder: border,
                ),
                expiryDateDecoration: InputDecoration(
                  hintStyle: const TextStyle(color: Colors.black),
                  labelStyle: const TextStyle(color: Colors.black),
                  focusedBorder: border,
                  enabledBorder: border,
                  prefixIcon: const Icon(Icons.calendar_today),
                  labelText: 'Expired Date',
                  hintText: 'XX/XX',
                ),
                cvvCodeDecoration: InputDecoration(
                  hintStyle: const TextStyle(color: Colors.black),
                  labelStyle: const TextStyle(color: Colors.black),
                  prefixIcon: const Icon(Icons.lock),
                  focusedBorder: border,
                  enabledBorder: border,
                  labelText: 'CVV',
                  hintText: 'XXX',
                ),
                cardHolderDecoration: InputDecoration(
                  hintStyle: const TextStyle(color: Colors.black),
                  labelStyle: const TextStyle(color: Colors.black),
                  prefixIcon: const Icon(Icons.person),
                  focusedBorder: border,
                  enabledBorder: border,
                  labelText: 'Card Holder',
                ),
                onCreditCardModelChange: onCreditCardModelChange,
              ),
              const SizedBox(
                height: 20,
              ),
              // SizedBox(
              //           width: size.width-20,
              //           height: size.height / 6,
              //           child: Container(
              //             decoration: BoxDecoration(
              //               color: Colors.grey[200],
              //               border: Border.all(),
              //               borderRadius: BorderRadius.circular(20),
              //             ),
              //             child: Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: Row(
              //                 children: [
              //                   Image.asset(
              //                     "assets/images/crd.png",
              //                   ),
              //                   Padding(
              //                     padding: const EdgeInsets.only(left: 8.0),
              //                     child: Column(
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       crossAxisAlignment: CrossAxisAlignment.start,
              //                       children: [

              //                         const Text(
              //                           "Premium Plan",
              //                           textAlign: TextAlign.left,
              //                           style: TextStyle(
              //                             fontSize: 18,
              //                             fontWeight: FontWeight.bold,
              //                             color: Colors.black,
              //                           ),
              //                         ),
              //                         const Row(
              //                           children: [
              //                             Text("\$2 ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              //                             Text("/ Employee"),
              //                           ],
              //                         ),
              //                         const SizedBox(height: 10),
              //                         InkWell(
              //                           onTap: ()async{
              //                             await cancelSubscription(token!, companyId.toString());
              //                           },
              //                           child: const Text(
              //                             "Cancel Plan",
              //                             textAlign: TextAlign.left,
              //                             style: TextStyle(color: Colors.red),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ),

              // ElevatedButton(
              // style: ElevatedButton.styleFrom(
              //   shape: RoundedRectangleBorder(
              //      borderRadius: BorderRadius.circular(10),
              //   ),
              //   padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              // ),
              // onPressed: ()async{
              //   var items = [
              //     {
              //       "productPrice":EmpNum*2,
              //       "productName":"Employees",
              //       "qty":1,
              //     },
              //   ];
              //  await StripeService.stripePaymentCheckout(
              //     items, 500,
              //     context,
              //     mounted,
              //     onSuccess: (String stripeToken)
              //     async{
              //       print("SUCCESSSSSSSS token:$stripeToken");
              //       await sendStripeApiRequest(token!,stripeToken,companyId.toString(), "Abdullah Ayaz");
              //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CompanyDashBoard()));
              //     },
              //     onCancel: ()
              //     {
              //       print("CANCEL");
              //     },
              //     onError: (e)
              //     {
              //       print("ERROR ${e.toString()}");
              //     }

              //   );
              // },
              // child: Text("Pay \$${EmpNum*2}", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),) ),
              //         Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Form(
              //   //  key: _formKey,
              //     child: Column(
              //       children: [
              //         TextFormField(
              //           controller: _name,
              //           decoration: const InputDecoration(
              //             prefixIcon: Icon(Icons.person),
              //             labelText: 'Name',
              //           ),
              //           validator: (value) {
              //             if (value!.isEmpty) {
              //               return 'Please enter your name';
              //             }
              //             return null;
              //           },
              //         ),
              //         const SizedBox(height: 16),
              //         TextFormField(
              //           controller: _cardNum,
              //           decoration: const InputDecoration(
              //             prefixIcon: Icon(Icons.credit_card),
              //             labelText: 'Card Number',
              //           ),
              //           validator: (value) {
              //             if (value!.isEmpty) {
              //               return 'Please enter your card number';
              //             }
              //             return null;
              //           },
              //         ),
              //         const SizedBox(height: 16),
              //         Row(
              //           children: [
              //             Expanded(
              //               child: TextFormField(
              //                 controller: _exDate,
              //                 decoration: const InputDecoration(
              //                   prefixIcon: Icon(Icons.calendar_today),
              //                   labelText: 'Expiry Date',
              //                 ),
              //                 validator: (value) {
              //                   if (value!.isEmpty) {
              //                     return 'Please enter the expiry date';
              //                   }
              //                   return null;
              //                 },
              //               ),
              //             ),
              //             const SizedBox(width: 16),
              //             Expanded(
              //               child: TextFormField(
              //                 controller: _cvc,
              //                 //maxLength: 3,
              //                 decoration: const InputDecoration(
              //                   prefixIcon: Icon(Icons.lock),
              //                   labelText: 'CVC',
              //                 ),
              //                 validator: (value) {
              //                   if (value!.isEmpty) {
              //                     return 'Please enter the CVC';
              //                   }
              //                   if (value.length != 3) {
              //                     return 'CVC must be 3 digits';
              //                   }
              //                   return null;
              //                 },
              //               ),
              //             ),
              //           ],
              //         ),
              //         const SizedBox(height: 32),
              //
              //       ],
              //     ),
              //   ),
              // ),
              //
              InkWell(
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (ctx) => WelcomeScreen()));
                  if (_formKey.currentState!.validate()) {
                    print(companyId);
                    sendStripeApiRequest(token!, companyId.toString());
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: red, borderRadius: BorderRadius.circular(10)),
                  height: size.height / 15,
                  width: size.width - 100,
                  child: const Center(
                    child: Text(
                      "Subscribe",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              //  ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20)
              //   ),
              //         onPressed: () {
              //           if (_formKey.currentState!.validate()) {
              //             print(companyId);
              //             sendStripeApiRequest(token!, companyId.toString());
              //           }
              //         },
              //         child: const Text('Pay'),
              //       ),
            ]),
          ),
        )),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
