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
import 'package:path_provider/path_provider.dart';
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
import 'dart:io' show File, Platform;
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

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key, required this.product_id}) : super(key: key);
  final String product_id;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  List imagedata = [];
  List slideimage = [];

  var product_name = "";
  var product_id = "";
  var category_id = "";
  var short_desc = "";
  var long_desc = "";
  var sell_price = "";
  var price = "";
  var prod_in_cart = "";
  var offer_price = "";
  var discount_percentage = "";
  var category_name = "";
  var image_path = "";
  var product_image = "";
  var show_offer = "";

  @override
  void initState() {
    super.initState();
    this.getSingleProd();
  }

  Future<dynamic> getSingleProd() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user_id = pref.getString("user_id");

    configLoading();
    EasyLoading.show(status: 'Loading...');

    var res = await http
        .post(Uri.parse(global.api_base_url + "/get_single_product"), headers: {
      "Accept": "application/json"
    }, body: {
      "secrete": "dacb465d593bd139a6c28bb7289fa798",
      "product_id": widget.product_id,
      "user_id": user_id,
    });

    var resp = json.decode(res.body);
    if (resp['status'] == "0") {
      /* Toast.show(resp['message'], context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);*/
      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      setState(() {
        Map data = json.decode(res.body) as Map;
        var resp = json.decode(res.body)['product_image'];
        imagedata = resp;
        // print(data);
        product_name = data['product_name'];
        sell_price = data['sell_price'];
        short_desc = data['short_desc'];
        long_desc = data['long_desc'];
        product_image = data['image_path'];
        prod_in_cart = data['in_cart'];
        category_name = data['category_name'];
        price = data['price'];
        offer_price = data['offer_price'];
        discount_percentage = data['discount_percentage'].toString();
        product_id = data['product_id'];
        category_id = data['category_id'];
        //slideimage = json.decode(res.body)['product_image'];
        imagedata.forEach((element) {
          //slideimage.add(prod_img+element['product_image']);
          slideimage
              .add(NetworkImage(product_image + element['product_image']));
        });
        /*  var in_cart = int.parse(prod_in_cart);
        if (prod_offer == "true") {
          prod_include_texes = '\u{20B9}' + sell_price;
          prod_offer_price = data['offer_price'];
        } else {
          prod_offer_price = "";
        }*/
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.grey[600],
        ),
        elevation: 1,
        //backgroundColor: Color.fromRGBO(8, 64, 106, 1),
        backgroundColor: Colors.white,
        //backgroundColor: Color.fromARGB(1, 8, 64, 106),
        centerTitle: true,

        leading: Padding(
          padding: const EdgeInsets.all(18.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Iconsax.arrow_left),
          ),
        ),
        title: Text(
          "Vivii",
          style: GoogleFonts.nunito(
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 1,
              enlargeCenterPage: true,
              viewportFraction: 1,
              autoPlayAnimationDuration: Duration(milliseconds: 1000),
              autoPlayCurve: Curves.decelerate,
            ),
            items: imagedata.map((i) {
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
                              placeholder: 'images/banner_placeholder.jpg',
                              image: product_image + i['product_image'],
                              fit: BoxFit.cover,
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
            }).toList(),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              product_name,
              style: GoogleFonts.nunito(
                textStyle: TextStyle(color: Colors.black87, fontSize: 15),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              short_desc,
              style: GoogleFonts.nunito(
                textStyle: TextStyle(color: Colors.black87, fontSize: 15),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Text(
                  ' \u{20B9}' + " " + sell_price + "  ",
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    textStyle: TextStyle(fontSize: 13),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "  MRP ",
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      price,
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough),
                      ),
                    ),
                  ],
                ),
                Text(
                  "    " + discount_percentage.toString() + "% " + "off",
                  style: GoogleFonts.nunitoSans(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              "Price inclusive of all taxes.",
              style: GoogleFonts.nunito(
                textStyle: TextStyle(color: Colors.black87, fontSize: 9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
