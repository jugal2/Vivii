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
import 'package:vivii/Widgets/ViViiDrawer.dart';
import 'package:vivii/Widgets/ViviiAppbar.dart';
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

    this.getSliders();
    this.getCategories();
  }

  //////////////////////SLIDER API////////////////////////////////
  List? sliders;
  var listslideritem = [];

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
        Uri.parse(global.api_happick_url + "get_top_banners"),
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
          var convert = json.decode(res.body)['top_banner'];
          sliders = convert;
          sliders?.forEach((data) {
            listslideritem.add(data["top_banner_image_path"]);
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

  @override
  Widget build(BuildContext context) {
    var deviceOrientetion = MediaQuery.of(context).orientation;
    var heightx = MediaQuery.of(context).size.width < 570
        ? 170.0
        : MediaQuery.of(context).size.width < 768
            ? 200.0
            : 200.0;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ViViiAppbar(context),
      drawer: ViviiDrawer(),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          Container(
            height: 230.0,
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
                                    image: i['top_banner_image_path'],
                                    fit: BoxFit.fill,
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
          Container(
            height: 500,
            child: GridView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: [
                GestureDetector(
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
                      width: (deviceOrientetion == Orientation.portrait)
                          ? MediaQuery.of(context).size.width / 2
                          : MediaQuery.of(context).size.width / 4,
                      child: Wrap(
                        children: <Widget>[
                          Flexible(
                            child: Container(
                                height: 400,
                                width: double.infinity,
                                /* margin: EdgeInsets.only(
                                       left: 3.0,
                                     ),*/
                                child: Image.asset(
                                  'assets/men.jpg',
                                )),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text("Male",
                                style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 25,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
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
                      width: (deviceOrientetion == Orientation.portrait)
                          ? MediaQuery.of(context).size.width / 2
                          : MediaQuery.of(context).size.width / 4,
                      child: Wrap(
                        children: <Widget>[
                          Flexible(
                            child: Container(
                                height: 400,
                                width: double.infinity,
                                /* margin: EdgeInsets.only(
                                       left: 3.0,
                                     ),*/
                                child: Image.asset(
                                  'assets/female.jpg',
                                )),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text("Female",
                                style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 25,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
