import 'dart:async';
import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:vivii/globals.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animation_wrappers/animation_wrappers.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    this.getSliderImage();
  }

  /////////Sliders////////////////
  /////////Sliders////////////////
  var _current = 0;
  List? data;
  var listitem = [];

  Future<String> getSliderImage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user_id = pref.getString("user_id");
    configLoading();
    EasyLoading.show(status: 'Loading...');
    /*var res = await http.get(
      Uri.encodeFull(url),
      headers: {"Accept":"application/json"},
    );*/
    var res = await http.post(
        Uri.parse(global.api_weclicks_url + "get_all_sliders"),
        headers: {"Accept": "application/json"},
        body: {"secrete": "dacb465d593bd139a6c28bb7289fa798"});
    //print(res.body);
    setState(() {
      EasyLoading.dismiss();
      var convert = json.decode(res.body)['sliders'];
      // print(convert);
      data = convert;
      data?.forEach((data) {
        listitem.add(data["image_path"]);
      });
    });
    return "Success";
  }
  /////////Sliders////////////////
  /////////Sliders////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          Stack(
            children: [
              Center(
                child: CarouselSlider(
                  items: listitem.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          child: FadedScaleAnimation(
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/banner_placeholder.jpg',
                              image: i,
                              // fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                      autoPlay: true,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
