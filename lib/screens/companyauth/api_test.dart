import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/company/compuserviewmodel.dart';

class ApiTest extends StatefulWidget {
  const ApiTest({super.key});

  @override
  State<ApiTest> createState() => _ApiTestState();
}

class _ApiTestState extends State<ApiTest> {
  @override
  Widget build(BuildContext context) {
    final empViewModel = Provider.of<CompanyViewModel>(context);
    final token = empViewModel.token;
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