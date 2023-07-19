// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:provider/provider.dart';

// // Step 4: Create a model class for subscriptions
// class SubscriptionOption {
//   final String name;
//   final String price;
//   final String duration;
//   final String priceId; // Add the Price ID property

//   SubscriptionOption({
//     required this.name,
//     required this.price,
//     required this.duration,
//     required this.priceId, // Initialize the Price ID
//   });
// }

// // Step 5: Create a provider for subscription data
// class SubscriptionProvider extends ChangeNotifier {
//   final List<SubscriptionOption> _subscriptionOptions = [
//     SubscriptionOption(
//       name: 'Basic',
//       price: '\$9.99',
//       duration: '1 month',
//       priceId: 'price_1NVCiRD8msN6pqnyqgYGjCxi', // Replace with the Price ID of your Basic plan
//     ),
//   ];

//   List<SubscriptionOption> get subscriptionOptions => _subscriptionOptions;
// }

// void main() {
//   Stripe.publishableKey = 'YOUR_PUBLISHABLE_KEY';

//   runApp(
//     ChangeNotifierProvider(
//       create: (_) => SubscriptionProvider(),
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Stripe Subscription Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: SubscriptionScreen(),
//     );
//   }
// }

// class SubscriptionScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
//     final subscriptionOptions = subscriptionProvider.subscriptionOptions;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Choose Subscription'),
//       ),
//       body: ListView.builder(
//         itemCount: subscriptionOptions.length,
//         itemBuilder: (context, index) {
//           final option = subscriptionOptions[index];
//           return ListTile(
//             title: Text(option.name),
//             subtitle: Text('${option.price} - ${option.duration}'),
//             onTap: () {
//               // Step 6: Handle subscription selection and payment
//               final selectedOption = subscriptionOptions[index];
//               subscribeToPlan(selectedOption.priceId);
//             },
//           );
//         },
//       ),
//     );
//   }

//   // Step 6: Subscribe to a plan
//   Future<void> subscribeToPlan(String priceId) async {
//     final paymentMethod = await Stripe.instance.createPaymentMethod(
//       params: PaymentMethodParams.card(paymentMethodData: PaymentMethodData())
//     ) ;
//     //reate(

//     //);

//     final subscription = await Stripe.instance.subscriptions.create(
//       SubscriptionParams.customer(
//         paymentMethod: paymentMethod.id,
//         price: priceId,
//       ),
//     );

//     if (subscription.status == SubscriptionStatus.Active) {
//       // Subscription successful, handle success scenario
//       print('Subscription successful');
//     } else {
//       // Subscription failed, handle error scenario
//       print('Subscription failed');
//     }
//   }
// }
























































































// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;


// // Step 4: Create a model class for subscriptions
// class SubscriptionOption {
//   final String name;
//   final String price;
//   final String duration;

//   SubscriptionOption({
//     required this.name,
//     required this.price,
//     required this.duration,
//   });
// }

// // Step 5: Create a provider for subscription data
// class SubscriptionProvider extends ChangeNotifier {
//   final List<SubscriptionOption> _subscriptionOptions = [
//     SubscriptionOption(name: 'Basic', price: '\$9.99', duration: '1 month'),
//     SubscriptionOption(name: 'Premium', price: '\$19.99', duration: '3 months'),
//     SubscriptionOption(name: 'Ultimate', price: '\$29.99', duration: '6 months'),
//   ];

//   List<SubscriptionOption> get subscriptionOptions => _subscriptionOptions;
// }



// class SubscriptionScreen extends StatefulWidget {
//   @override
//   State<SubscriptionScreen> createState() => _SubscriptionScreenState();
// }

// class _SubscriptionScreenState extends State<SubscriptionScreen> {
//   Future<void> _getallLeaveRequest(String token, String id) async {
//     const String requestLeaveUrl =
//         'https://api.stripe.com/v1/prices/:price_1NVCiRD8msN6pqnyqgYGjCxi';

