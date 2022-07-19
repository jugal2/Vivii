import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:vivii/Screens/AuthenticationModule/LoginPage.dart';
import 'package:vivii/Screens/AuthenticationModule/OTPPage.dart';
import 'package:vivii/globals.dart' as global;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.foldingCube
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    return (!regex.hasMatch(value)) ? false : true;
  }

  bool validateName(String value) {
    Pattern pattern = r'^[a-zA-Z ]+$';
    RegExp regex = new RegExp(pattern.toString());
    return (!regex.hasMatch(value)) ? false : true;
  }

  Future<void> userRegister() async {
    configLoading();
    EasyLoading.show(status: 'Loading...');

    var user_register_url = global.api_base_url + "register";
    var res = await http.post(Uri.parse(user_register_url), headers: {
      "Accept": "application/json"
    }, body: {
      "secrete": "dacb465d593bd139a6c28bb7289fa798",
      "full_name": nameController.text,
      "email": emailController.text,
      "contact": mobileController.text,
    });
    var resp = json.decode(res.body);
    if (resp['status'] == "0") {
      EasyLoading.dismiss();
      var snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'On Snap!',
          message: resp['message'],
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      /*Toast.show(resp['message'], context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);*/
    } else {
      EasyLoading.dismiss();
      var snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Congratulations!',
          message: resp['message'],
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Vivii"),
              content: Text(resp['message']),
              actions: [
                FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false);
                  },
                ),
              ],
            );
          });
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (context) => MainLogin()),
      //     (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomSheet: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: GoogleFonts.nunito(
                      color: Colors.grey.shade500, fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text(
                    " Login",
                    style: GoogleFonts.nunito(
                        color: HexColor("7c948c"), fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 50),
              child: Text(
                "Create Account",
                style: GoogleFonts.nunito(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 10),
              child: Text(
                "Connect with your friends today!",
                style: GoogleFonts.nunito(
                    color: Colors.grey.shade500, fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 40),
              child: Text(
                "Full Name",
                style: GoogleFonts.nunito(color: Colors.black, fontSize: 15),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 10),
              height: 50,
              child: TextField(
                controller: nameController,
                style: GoogleFonts.nunito(),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("ebebed")),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("ebebed")),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintStyle: GoogleFonts.nunito()),
              ),
            ),
            //////////////////////////
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 20),
              child: Text(
                "Mobile  Number",
                style: GoogleFonts.nunito(color: Colors.black, fontSize: 15),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 10),
              height: 50,
              child: TextField(
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
                controller: mobileController,
                style: GoogleFonts.nunito(),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("ebebed")),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("ebebed")),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintStyle: GoogleFonts.nunito()),
              ),
            ),
            //////////////////////////
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 20),
              child: Text(
                "Email Address",
                style: GoogleFonts.nunito(color: Colors.black, fontSize: 15),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 10),
              height: 50,
              child: TextField(
                controller: emailController,
                style: GoogleFonts.nunito(),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("ebebed")),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: HexColor("ebebed")),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintStyle: GoogleFonts.nunito()),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (nameController.text.isEmpty ||
                      validateName(nameController.text) == false) {
                    var snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'On Snap!',
                        message: "Something Went Wrong With Name",
                        contentType: ContentType.failure,
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else if (emailController.text.isEmpty ||
                      validateEmail(emailController.text) == false) {
                    var snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'On Snap!',
                        message: "Something Went Wrong With Email",
                        contentType: ContentType.failure,
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else if (mobileController.text.isEmpty ||
                      (mobileController.text.length != 10)) {
                    var snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'On Snap!',
                        message: "Something Went Wrong With Mobile",
                        contentType: ContentType.failure,
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    userRegister();
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: HexColor(global.primary_color),
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.only(left: 30, right: 30, top: 60),
                height: 50,
                child: Center(
                    child: Text(
                  "Sign Up",
                  style: GoogleFonts.nunito(fontSize: 17, color: Colors.white),
                )),
              ),
            ),
            /*Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 30),
              child: Row(
                children: [
                  Text(
                    "Already have an account?",
                    style: GoogleFonts.nunito(
                        color: Colors.grey.shade500, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text(
                      " Login",
                      style: GoogleFonts.nunito(
                          color: HexColor("00726d"), fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
