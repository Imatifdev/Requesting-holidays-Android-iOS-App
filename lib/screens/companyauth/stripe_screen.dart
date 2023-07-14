import 'package:flutter/material.dart';
import 'package:holidays/models/stripe_service.dart';

class StripeScreen extends StatefulWidget {
  const StripeScreen({super.key});

  @override
  State<StripeScreen> createState() => _StripeScreenState();
}

class _StripeScreenState extends State<StripeScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: (){
            print("All Ok");
          }, child: const Text("test")),
          Center(
            child: ElevatedButton(
              onPressed: ()async{
                var items = [
                  {
                    "productPrice":4,
                    "productName":"Apple",
                    "qty":5,
                  },
                  {
                    "productPrice":5,
                    "productName":"Pineapple",
                    "qty":10,
                  }
                ];
               await StripeService.stripePaymentCheckout(
                  items, 500, 
                  context, 
                  mounted, 
                  onSuccess: (String token)
                  {
                    print("SUCCESS token:$token");
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
              //print("Session Token: "+sessionToken);
              }, 
              child: const Text("Stripe") ),
          ),
        ],
      ),
    );
  }
}