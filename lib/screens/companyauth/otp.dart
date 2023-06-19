import 'package:flutter/material.dart';
import 'package:holidays/widget/constants.dart';

class CompanyOTPScreen extends StatefulWidget {
  @override
  _CompanyOTPScreenState createState() => _CompanyOTPScreenState();
}

class _CompanyOTPScreenState extends State<CompanyOTPScreen> {
  List<FocusNode>? focusNodes;
  List<TextEditingController>? otpControllers;

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(4, (index) => FocusNode());
    otpControllers = List.generate(4, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in otpControllers!) {
      controller.dispose();
    }
    super.dispose();
  }

  void _otpNextField(String value, int index) {
    if (value.length == 1 && index < 3) {
      FocusScope.of(context).requestFocus(focusNodes![index + 1]);
    } else if (value.length == 0 && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes![index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: red,
        title: Text('OTP Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter OTP',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: otpControllers![index],
                    focusNode: focusNodes![index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    obscureText: true,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _otpNextField(value, index);
                    },
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: red),
              onPressed: () {
                String otp =
                    otpControllers!.map((controller) => controller.text).join();
                // Perform your OTP verification logic here
                print('Entered OTP: $otp');
              },
              child: Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
