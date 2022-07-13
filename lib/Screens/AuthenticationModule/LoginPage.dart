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
  FocusNode _focusNode = FocusNode();
  Color _color = HexColor("f5f5f5");

  @override
  void initState() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _color = HexColor("fece84");
        });
      } else {
        setState(() {
          _color = HexColor("f5f5f5");
        });
      }
    });
  }

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
              padding: const EdgeInsets.only(left: 40.0, top: 300),
              child: Text(
                "Hey,",
                style: GoogleFonts.nunito(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Text(
                "Login Now.",
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
                    "If you are new /",
                    style: GoogleFonts.nunito(
                        color: Colors.grey.shade500, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()));
                    },
                    child: Text(
                      " Create New",
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
              child: TextField(
                style: GoogleFonts.nunito(),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    fillColor: _color,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "Mobie Number",
                    hintStyle: GoogleFonts.nunito()),
                focusNode: _focusNode,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0, top: 20),
              child: Row(
                children: [
                  Text(
                    "Forgot Passcode? /",
                    style: GoogleFonts.nunito(
                        color: Colors.grey.shade500, fontSize: 16),
                  ),
                  Text(
                    " Reset",
                    style:
                        GoogleFonts.nunito(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OTPPage()));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: HexColor("8bcac1"),
                    borderRadius: BorderRadius.circular(20)),
                margin: EdgeInsets.only(left: 40, right: 40, top: 60),
                height: 60,
                child: Center(
                    child: Text(
                  "Login",
                  style: GoogleFonts.nunito(fontSize: 20, color: Colors.black),
                )),
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
