import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:vivii/Screens/AuthenticationModule/OTPPage.dart';
import 'package:vivii/Screens/AuthenticationModule/RegisterPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 50),
              child: Text(
                "Hi,Welcome Back!",
                style: GoogleFonts.nunito(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 10),
              child: Text(
                "Hello again,you've been missed!",
                style: GoogleFonts.nunito(
                    color: Colors.grey.shade500, fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 40),
              child: Text(
                "Mobile Number",
                style: GoogleFonts.nunito(color: Colors.black, fontSize: 15),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 10),
              height: 50,
              child: TextField(
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: HexColor("00726d"),
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.only(left: 30, right: 30, top: 60),
                height: 50,
                child: Center(
                    child: Text(
                  "Login",
                  style: GoogleFonts.nunito(fontSize: 17, color: Colors.white),
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 30),
              child: Row(
                children: [
                  Text(
                    "Don't have an account?",
                    style: GoogleFonts.nunito(
                        color: Colors.grey.shade500, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text(
                      " Sign Up",
                      style: GoogleFonts.nunito(
                          color: HexColor("00726d"), fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
