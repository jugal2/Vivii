import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:vivii/Screens/AuthenticationModule/LoginPage.dart';
import 'package:vivii/Screens/AuthenticationModule/OTPPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
              padding: const EdgeInsets.only(left: 40.0, top: 150),
              child: Text(
                "Register,",
                style: GoogleFonts.nunito(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Text(
                "Fill The Details Below.",
                style: GoogleFonts.nunito(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0, top: 10),
              child: Row(
                children: [
                  Text(
                    "If you are already a customer /",
                    style: GoogleFonts.nunito(
                        color: Colors.grey.shade500, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text(
                      " Sign in",
                      style:
                          GoogleFonts.nunito(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 40, right: 40, top: 30),
              height: 50,
              child: Text("Name"),
              color: HexColor("fece84"),
            ),
            Container(
              margin: EdgeInsets.only(left: 40, right: 40, top: 20),
              height: 50,
              child: Text("Contact"),
              color: HexColor("fece84"),
            ),
            Container(
              margin: EdgeInsets.only(left: 40, right: 40, top: 20),
              height: 50,
              child: Text("Email"),
              color: HexColor("fece84"),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OTPPage()));
              },
              child: Container(
                margin: EdgeInsets.only(left: 40, right: 40, top: 60),
                height: 60,
                child: Text("Submit"),
                color: HexColor("8bcac1"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Text(
                    "Skip Now",
                    style: GoogleFonts.nunito(
                        color: Colors.grey.shade700, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
