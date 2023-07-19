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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

// Step 4: Create a model class for subscriptions
class SubscriptionOption {
  final String name;
  final String price;
  final String duration;

  SubscriptionOption({
    required this.name,
    required this.price,
    required this.duration,
  });
}

// Step 5: Create a provider for subscription data
class SubscriptionProvider extends ChangeNotifier {
  final List<SubscriptionOption> _subscriptionOptions = [
    SubscriptionOption(name: 'Basic', price: '\$9.99', duration: '1 month'),
    SubscriptionOption(name: 'Premium', price: '\$19.99', duration: '3 months'),
    SubscriptionOption(
        name: 'Ultimate', price: '\$29.99', duration: '6 months'),
  ];

  List<SubscriptionOption> get subscriptionOptions => _subscriptionOptions;
}

class SubscriptionScreen extends StatefulWidget {
  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  Future<void> _getallLeaveRequest(String token, String id) async {
    const String requestLeaveUrl =
        'https://api.stripe.com/v1/prices/:price_1NVCiRD8msN6pqnyqgYGjCxi';

    final response = await http.post(Uri.parse(requestLeaveUrl), headers: {
      'Authorization':
          'Bearer sk_test_51NPmvUD8msN6pqnywL01TNhBZWvV5ru0q4fYKYfq5JbZDMHcUwYt4l9yR5dlTj0ETWlWyZH0gkoQ57znSk7i6jtD006FtuWwGJ',
      'Content-Type': 'application/x-www-form-urlencoded'
    }, body: {
      'price': 'price_1NVCiRD8msN6pqnyqgYGjCxi',
    });
    if (response.statusCode == 200) {
      // Leave request successful
      final jsonData = json.decode(response.body);
      print(jsonData);
      // Handle success scenario
      setState(() {
        // leaves =
        //     requestedLeaves.map((json) => CompanyLeaveRequest.fromJson(json)).toList();
        // for (CompanyLeaveRequest leave in leaves) {
        //   if (leave.leaveCurrentStatus == "Pending") {
        //     pendingLeaves.add(leave);
        //   }
        // }
        // for (CompanyLeaveRequest leave in leaves) {
        //   if (leave.leaveCurrentStatus == "Accepted") {
        //     approvedLeaves.add(leave);
        //   }
        // }
        // for (CompanyLeaveRequest leave in leaves) {
        //   if (leave.leaveCurrentStatus == "Rejected") {
        //     rejectedLeaves.add(leave);
        //   }
        // }
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Choose Subscription'),
        ),
        body: Center(
          child: ElevatedButton(onPressed: () {}, child: Text("subs")),
        )
        // ListView.builder(
        //   itemCount: subscriptionOptions.length,
        //   itemBuilder: (context, index) {
        //     final option = subscriptionOptions[index];
        //     return ListTile(
        //       title: Text(option.name),
        //       subtitle: Text('${option.price} - ${option.duration}'),
        //       onTap: () {
        //         // Step 6: Handle subscription selection and payment
        //         final selectedOption = subscriptionOptions[index];
        //         createCard("StringUserId");
        //       },
        //     );
        //   },
        // ),
        );
  }
}
