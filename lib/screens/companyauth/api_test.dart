import 'package:flutter/material.dart';

class ApiTest extends StatefulWidget {
  const ApiTest({super.key});

  @override
  State<ApiTest> createState() => _ApiTestState();
}

class _ApiTestState extends State<ApiTest> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(child: SizedBox(
        width: size.width,
        child: Column(
          children: [
            ElevatedButton(onPressed: (){}, child: const Text("Search api") )
          ],
        ),
      )),
    );
  }
}