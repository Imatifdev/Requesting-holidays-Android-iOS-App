import 'package:flutter/material.dart';

class EmpHome extends StatefulWidget {
  const EmpHome({super.key});

  @override
  State<EmpHome> createState() => _EmpHomeState();
}

class _EmpHomeState extends State<EmpHome> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(child: SizedBox(
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: (){}, icon: const Icon(Icons.menu)),
                    const Text("Home"),
                    SizedBox(width: size.width/8.5,)
                  ],
                ),
              ),
              const Row(
                children: [
                  Text("Hi Jennefir", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                ],
              ),
              const Row(children: [
               Text("Good Morining")
              ],),
              const Text("Leave Requests", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              Row(
                children: [
                  Container(),
                  Container(),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}