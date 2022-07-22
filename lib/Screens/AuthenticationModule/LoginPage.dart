import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivii/Screens/AuthenticationModule/OTPPage.dart';
import 'package:vivii/Screens/AuthenticationModule/RegisterPage.dart';
import 'package:http/http.dart' as http;
import 'package:vivii/Screens/HomePageModule/MainPage.dart';
import 'dart:convert';
import 'package:vivii/globals.dart' as global;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.foldingCube
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = HexColor(global.primary_color)
    ..backgroundColor = Colors.transparent
    ..boxShadow = <BoxShadow>[]
    ..indicatorColor = HexColor(global.primary_color)
    ..textColor = HexColor(global.primary_color)
    ..maskColor = Colors.green.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final mobileController = TextEditingController();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  var devicetoken;
  var tokenurl = global.api_base_url + "/register_with_token";
  String user_city = "";

  @override
  void SendPushNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      print("onMessage :$message");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp: $message");
    });

    /*FirebaseMessaging.onBackgroundMessage((RemoteMessage message) {
      print("onBackgroundMessage: $message");
    });*/

    /* _fcm.configure(
      onMessage: (Map<String,dynamic>message)async{
        print("onMessage :$message");
      },
      onResume: (Map<String,dynamic>message)async{
        print("onMessage :$message");
      },
      onLaunch: (Map<String,dynamic>message)async{
        print("onMessage :$message");
      },

    );*/

/*    _fcm.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _fcm.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });*/

    _fcm.getToken().then((token) {
      final tokenStr = token.toString();
      devicetoken = "Push Messaging token: $token";
      print(tokenStr);
      devicetoken = tokenStr;

      loginWithToken();
    });
  }

  void loginWithToken() async {
    configLoading();
    EasyLoading.show(status: 'Loading...');
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await http.post(Uri.parse(tokenurl), headers: {
      "Accept": "application/json"
    }, body: {
      "secrete": "dacb465d593bd139a6c28bb7289fa798",
      "token": devicetoken,
    });

    //print(res.body);

    var resp = json.decode(res.body);
    if (resp['status'] == "0") {
      /*Toast.show(resp['message'], context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);*/
      EasyLoading.dismiss();
    } else if (resp['status'] == "2") {
      EasyLoading.dismiss();
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool('isLoggedIn', true);
      pref.setString("user_id", resp['user_id']);
      pref.setString("full_name", resp['full_name']);
      pref.setString("email", resp['email']);
      pref.setString("contact", resp['contact']);
      global.user_id = resp['user_id'];
      global.fullname = resp['full_name'];
      global.email = resp['email'];
      global.contact = resp['contact'];

      // SendPushNotification();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainPage()));
    } else {
      EasyLoading.dismiss();
      setState(() {
        var resp = json.decode(res.body);
        //print("USERRRRR_ID = "+resp['user_id']);
        global.user_id = resp['user_id'] ?? "";
        global.fullname = "Guest";
        global.email = "";
        global.contact = "";
        /*print("Full_name " + global.fullname);
      print("contact " + global.contact);
      print("Email" + global.email);
      print("User_id " + global.user_id);*/
        pref.setString("user_id", resp['user_id']);
        pref.setString("full_name", "Guest");
        pref.setBool("isLoggedIn", true);
        /* print(resp);*/
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
            (route) => false);
      });
    }
  }

  Future<void> userLogin() async {
    configLoading();
    EasyLoading.show(status: 'Loading...');

    var user_login_url = global.api_base_url + "login";
    var res = await http.post(Uri.parse(user_login_url), headers: {
      "Accept": "application/json"
    }, body: {
      "secrete": "dacb465d593bd139a6c28bb7289fa798",
      "contact": mobileController.text,
    });
    var resp = json.decode(res.body);
    if (resp['status'] == 0) {
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
      /* Toast.show(resp['message'], context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);*/
    } else {
      EasyLoading.dismiss();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OTPPage(
                    mobile_no: mobileController.text,
                  )));
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
                  "Don't have an account?",
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
                    " Sign Up",
                    style: GoogleFonts.nunito(
                        color: HexColor("00726d"), fontSize: 16),
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
                controller: mobileController,
                style: GoogleFonts.nunito(),
                cursorColor: Colors.black,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
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
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => OtpPage()));
                setState(() {
                  if (mobileController.text.isEmpty ||
                      (mobileController.text.length != 10)) {
                    /*Toast.show('Please Enter Valid Mobile Number!', context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);*/
                  } else {
                    // print("log in api call start");
                    userLogin();
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
                  "Login",
                  style: GoogleFonts.nunito(fontSize: 17, color: Colors.white),
                )),
              ),
            ),
            GestureDetector(
              onTap: () {
                SendPushNotification();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: HexColor(global.primary_color),
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.only(left: 30, right: 30, top: 200),
                height: 50,
                child: Center(
                    child: Text(
                  "Explore Store",
                  style: GoogleFonts.nunito(fontSize: 17, color: Colors.white),
                )),
              ),
            ),
            /*   Padding(
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
            ),*/
          ],
        ),
      ),
    );
  }
}
