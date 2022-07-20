import 'dart:async';
import 'dart:convert';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  List main_category_data = [];

  Future<String> getMainCategory() async {
    configLoading();
    EasyLoading.show(status: 'Loading...');

    var res = await http
        .post(Uri.parse(global.api_base_url + "/get_main_category"), headers: {
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
          main_category_data = convert;
        } else {
          // print("null");
        }
      });
    }

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    var deviceOrientetion = MediaQuery.of(context).orientation;
    var heightx = MediaQuery.of(context).size.width < 570
        ? 170.0
        : MediaQuery.of(context).size.width < 768
            ? 200.0
            : 200.0;
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            height: 200,
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 1,
                enlargeCenterPage: true,
                viewportFraction: 1,
                autoPlayAnimationDuration: Duration(milliseconds: 1000),
                autoPlayCurve: Curves.decelerate,
              ),
              items: sliders?.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: GestureDetector(
                                child: ClipRRect(
                                  child: FadeInImage.assetNetwork(
                                    placeholder:
                                        'images/banner_placeholder.jpg',
                                    image: i['image_path'],
                                  ),
                                ),
                                onTap: () {
                                  // print(i['category_id']);
                                  /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProdList(
                                              categoryId:
                                              i['category_id'])));*/
                                }));
                      },
                    );
                  }).toList() ??
                  [],
            ),
          ),
          /*  Positioned.directional(
            textDirection: Directionality.of(context),
            start: 20.0,
            bottom: 0.0,
            child: Row(
              children: sliders!.map((i) {
                return Container(
                  width: 12.0,
                  height: 3.0,
                  margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: _current == sliders!.indexOf(i)
                        ? Colors.black */ /*.withOpacity(0.9)*/ /*
                        : Colors.red.withOpacity(0.5),
                  ),
                );
              }).toList(),
            ),
          ),*/
          Container(
            margin: EdgeInsets.only(
              top: 10,
            ),
            height: 400,
            child: ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount:
                    main_category_data == null ? 0 : main_category_data.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      /*  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductDetail(
                                  product_id:
                                      main_category_data[index]
                                          ['product_id'])));*/
                    },
                    child: Container(
                      // margin: EdgeInsets.only(right: 10, left: 10),
                      // padding: EdgeInsets.only(right: 1, left: 1),
                      width: (deviceOrientetion == Orientation.portrait)
                          ? MediaQuery.of(context).size.width / 2
                          : MediaQuery.of(context).size.width / 2,
                      child: Wrap(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Image.network(
                                main_category_data[index]['image_path'],
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 3.0),
                            //child:Expanded(
                            alignment: Alignment.center,
                            padding:
                                EdgeInsets.only(right: 10, left: 10, top: 5),
                            child: Text(
                              main_category_data[index]['main_category_name'],
                              style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),

                              maxLines: 2,
                              textAlign: TextAlign.center,
                              //textDirection: TextDirection.ltr,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          Container(
            color: Colors.white,
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 12, right: 5, top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Categories",
                          textDirection: TextDirection.ltr,
                          style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                              color: HexColor("#6e6e6e"),
                              fontSize: 18.0,
                            ),
                          )),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              height: 30.0,
                              // margin: const EdgeInsets.only(left: 290, right: 10),
                              child: RaisedButton(
                                onPressed: () {
                                  /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AllCatMain()));*/
                                },
                                child: Text("View All",
                                    style: GoogleFonts.nunito(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        letterSpacing: 1,
                                      ),
                                    )),
                                elevation: 0.0,
                                //color: HexColor("#e43326"),
                                color: HexColor("#fa6161"),
                                //color: Colors.white,
                                splashColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                    color: Colors.white,
                    child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        //shrinkWrap : true,
                        //itemCount: 2,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        scrollDirection: Axis.vertical,
                        itemCount:
                            category_data == null ? 0 : category_data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: GestureDetector(
                              onTap: () {
                                /*Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProdList(
                                            categoryId: data[index]
                                                ['category_id'])));*/
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    color: HexColor("#E7E7E7"),
                                  )),
/*
                             padding: EdgeInsets.only(right: 5),
*/
                                  width: (deviceOrientetion ==
                                          Orientation.portrait)
                                      ? MediaQuery.of(context).size.width / 2
                                      : MediaQuery.of(context).size.width / 4,
                                  child: Column(
                                    children: <Widget>[
                                      Flexible(
                                        child: Container(
                                          height: 150,
                                          width: double.infinity,
                                          /* margin: EdgeInsets.only(
                                       left: 3.0,
                                     ),*/
                                          child: FadeInImage.assetNetwork(
                                            placeholder:
                                                'images/product_placeholder.png',
                                            image: category_data[index]
                                                ['image_path'],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            category_data[index]
                                                ['category_name'],
                                            style: GoogleFonts.nunito(
                                              textStyle: TextStyle(
                                                color: HexColor("#8c8c8c"),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 11,
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        })),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _SelectedTab { home, favorite, search, person }
