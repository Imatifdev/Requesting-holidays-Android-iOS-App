import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../widget/constants.dart';

class EditEmployee extends StatefulWidget {
  const EditEmployee({super.key});

  @override
  State<EditEmployee> createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameFirst = TextEditingController();
  final TextEditingController _nameLast = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _totalLeaves = TextEditingController();
  int selectedDay = 0;
  Map<int, bool> selectedDays = {};
  void selectDay(int day) {
  setState(() {
    if (selectedDays.containsKey(day)) {
      selectedDays.remove(day);
      print(selectedDay);
    } else {
      selectedDays[day] = true;
    }
  });
}
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: appbar,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appbar,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              CupertinoIcons.left_chevron,
              color: Colors.black,
            )),
      ),
      body:SafeArea(
        child: SizedBox(
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  "All Employees",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ).pOnly(left: 24),
                const SizedBox(
                  height: 25,
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      TextFormField(
                      controller: _nameFirst,
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
                                  Icons.person,
                                  color: red,
                                )),
                          ),
                          labelText: 'First Name',
                          ),
                      obscureText: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                      TextFormField(
                      controller: _nameLast,
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
                                  Icons.person,
                                  color: red,
                                )),
                          ),
                          labelText: 'Last Name',
                          ),
                      obscureText: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                      TextFormField(
                      controller: _phone,
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
                                  Icons.phone_android_rounded,
                                  color: red,
                                )),
                          ),
                          labelText: 'Mobile Number',
                          ),
                      obscureText: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        return null;
                      },
                    ),
                      TextFormField(
                      controller: _email,
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
                                  Icons.mail,
                                  color: red,
                                )),
                          ),
                          labelText: 'Email',
                          ),
                      obscureText: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                      TextFormField(
                      controller: _totalLeaves,
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
                                  Icons.edit_note_sharp,
                                  color: red,
                                )),
                          ),
                          labelText: 'Total Leaves',
                          ),
                      obscureText: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter total leaves';
                        }
                        return null;
                      },
                    ),
                    ],),
                  ) 
                ),
                const SizedBox(height: 20,),
                const Text("Working Days", style: TextStyle(fontSize: 18),),
                const SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    dayCard('SUN', 1, selectDay),
                    dayCard("MON", 2, selectDay),
                    dayCard("TUE", 3, selectDay),
                    dayCard("WED", 4, selectDay),
                    dayCard("THUR", 5, selectDay),
                    dayCard("FRI", 6, selectDay),
                    dayCard("SAT", 7, selectDay)
                  ],
                ),
              const  SizedBox(height: 10,),
              Center(
                child: ElevatedButton(
                  onPressed: (){}, 
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10)
                  ),
                  child: const Text("Save Employee")),
              )  
            ],
          ),
        ) )
    );
  }

  Container dayCard(String name, int value, Function(int) onSelectDay) {
  final isSelected = selectedDays.containsKey(value) && selectedDays[value] == true;

  return Container(
    decoration: BoxDecoration(
      border: Border.all(width: 1),
      borderRadius: BorderRadius.circular(15),
      color: isSelected ? Colors.blue : Colors.transparent,
    ),
    child: Padding(
      padding: const EdgeInsets.all(3.0),
      child: Column(
        children: [
          Text(name),
          Radio(
            value: value,
            groupValue: null,
            onChanged: (newValue) {
              onSelectDay(newValue!);
            },
          ),
        ],
      ),
    ),
  );
}

}