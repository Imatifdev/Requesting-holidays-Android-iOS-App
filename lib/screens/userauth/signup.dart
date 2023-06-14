// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../widget/constants.dart';
import '../home.dart';
import 'login.dart';
import 'package:velocity_x/velocity_x.dart';

class SignupPage extends StatefulWidget {
  static const idScreen = "signup-up";
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isSigningUp = false;
  bool obsCheck1 = false;
  bool obsCheck2 = false;
  PhoneNumber number = PhoneNumber(isoCode: 'PK');
  String errMsg = "";

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Icon(CupertinoIcons.left_chevron, color: red),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    "Sign up",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ).pSymmetric(h: 20),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Create an account here",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ).pSymmetric(h: 20),
                  const SizedBox(
                    height: 44,
                  ),
                  MyTextformfield(
                    label: "First Name",
                    controller: _fNameController,
                    textInputType: TextInputType.name,
                    isPass: false,
                    hintText: "First Name",
                    icon: Icon(Icons.person_2_outlined, color: red),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextformfield(
                    label: "Last Name",
                    controller: _lNameController,
                    textInputType: TextInputType.name,
                    isPass: false,
                    hintText: "Last Name",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                    icon: Icon(Icons.person_2_outlined, color: red),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextformfield(
                    label: "Email",
                    controller: _emailController,
                    textInputType: TextInputType.emailAddress,
                    isPass: false,
                    icon: Icon(Icons.email_outlined, color: red),
                    hintText: "abc@gmail.com ",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      } else if (!value.contains("@")) {
                        return "enter a valid email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      print(number.phoneNumber);
                    },
                    onInputValidated: (bool value) {
                      print(value);
                    },
                    selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    ),
                    inputBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius:
                          BorderRadius.circular(50), // Set border radius here
                    ),
                    inputDecoration: InputDecoration(
                      hintText: "Enter Your Number",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorTextStyle: TextStyle(color: Colors.black),
                    initialValue: number,
                    textFieldController: _phoneController,
                    formatInput: true,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    onSaved: (PhoneNumber number) {
                      print('On Saved: $number');
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordController,
                    decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      width: 1.0, color: Colors.black),
                                ),
                              ),
                              child: const Icon(
                                Icons.lock_open_rounded,
                                color: red,
                              )),
                        ),
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obsCheck1 = !obsCheck1;
                              });
                            },
                            icon: Icon(obsCheck1
                                ? Icons.visibility
                                : Icons.visibility_off))),
                    obscureText: !obsCheck1,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (ctx) => HomePage()));
                        }
                        ;
                      },
                      child: Text(
                        "Signup ",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Text(
                    errMsg,
                    style: TextStyle(color: Colors.red),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: const Text(
                      'Already have an account? Login up here',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ).pSymmetric(h: 10),
          ),
        ),
      ),
    );
  }
}

class MyTextformfield extends StatelessWidget {
  final TextEditingController controller;
  final bool isPass;
  final String label;
  final String hintText;
  final TextInputType textInputType;
  final TextInputAction? action;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator? validator;
  final Icon icon;
  const MyTextformfield(
      {super.key,
      required this.controller,
      required this.isPass,
      required this.hintText,
      required this.textInputType,
      this.action,
      this.onChanged,
      this.validator,
      required this.icon,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        keyboardType: textInputType,
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(width: 1.0, color: Colors.black),
                  ),
                ),
                child: icon,
              ),
            ),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            labelText: label),
        validator: validator);
  }
}
