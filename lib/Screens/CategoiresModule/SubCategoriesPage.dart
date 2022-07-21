import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:vivii/Screens/CategoiresModule/SubSubCatregoriesPage.dart';
import 'package:vivii/Screens/HomePageModule/MainPage.dart';
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

class SubCategoriesPage extends StatefulWidget {
  final String main_category_id;
  const SubCategoriesPage({Key? key, required this.main_category_id})
      : super(key: key);

  @override
  State<SubCategoriesPage> createState() => _SubCategoriesPageState();
}

class _SubCategoriesPageState extends State<SubCategoriesPage> {
  @override
  void initState() {
    super.initState();
    this.getSubCategory();
  }

  List sub_category_data = [];
  var main_category_name = "";

  Future<String> getSubCategory() async {
    configLoading();
    EasyLoading.show(status: 'Loading...');

    var res = await http
        .post(Uri.parse(global.api_base_url + "/get_sub_category"), headers: {
      "Accept": "application/json"
    }, body: {
      "secrete": "dacb465d593bd139a6c28bb7289fa798",
      "main_category_id": widget.main_category_id,
    });
    print(res.body);
    var resp = json.decode(res.body);
    if (resp['status'] == "0") {
      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      setState(() {
        var convert = json.decode(res.body)['sub_category'];
        if (convert != null) {
          sub_category_data = convert;
          main_category_name = resp['main_category_name'];
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
      backgroundColor: HexColor(global.background_color),
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
                  " " + main_category_name,
                  style: GoogleFonts.nunito(),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2.0),
                color: Colors.white,
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
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  //////////////////////////////////
                  ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: sub_category_data.length,
                    itemBuilder: (context, index) {
                      return Wrap(
                        children: [
                          ListTile(
                            leading: SizedBox(
                              height: 30,
                              width: 30,
                              child: Image.network(
                                sub_category_data[index]['image_path'],
                              ),
                            ),
                            title: Text(
                              sub_category_data[index]['sub_category_name'],
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
                                      builder: (context) =>
                                          SubSubCategoriesPage(
                                              sub_category_id:
                                                  sub_category_data[index]
                                                      ['sub_category_id'])));
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Divider(
                              color: Colors.grey.shade100,
                              thickness: 1,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  ////////////////////////////
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
