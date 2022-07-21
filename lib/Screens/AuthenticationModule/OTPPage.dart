import 'dart:async';
import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path/path.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;
import 'package:vivii/Screens/HomePageModule/MainPage.dart';
import 'package:vivii/globals.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:alt_sms_autofill/alt_sms_autofill.dart';

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

class OTPPage extends StatefulWidget {
  final String mobile_no;
  const OTPPage({Key? key, required this.mobile_no}) : super(key: key);

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  static String? _otp;
  var devicetoken;
  //var updatetokenurl = "http://admin.happick.in/api/user_device_token";
  String user_city = "";
  TextEditingController textEditingController = TextEditingController();

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(this.context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Material(
          color: Colors.white,
          child: ListView(
            children: [
              const SizedBox(height: 80),
              const SizedBox(height: 80),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Phone Number Verification',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Enter the code sent to ",
                      children: [
                        TextSpan(
                            text: "${widget.mobile_no}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,

                      animationType: AnimationType.scale,
                      validator: (v) {
                        if (v!.length < 3) {
                          return "I'm from validator";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        ////ACTIVE//////
                        activeColor: HexColor("00736d"),
                        /////INACTIVE////
                        inactiveColor: HexColor("bbbcc1"),
                        /////INACTIVE////
                        selectedColor: HexColor("6e9a96"),
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: false,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,

                      onCompleted: (v) {
                        otpVerification(context, _otp);
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        debugPrint(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      enablePinAutofill: true,
                      dialogConfig: DialogConfig(
                        dialogTitle: "Vivii",
                        dialogContent:
                            "Do You Want To Paste " + _otp.toString(),
                        affirmativeText: "Yes",
                      ),
                      // beforeTextPaste: (_) => false,
                      beforeTextPaste: (text) {
                        debugPrint("Allowing to paste $_otp");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              Padding(
                padding: EdgeInsets.all(40),
              ),
              GestureDetector(
                onTap: () {
                  otpVerification(context, _otp);
                  /*  formKey.currentState!.validate();
                  // conditions for validating
                  if (currentText.length != 6 || currentText != "123456") {
                    errorController!.add(ErrorAnimationType
                        .shake); // Triggering error shake animation
                    setState(() => hasError = true);
                  } else {
                    setState(
                          () {
                        hasError = false;
                        snackBar("OTP Verified!!");
                      },
                    );
                  }*/
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: HexColor(global.primary_color),
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.only(left: 30, right: 30, top: 60),
                  height: 50,
                  child: Center(
                      child: Text(
                    "Verify",
                    style:
                        GoogleFonts.nunito(fontSize: 17, color: Colors.white),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> otpVerification(context, _otp) async {
    configLoading();
    EasyLoading.show(status: 'Loading...');
    print('mobile_no=' + widget.mobile_no);
    // print('otp method =' + _otp);
    var otp_login_url = global.api_base_url + "verify_otp";
    var res = await http.post(Uri.parse(otp_login_url), headers: {
      "Accept": "application/json"
    }, body: {
      "secrete": "dacb465d593bd139a6c28bb7289fa798",
      "contact": widget.mobile_no,
      "otp": textEditingController.text,
    });
    var resp = json.decode(res.body);
    print(resp);
    if (resp['status'] == "0") {
      EasyLoading.dismiss();
      var snackBar = SnackBar(
        padding: EdgeInsets.all(30),
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
    } else {
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

      print("User Id = " + global.user_id);
      // SendPushNotification();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainPage()));
    }
  }

  void _storeLoggedInStatus(bool isLoggedIn) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isLoggedIn', isLoggedIn);
  }
}
