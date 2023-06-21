import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:holidays/screens/companyauth/resetpass.dart';

import '../../widget/constants.dart';
import '../../widget/custombutton.dart';
import '../../widget/textinput.dart';

class CompanyForgitPassword extends StatefulWidget {
  static const String idScreen = 'forgotpass';

  const CompanyForgitPassword({super.key});

  @override
  State<CompanyForgitPassword> createState() => _CompanyForgitPasswordState();
}

class _CompanyForgitPasswordState extends State<CompanyForgitPassword> {
  final TextEditingController _email = TextEditingController();
  //key for handling Auth
  final GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();

  void _showetoast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Form(
            key: formGlobalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 300,
                ),
                const Text(
                  "Reset Your Password",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFieldInput(
                    validator: (value) {
                      if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    textEditingController: _email,
                    hintText: "Enter Your Email",
                    textInputType: TextInputType.visiblePassword),
                const SizedBox(
                  height: 30,
                ),
                MyCustomButton(
                    buttontextcolr: Colors.white,
                    title: "Send Email Request",
                    borderrad: 25,
                    onaction: () {
                      if (formGlobalKey.currentState!.validate()) {
                        _showetoast("Details Send to your email");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => ForgotPasswordScreen(
                                      email: _email.text,
                                    )));
                      } else
                        _showetoast("Please a valid email address");
                    },
                    color1: red,
                    color2: red,
                    width: MediaQuery.of(context).size.width - 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
