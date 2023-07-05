import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widget/constants.dart';

class CreateFinancialYear extends StatefulWidget {
  const CreateFinancialYear({super.key});

  @override
  State<CreateFinancialYear> createState() => _CreateFinancialYearState();
}

class _CreateFinancialYearState extends State<CreateFinancialYear> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(CupertinoIcons.left_chevron, color: red),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
