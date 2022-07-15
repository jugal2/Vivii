import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivii/Screens/AuthenticationModule/LoginPage.dart';
import 'package:vivii/Screens/HomePageModule/HomePage.dart';
import 'package:vivii/globals.dart' as global;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences pref = await SharedPreferences.getInstance();
  var user_id = pref.getString("user_id");
  global.primary_user_id = pref.getString("user_id").toString();
  var status = pref.getBool('isLoggedIn');

  var full_name = pref.getString("full_name");
  global.primary_name = pref.getString("full_name").toString();
  var email = pref.getString("email");
  var contact = pref.getString("contact");
  global.primary_contact = pref.getString("contact").toString();

  runApp(
    MaterialApp(
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        title: "ViVii",
        home: status == true ? HomePage() : LoginPage()),
  );
}
