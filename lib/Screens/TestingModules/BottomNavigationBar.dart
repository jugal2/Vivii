import 'package:flutter/material.dart';
import 'package:vivii/Screens/AuthenticationModule/LoginPage.dart';
import 'package:vivii/Screens/AuthenticationModule/OTPPage.dart';
import 'package:vivii/Screens/AuthenticationModule/RegisterPage.dart';
import 'package:vivii/Screens/HomePageModule/MainPage.dart';

class MainBottomClass extends StatefulWidget {
  const MainBottomClass({Key? key}) : super(key: key);

  @override
  _MainBottomClassState createState() => _MainBottomClassState();
}

class _MainBottomClassState extends State<MainBottomClass> {
  int selectedIndex = 0;

  //list of widgets to call ontap
  final widgetOptions = [
    new MainPage(),
    new RegisterPage(),
    new LoginPage(),
    new OTPPage(mobile_no: "8849346919"),
    new RegisterPage(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final widgetTitle = ["Chat", "Status", "Call"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widgetTitle.elementAt(selectedIndex)),
      ),
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.messenger,
                color: Colors.blue,
              ),
              label: "Chat"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.stacked_line_chart_outlined,
                color: Colors.blue,
              ),
              label: "Status"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.call,
                color: Colors.blue,
              ),
              label: "Call"),
        ],
        currentIndex: selectedIndex,
        fixedColor: Colors.red,
        onTap: onItemTapped,
        selectedLabelStyle: TextStyle(color: Colors.red, fontSize: 20),
        unselectedFontSize: 16,
        selectedIconTheme:
            IconThemeData(color: Colors.blue, opacity: 1.0, size: 30.0),
        unselectedItemColor: Colors.black,
        unselectedLabelStyle: TextStyle(fontSize: 18, color: Colors.pink),
      ),
    );
  }
}
