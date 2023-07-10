// ignore_for_file: prefer_const_literals_to_create_immutables, unused_field, prefer_const_constructors, use_build_context_synchronously, unused_import

import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:holidays/screens/companyauth/forgotpass.dart';
import 'package:holidays/screens/empauth/signup.dart';
import 'package:provider/provider.dart';
import '../../../widget/constants.dart';

import 'package:velocity_x/velocity_x.dart';
import '../../viewmodel/company/compuserviewmodel.dart';
import '../../widget/popuploader.dart';
import '../empauth/dashboard.dart';
import '../empauth/home.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CompanyLoginPage extends StatefulWidget {
  static const routeName = "login";
  @override
  _CompanyLoginPageState createState() => _CompanyLoginPageState();
}

class _CompanyLoginPageState extends State<CompanyLoginPage> {
  bool obsCheck = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(CupertinoIcons.left_chevron, color: red)),
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
                    "Sign In",
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                  ).pSymmetric(h: 20),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Welcome Back",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ).pSymmetric(h: 20),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: const Text(
                        "Company Pannel",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ).pSymmetric(h: 80),
                  const SizedBox(
                    height: 44,
                  ),
                  TextFormField(
                    //keyboardType: TextInputType.visiblePassword,
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                right:
                                    BorderSide(width: 1.0, color: Colors.black),
                              ),
                            ),
                            child: const Icon(
                              Icons.email_outlined,
                              color: red,
                            )),
                      ),
                      labelText: 'Email Address',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
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
                              child: Icon(
                                Icons.lock_open_rounded,
                                color: red,
                              )),
                        ),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obsCheck = !obsCheck;
                              });
                            },
                            icon: Icon(
                              obsCheck
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ))),
                    obscureText: !obsCheck,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => CompanyForgitPassword()));
                        },
                      )),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        final email = _emailController.text;
                        final password = _passwordController.text;

                        Provider.of<CompanyViewModel>(context, listen: false)
                            .performLogin(email, password, context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: red,
                        padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ).pSymmetric(h: 10),
          ),
        ),
      ),
    );
  }
}
