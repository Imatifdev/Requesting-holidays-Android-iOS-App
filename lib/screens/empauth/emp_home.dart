import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:holidays/screens/companyauth/approved_leaves.dart';
import 'package:holidays/screens/companyauth/companydashboard.dart';
import 'package:holidays/screens/empauth/all_leaves_screen.dart';
import 'package:holidays/screens/empauth/approved_leaves_screen.dart';
import 'package:holidays/screens/empauth/pending_leaves.dart';

class EmpHome extends StatefulWidget {
  const EmpHome({super.key});

  @override
  State<EmpHome> createState() => _EmpHomeState();
}

class _EmpHomeState extends State<EmpHome> with SingleTickerProviderStateMixin{
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(color: Colors.red),
        unselectedLabelStyle: const TextStyle(color: Colors.black),
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){},child: const Icon(Icons.add)),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Row(
                  children: [
                    Text("Hi Jennefir", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  ],
                ),
                const Row(children: [
                 Text("Good Morining", style: TextStyle(color: Colors.grey),)
                ],),
                const SizedBox(height: 10,),
                SizedBox(
                  width: size.width,
                  height: size.height/6,
                  child: Expanded(child: 
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                       const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Welcome", textAlign: TextAlign.left ,style: TextStyle(fontSize:16, fontWeight: FontWeight.bold, color:Colors.white),),
                            Text("View all your leaves\n and request more", textAlign: TextAlign.left, style: TextStyle(color:Colors.white))
                          ],
                        ),
                        Image.asset("assets/images/holiday.png",color: Colors.white,)
                      ]),
                    ),
                    ))),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Leave Requests", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                          Text("View all your requested leaves status")
                        ],
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AllLeavesScreen(),));
                      },
                      child: Container(
                        height: (size.width-50)/2,
                        width: (size.width-50)/2,
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.list_alt_outlined, size: 50, color: Colors.white,),
                            Text("All Leaves", style: TextStyle(fontSize: 16, color: Colors.white),)
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PendingLeavesScreen(),));
                      },
                      child: Container(
                        height: (size.width-50)/2,
                        width: (size.width-50)/2,
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pending_actions_rounded , size: 50, color: Colors.white,),
                            Text("Pending Leaves", style: TextStyle(fontSize: 16, color: Colors.white),)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ApprovedLeavesScreen()));
                      },
                      child: Container(
                        height: (size.width-50)/2,
                        width: (size.width-50)/2,
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline, size: 50, color: Colors.white,),
                            Text("Approved Leaves", style: TextStyle(fontSize: 16, color: Colors.white),)
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => RejectedApplications(),));
                      },
                      child: Container(
                        height: (size.width-50)/2,
                        width: (size.width-50)/2,
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cancel_outlined , size: 50, color: Colors.white,),
                            Text("Rejected Leaves", style: TextStyle(fontSize: 16, color: Colors.white),)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                  ],
                ),
              ),
              
            ],
          ),
        ),
      )),
    );
  }
}