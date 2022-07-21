import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:vivii/Screens/HomePageModule/MainPage.dart';
import 'package:vivii/Screens/ProductsModule/ProductList.dart';
import 'package:vivii/globals.dart' as global;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:vivii/globals.dart' as global;
import 'package:flutter_easyloading/flutter_easyloading.dart';

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

class SubSubCategoriesPage extends StatefulWidget {
  final String sub_category_id;
  const SubSubCategoriesPage({Key? key, required this.sub_category_id})
      : super(key: key);

  @override
  State<SubSubCategoriesPage> createState() => _SubSubCategoriesPageState();
}

class _SubSubCategoriesPageState extends State<SubSubCategoriesPage> {
  @override
  void initState() {
    super.initState();
    this.getSubSubCategory();
  }

  List sub_sub_category_data = [];
  var sub_category_name = "";

  Future<String> getSubSubCategory() async {
    configLoading();
    EasyLoading.show(status: 'Loading...');

    var res = await http.post(
        Uri.parse(global.api_base_url + "/get_sub_sub_category"),
        headers: {
          "Accept": "application/json"
        },
        body: {
          "secrete": "dacb465d593bd139a6c28bb7289fa798",
          "sub_category_id": widget.sub_category_id,
        });
    print(res.body);
    var resp = json.decode(res.body);
    if (resp['status'] == "0") {
      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      setState(() {
        var convert = json.decode(res.body)['sub_sub_category'];
        if (convert != null) {
          sub_sub_category_data = convert;
          sub_category_name = resp['sub_category_name'];
        } else {
          // print("null");
        }
      });
    }

    return "Success";
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
            child: Image.asset(
              'assets/close.png',
              color: HexColor('33483a'),
            ),
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
      body: Container(
        margin: EdgeInsets.only(left: 30, right: 30, top: 20),
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: Icon(Icons.arrow_back),
                  ),
                ),
                Text(
                  " " + sub_category_name,
                  style: GoogleFonts.nunito(),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                border: Border.all(
                    color: HexColor(global.background_color), width: 2.0),
                color: HexColor(global.background_color),
                borderRadius: BorderRadius.circular(10),
                // borderRadius: BorderRadius.all(Radius.circular(10.0),),
                boxShadow: <BoxShadow>[
                  new BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 2,
                    // blurRadius: 3.0,
                    offset: new Offset(1.0, 1.0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  //////////////////////////////////
                  ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: sub_sub_category_data.length,
                    itemBuilder: (context, index) {
                      return Wrap(
                        children: [
                          ListTile(
                            visualDensity: VisualDensity(vertical: -3),
                            /* leading: Icon(
                              Icons.,
                            ),*/

                            /*SizedBox(
                              height: 30,
                              width: 30,
                              child: Image.network(
                                sub_sub_category_data[index]['image_path'],
                              ),
                            ),*/
                            title: Text(
                              sub_sub_category_data[index]
                                  ['sub_sub_category_name'],
                              style: GoogleFonts.nunito(
                                textStyle: TextStyle(color: Colors.black),
                              ),
                            ),
                            trailing: SizedBox(
                              height: 25,
                              width: 25,
                              child: Icon(Icons.arrow_forward),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductList(
                                          sub_sub_category_id:
                                              sub_sub_category_data[index]
                                                  ['sub_sub_category_id'])));
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Divider(
                              color: Colors.white,
                              thickness: 1,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  ////////////////////////////
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
