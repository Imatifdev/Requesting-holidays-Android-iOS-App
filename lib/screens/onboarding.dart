// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:holidays/screens/empauth/login.dart';
import 'package:holidays/screens/welcome.dart';
import 'package:holidays/widget/constants.dart';

import '../models/contentmodel.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  @override
  void initState() {
    super.initState();
    //_checkLocationPermission();
    _controller = PageController(initialPage: 0);
  }

  int currentIndex = 0;
  late PageController _controller;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    double fontSize;
    double title;
    double heading;

    // Adjust the font size based on the screen width
    if (screenWidth < 320) {
      fontSize = 13.0;
      title = 16;
      heading = 24; // Small screen (e.g., iPhone 4S)
    } else if (screenWidth < 375) {
      fontSize = 15.0;
      title = 24;

      heading = 24; // Medium screen (e.g., iPhone 6, 7, 8)
    } else if (screenWidth < 414) {
      fontSize = 17.0;
      title = 28;

      heading = 28; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else if (screenWidth < 600) {
      fontSize = 19.0;
      title = 36;

      heading = 30; // Large screen (e.g., iPhone 6 Plus, 7 Plus, 8 Plus)
    } else {
      fontSize = 22.0;
      title = 40;

      heading = 30; // Extra large screen or unknown device
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(236, 240, 243, 1),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: screenheight / 1.4,
              child: PageView.builder(
                controller: _controller,
                itemCount: contents.length,
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (_, i) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          height: screenheight / 9,
                        ),
                        Image.asset(
                          contents[i].image,
                          height: screenheight / 2.3,
                          width: screenWidth,
                        ),
                        SizedBox(
                          width: screenWidth,
                          child: Text(
                            contents[i].title,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: heading,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenheight / 40,
                        ),
                        SizedBox(
                          width: screenWidth,
                          child: Text(
                            contents[i].discription,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 2, 2, 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Center(
            //   child: ElevatedButton(
            //     onPressed: _checkLocationPermission,
            //     child: Text('Enable Location'),
            //   ),
            // ),

            SizedBox(
              height: screenheight / 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  contents.length,
                  (index) => buildDot(index, context),
                ),
              ),
            ),
            SizedBox(
              height: screenheight / 30,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => WelcomeScreen()));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: red, borderRadius: BorderRadius.circular(10)),
                height: screenheight / 15,
                width: screenWidth - 100,
                child: Center(
                  child: Text(
                    "Skip",
                    style: TextStyle(color: Colors.white, fontSize: fontSize),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: red,
      ),
    );
  }
}