//     final response = await http.post(
//       Uri.parse(requestLeaveUrl), 
//       headers: {
//       'Authorization': 'Bearer sk_test_51NPmvUD8msN6pqnywL01TNhBZWvV5ru0q4fYKYfq5JbZDMHcUwYt4l9yR5dlTj0ETWlWyZH0gkoQ57znSk7i6jtD006FtuWwGJ',
//       'Content-Type': 'application/x-www-form-urlencoded'
//     }, 
//     body: {
//         'price': 'price_1NVCiRD8msN6pqnyqgYGjCxi',
//       }
//     );
//     if (response.statusCode == 200) {
//       // Leave request successful
//       final jsonData = json.decode(response.body);
//       print(jsonData);
//       // Handle success scenario
//       setState(() {
//         // leaves =
//         //     requestedLeaves.map((json) => CompanyLeaveRequest.fromJson(json)).toList();
//         // for (CompanyLeaveRequest leave in leaves) {
//         //   if (leave.leaveCurrentStatus == "Pending") {
//         //     pendingLeaves.add(leave);
//         //   }
//         // }
//         // for (CompanyLeaveRequest leave in leaves) {
//         //   if (leave.leaveCurrentStatus == "Accepted") {
//         //     approvedLeaves.add(leave);
//         //   }
//         // }
//         // for (CompanyLeaveRequest leave in leaves) {
//         //   if (leave.leaveCurrentStatus == "Rejected") {
//         //     rejectedLeaves.add(leave);
//         //   }
//         // }
//       });
//     } else {
//       print(response.statusCode);
//       // Error occurred
//       print('Error: ${response.reasonPhrase}');
//       // Handle error scenario
//     }
//   }

// @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Choose Subscription'),
//       ),
//       body: Center(
//         child: ElevatedButton(onPressed: (){}, child: Text("subs")),
//       )
//       // ListView.builder(
//       //   itemCount: subscriptionOptions.length,
//       //   itemBuilder: (context, index) {
//       //     final option = subscriptionOptions[index];
//       //     return ListTile(
//       //       title: Text(option.name),
//       //       subtitle: Text('${option.price} - ${option.duration}'),
//       //       onTap: () {
//       //         // Step 6: Handle subscription selection and payment
//       //         final selectedOption = subscriptionOptions[index];
//       //         createCard("StringUserId");
//       //       },
//       //     );
//       //   },
//       // ),
//     );
//   }
// }


























































































































// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_stripe_payment/flutter_stripe_payment.dart';
import 'package:holidays/models/stripe_service.dart';


class MonthlyPaymentScreen extends StatefulWidget {
  @override
  _MonthlyPaymentScreenState createState() => _MonthlyPaymentScreenState();
}

class _MonthlyPaymentScreenState extends State<MonthlyPaymentScreen> {
  // Replace these with your actual Stripe credentials
  final String stripePublishableKey = StripeService.publishKey;

  // Initialize the Stripe plugin
  final stripePayment = FlutterStripePayment();

  @override
  void initState() {
    super.initState();

    // Initialize Stripe with your publishable key
   // stripePayment.setStripeSettings(stripePublishableKey);
  }

  // Method to handle the payment process
  Future<void> _handlePayment() async {
    stripePayment.setStripeSettings(stripePublishableKey);
    try {
      // Show a loading indicator while processing the payment
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Replace 'price_id' with the ID of your Stripe Price for the product
      final paymentMethodId = await stripePayment.addPaymentMethod();

      // Create a PaymentIntent on your backend server
      final paymentIntentClientSecret = await createPaymentIntent(paymentMethodId.toString());

      // Confirm the PaymentIntent to complete the payment
      await stripePayment.confirmPaymentIntent(paymentIntentClientSecret,"",100.2,false);

      // Payment success, you can add your success handling code here
      // For example, navigating to a success screen or showing a success dialog.
      Navigator.pop(context); // Dismiss the loading indicator
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Payment successful!'),
      ));
    } catch (e) {
      // Handle payment errors here
      Navigator.pop(context); // Dismiss the loading indicator
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Payment failed: ${e.toString()}'),
      ));
    }
  }

  // You need to implement this method on your backend server
  Future<String> createPaymentIntent(String paymentMethodId) async {
    // Make an API call to your backend to create a PaymentIntent
    // using the Stripe Prices API and return the client secret
    // for the PaymentIntent.
    // Example:
    // final response = await http.post('YOUR_BACKEND_ENDPOINT', body: {
    //   'paymentMethodId': paymentMethodId,
    // });
    // return response.body;
    throw UnimplementedError('createPaymentIntent() not implemented');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Payment'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _handlePayment,
          child: const Text('Pay Monthly'),
        ),
      ),
    );
  }
}
