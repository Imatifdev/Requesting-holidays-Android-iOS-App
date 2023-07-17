import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stripe_checkout/stripe_checkout.dart';

class StripeService{
  
  static String secretKey = "sk_test_51NPmvUD8msN6pqnywL01TNhBZWvV5ru0q4fYKYfq5JbZDMHcUwYt4l9yR5dlTj0ETWlWyZH0gkoQ57znSk7i6jtD006FtuWwGJ";
  static String publishKey = "pk_test_51NPmvUD8msN6pqny40WsTbZCH8dJgXWoAkLEsYsVKHPhyl9WodTbqW38fYWGfdiDa9OzzkIJ6knmcqGPbbBJycI000p5MvSbO0";
  
  static Future<dynamic> 
  createCheckoutSession(List<dynamic> productItems, totalAmount)async{

    final url = Uri.parse("https://api.stripe.com/v1/checkout/sessions");
    String lineItems = "";
    int index = 0;
    
    productItems.forEach((val){
      var productPrice = (val["productPrice"]*100).round().toString();
      lineItems += "&line_items[$index][price_data][product_data][name]=${val["productName"]}&line_items[$index][price_data][unit_amount]=$productPrice";
      lineItems += "&line_items[$index][price_data][currency]=USD";
      lineItems += "&line_items[$index][quantity]=${val["qty"].toString()}";
      index++;
    });
  
  final response = await http.post(
        url,
        body: "success_url=https://checkout.stripe.dev/success&mode=payment$lineItems",
        headers: {
          "Authorization": "Bearer $secretKey",
          "Content-Type" : "application/x-www-form-urlencoded"
          }
        );
        print("stripe ressssponse:");
        print(response.body);
        return json.decode(response.body)["id"];    
  }

  static Future<dynamic> 
  stripePaymentCheckout(productItems, subTotal, context, mounted,{onSuccess, onError, onCancel})async{
    final String sessionId = await createCheckoutSession(productItems, subTotal);
    print("token: $sessionId");
    final result = await redirectToCheckout(
      context: context, 
      sessionId: sessionId, 
      publishableKey: publishKey,
      successUrl: "https://checkout.stripe.dev/success",
      canceledUrl : "https://checkout.stripe.dev/cancel"
      );
    if(mounted){
      final text = result.when(
        redirected: ()=>"Redirected Succesfully" , 
        success: ()=> onSuccess(sessionId), 
        canceled:()=> onCancel(), 
        error:(e)=> onError(e), 
        );
    return text;
    }
    return sessionId;
  }

}