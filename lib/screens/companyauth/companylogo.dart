// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:holidays/screens/companyauth/companydashboard.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/company/compuserviewmodel.dart';
import '../../widget/constants.dart';
import 'package:velocity_x/velocity_x.dart';

class CompanyLogo extends StatefulWidget {
  const CompanyLogo({super.key});

  @override
  State<CompanyLogo> createState() => _CompanyLogoState();
}

class _CompanyLogoState extends State<CompanyLogo> {
  XFile? pickedImage;
  String pickedImageName = "";
  String errMsg = "";
  bool isLoading = false;

  Future<XFile?> pickImageFromGallery() async {
    final picker = ImagePicker();
    pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        pickedImageName = pickedImage!.name;
        pickedImage = XFile(pickedImage!.path);
      });
      return XFile(pickedImage!.path);
    }
    return null;
  }

  Future<void> _changeLogo(String token, String companyId, XFile img) async {
    setState(() {
      isLoading = true;
    });
    String filePath = img.path;
    var requestLeaveUrl =
        'https://jporter.ezeelogix.com/public/api/company-change-logo';

    var request = http.MultipartRequest('POST', Uri.parse(requestLeaveUrl));
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    var multipartFile = await http.MultipartFile.fromPath('image', filePath);
    request.files.add(multipartFile);

    request.fields['company_id'] = companyId;

    var response = await request.send();

    if (response.statusCode == 200) {
      // Leave request successful
      var responseData = await response.stream.bytesToString();
      var jsonData = json.decode(responseData);
      print(jsonData);
      // Handle success scenario
      setState(() {
        isLoading = false;
        Fluttertoast.showToast(
            msg: "Logo Changed Succesfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const CompanyDashBoard(),
          ),
          (route) => false);
    } else {
      var responseData = await response.stream.bytesToString();
      var jsonData = json.decode(responseData);
      print(jsonData);
      print(response.statusCode);
      // Error occurred
      setState(() {
        isLoading = false;
        errMsg = 'Error: ${response.reasonPhrase}';
      });
      print('Error: ${response.reasonPhrase}');
      // Handle error scenario
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final comViewModel = Provider.of<CompanyViewModel>(context);
    final token = comViewModel.token;
    final companyViewModel = Provider.of<CompanyViewModel>(context);
    final user = companyViewModel.user;
    final companyId = user!.id;
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          leading: Icon(CupertinoIcons.left_chevron, color: red),
        ),
        body: SafeArea(
            child: SizedBox(
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Change Logo",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ).pOnly(left: 20),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    InkWell(
                      onTap: () {
                        pickImageFromGallery();
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        child: Center(
                          child: Container(
                            height: 50,
                            width: 120,
                            child: Row(
                              children: [
                                Icon(Icons.upload),
                                Text("Choose file")
                              ],
                            ),
                          ),
                        ).pOnly(left: 5),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          pickImageFromGallery();
                        },
                        child: Container(
                          height: size.height / 15,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                              child: pickedImageName == ""
                                  ? const Text("Select Image")
                                  : Text(
                                      pickedImageName,
                                      textAlign: TextAlign.center,
                                    )),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.all(15)),
                      onPressed: () {
                        if (pickedImageName != "") {
                          _changeLogo(token!, companyId.toString(),
                              pickedImage as XFile);
                        } else {
                          setState(() {
                            errMsg = "Please select an image";
                          });
                        }
                      },
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Change Logo",
                              style: TextStyle(fontSize: 14),
                            )),
                ).pOnly(left: 20),
                Text(
                  errMsg,
                  style: const TextStyle(color: Colors.red),
                ).pOnly(left: 20)
              ],
            ),
          ),
        )));
  }
}
