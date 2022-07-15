import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vivii/globals.dart' as global;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
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

class ViviiDrawer extends StatefulWidget {
  const ViviiDrawer({Key? key}) : super(key: key);

  @override
  State<ViviiDrawer> createState() => _ViviiDrawerState();
}

class _ViviiDrawerState extends State<ViviiDrawer> {
  var _fullname = "";

  void initState() {
    super.initState();
    this.getName();
  }

  @override
  getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _fullname = pref.getString("full_name")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(35), bottomRight: Radius.circular(35)),
      child: SafeArea(
        child: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                  //color: Colors.blueAccent,
                ),
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 200.0,
                      height: 70.0,
                      margin: EdgeInsets.only(left: 30.0, top: 45.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                " Hello,",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                  ),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  _fullname,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  textAlign: TextAlign.left,
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
              ListTile(
                leading: SizedBox(
                  height: 25,
                  width: 25,
                  child: Image.asset(
                    'assets/home.png',
                    color: HexColor("073571"),
                  ),
                ),
                title: Text(
                  "Home",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.black),
                  ),
                ),
                onTap: () {
                  /* Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));*/
                },
              ),

              ListTile(
                leading: SizedBox(
                  height: 25,
                  width: 25,
                  child: Image.asset(
                    'assets/user.png',
                    color: HexColor("073571"),
                  ),
                ),
                title: Text(
                  "My Profile",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.black),
                  ),
                ),
                onTap: () {
                  /*  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyProfile()));*/
                },
              ),
              ListTile(
                leading: SizedBox(
                  height: 25,
                  width: 25,
                  child: Image.asset(
                    'assets/portfolio.png',
                    color: HexColor("073571"),
                  ),
                ),
                title: Text(
                  "Business",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.black),
                  ),
                ),
                onTap: () {
                  /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserBusinessList()));*/
                },
              ),
              ListTile(
                leading: SizedBox(
                  height: 25,
                  width: 25,
                  child: Image.asset(
                    'assets/hiring.png',
                    color: HexColor("073571"),
                  ),
                ),
                title: Text(
                  "Hiring",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.black),
                  ),
                ),
                onTap: () {
                  /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserHiringList()));*/
                },
              ),
              ListTile(
                leading: SizedBox(
                  height: 25,
                  width: 25,
                  child: Image.asset(
                    'assets/job-search.png',
                    color: HexColor("073571"),
                  ),
                ),
                title: Text(
                  "Jobs",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.black),
                  ),
                ),
                onTap: () {
                  /* Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserJobList()));*/
                },
              ),
              ListTile(
                leading: SizedBox(
                  height: 25,
                  width: 25,
                  child: Image.asset(
                    'assets/properties.png',
                    color: HexColor("073571"),
                  ),
                ),
                title: Text(
                  "Properties",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.black),
                  ),
                ),
                onTap: () {
                  /*  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserPropertyList()));*/
                },
              ),
              ListTile(
                leading: SizedBox(
                  height: 25,
                  width: 25,
                  child: Image.asset(
                    'assets/reminder.png',
                    color: HexColor("073571"),
                  ),
                ),
                title: Text(
                  "Reminder",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.black),
                  ),
                ),
                onTap: () {
                  /*  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserReminderList()));*/
                },
              ),

              //LOGOUT CODE START
              ListTile(
                leading: SizedBox(
                  height: 25,
                  width: 25,
                  child: Image.asset(
                    'assets/network.png',
                    color: HexColor("073571"),
                  ),
                ),
                title: Text(
                  "Share",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.black),
                  ),
                ),
                onTap: () async {},
                // onTap: ()=>debugPrint("Loged Out"),
              ),
              /* ListTile(
                leading: SizedBox(
                  height: 30,
                  width: 30,
                  child: Image.asset(
                    'assets/network.png',
                    color: HexColor("073571"),
                  ),
                ),
                title: Text(
                  "Plans",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.black),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserPlanList()));
                },
              ),*/

              /* ListTile(
                leading: Container(
                    height: 60,
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 40, right: 40),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            size: 35,
                            FontAwesomeIcons.facebookF,
                            color: Colors.black,
                          ),
                          Icon(
                            size: 35,
                            FontAwesomeIcons.instagram,
                            color: Colors.black,
                          ),
                          Icon(
                            size: 35,
                            FontAwesomeIcons.twitter,
                            color: Colors.black,
                          ),
                        ])),
              )*/
              //LOGOUT CODE OVER

              /*ListTile(
            contentPadding: EdgeInsets.only(left:25),
            title: Text(
                "Share App"
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => About()));
            },
          ),
          Padding(padding: EdgeInsets.only(left: 10),),
          ListTile(
            contentPadding: EdgeInsets.only(left:25),
            title: Text(
                "Rate App"
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => About()));
            },
          ),*/
            ],
          ),
        ),
      ),
    );
  }
}
