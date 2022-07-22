import 'dart:async';
import 'dart:convert';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:vivii/Screens/CategoiresModule/CategoriesPage.dart';
import 'package:vivii/Screens/HomePageModule/HomePage.dart';
import 'package:vivii/Screens/HomePageModule/ProfilePage.dart';
import 'package:vivii/Screens/TestingModules/ComingSoon.dart';
import 'package:vivii/Screens/TestingModules/InfiniteScroll.dart';
import 'package:vivii/Widgets/ViViiDrawer.dart';
import 'package:vivii/Widgets/ViviiAppbar.dart';
import 'package:vivii/globals.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';

import '../AuthenticationModule/LoginPage.dart';
import '../AuthenticationModule/OTPPage.dart';
import '../AuthenticationModule/RegisterPage.dart';

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

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();

    this.getSliders();
    this.getCategories();
    this.getMainCategory();
  }

  //////////////////////SLIDER API////////////////////////////////
  List? sliders;
  var listslideritem = [];
  var _current = 0;

  Future<String> getSliders() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user_id = pref.getString("user_id");
    configLoading();
    EasyLoading.show(status: 'Loading...');
    /*var res = await http.get(
      Uri.encodeFull(url),
      headers: {"Accept":"application/json"},
    );*/
    var res = await http.post(
        Uri.parse(global.api_base_url + "get_top_banners"),
        headers: {"Accept": "application/json"},
        body: {"secrete": "dacb465d593bd139a6c28bb7289fa798"});
    print(res.body);
    setState(() {
      EasyLoading.dismiss();
      var resp = json.decode(res.body);
      if (resp['status'] == "0") {
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        setState(() {
          var convert = json.decode(res.body)['top_banners'];
          sliders = convert;
          sliders?.forEach((data) {
            listslideritem.add(data["image_path"]);
          });
        });
      }
    });
    return "Success";
  }
  //////////////////////SLIDER API////////////////////////////////

  //////////////////////CATEGORIES API//////////////////////////
  var get_top_banners_url = global.api_happick_url + "/get_popular_category";
  List category_data = [];
  int? len;

  Future<String> getCategories() async {
    configLoading();
    EasyLoading.show(status: 'Loading...');

    var res = await http.post(Uri.parse(get_top_banners_url),
        headers: {"Accept": "application/json"},
        body: {"secrete": "dacb465d593bd139a6c28bb7289fa798"});

    var resp = json.decode(res.body);
    if (resp['status'] == "0") {
      /* Toast.show(resp['message'], context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);*/
      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      setState(() {
        var convert = json.decode(res.body)['popular_category'];
        if (convert != null) {
          category_data = convert;
        } else {
          //print("nulll");
        }
      });
    }

    return "Success";
  }
  //////////////////////CATEGORIES API//////////////////////////

  var product_url = global.api_base_url + "/get_main_category";
  List most_popular_product_data = [];

  Future<String> getMainCategory() async {
    configLoading();
    EasyLoading.show(status: 'Loading...');

    var res = await http.post(Uri.parse(product_url), headers: {
      "Accept": "application/json"
    }, body: {
      "secrete": "dacb465d593bd139a6c28bb7289fa798",
    });
    print(res.body);
    var resp = json.decode(res.body);
    if (resp['status'] == "0") {
      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      setState(() {
        var convert = json.decode(res.body)['home_main_category'];
        if (convert != null) {
          most_popular_product_data = convert;
        } else {
          // print("null");
        }
      });
    }

    return "Success";
  }

  List<TabItem> items = [
    TabItem(
      icon: Iconsax.home,
      title: 'Home',
    ),
    TabItem(
      icon: Iconsax.search_normal,
      title: 'Explore',
    ),
    TabItem(
      icon: Iconsax.personalcard,
      title: 'Account',
    ),
    TabItem(
      icon: Iconsax.heart,
      title: 'Wishlist',
    ),
    TabItem(
      icon: Iconsax.shopping_cart,
      title: 'Cart',
    ),
  ];

  final widgetOptions = [
    HomePage(),
    ComingSoon(),
    ProfilePage(),
    ComingSoon(),
    ComingSoon(),
  ];

  int selectedIndex = 0;
  double height = 30;
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceOrientetion = MediaQuery.of(context).orientation;
    var heightx = MediaQuery.of(context).size.width < 570
        ? 170.0
        : MediaQuery.of(context).size.width < 768
            ? 200.0
            : 200.0;
    return WillPopScope(
      onWillPop: () async => _exitdialog(),
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar: BottomBarFloating(
          items: items,
          titleStyle: GoogleFonts.nunitoSans(),
          backgroundColor: Colors.white,
          color: Colors.grey.shade400,
          colorSelected: HexColor("33483a"),
          indexSelected: selectedIndex,
          onTap: (int index) => setState(() {
            selectedIndex = index;
          }),
        ),
        backgroundColor: Colors.white,
        appBar: ViViiAppbar(context),
        body: Center(
          child: widgetOptions.elementAt(selectedIndex),
        ),
      ),
    );
  }

  Future<bool> _exitdialog() async {
    return await showDialog(
        context: this.context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Vivii",
              style: GoogleFonts.lato(),
            ),
            content: Text(
              "Do You Really Wanna Exit?",
              style: GoogleFonts.lato(),
            ),
            actions: [
              FlatButton(
                child: Text(
                  "Cancel",
                  style: GoogleFonts.lato(),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text(
                  "Exit",
                  style: GoogleFonts.lato(),
                ),
                onPressed: () {
                  SystemNavigator.pop();
                },
              ),
            ],
          );
        });
  }
}
