import 'dart:async';
import 'dart:convert';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  void initState() {
    super.initState();

    this.getCategories();
  }

  //////////////////////CATEGORIES API//////////////////////////

  List product_data = [];
  int? len;

  Future<String> getCategories() async {
    configLoading();
    EasyLoading.show(status: 'Loading...');

    var res = await http.post(
      Uri.parse(global.api_base_url + "/get_products"),
      headers: {"Accept": "application/json"},
      body: {
        "secrete": "dacb465d593bd139a6c28bb7289fa798",
        "sub_sub_category_id": "1",
      },
    );

    var resp = json.decode(res.body);
    if (resp['status'] == "0") {
      /* Toast.show(resp['message'], context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);*/
      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      print(res.body);
      setState(() {
        var convert = json.decode(res.body)['products'];
        if (convert != null) {
          product_data = convert;
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
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: ViViiAppbar(context),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.only(top: 40),
          ),
          GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              //shrinkWrap : true,
              //itemCount: 2,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.59, crossAxisCount: 2),
              scrollDirection: Axis.vertical,
              itemCount: product_data == null ? 0 : product_data.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProdList(
                                categoryId: data[index]
                                    ['category_id'])));*/
                  },
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: Colors.transparent,
                    elevation: 0,
                    child: Column(
                      children: [
                        Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              product_data[index]['image_path'],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                product_data[index]['product_name'],
                                style: GoogleFonts.nunito(fontSize: 11),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              ' \u{20B9}' +
                                  " " +
                                  product_data[index]['sell_price'],
                              style: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                            ),
                            Text(
                              ' \u{20B9}' + " " + product_data[index]['price'],
                              style: GoogleFonts.nunitoSans(
                                fontSize: 10,
                                textStyle: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                            ),
                            Text(
                              " " +
                                  product_data[index]['discount_percentage']
                                      .toString() +
                                  "% " +
                                  "off",
                              style: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              product_data[index]['offer_price'],
                              style: GoogleFonts.nunito(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Selling Fast",
                              style: GoogleFonts.nunito(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
