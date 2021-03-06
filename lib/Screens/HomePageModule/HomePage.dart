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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    this.getHomePage();
    this.getBottomBar();
    this.SendPushNotification();
    this.fcmSubscribe();
  }

  //////////////////Notifiaction Finale Code Starts///////////////////

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  var devicetoken;
  var updatetokenurl = global.api_base_url + "user_device_token";

  void fcmSubscribe() {
    _fcm.subscribeToTopic('weclicks');
    print("topic SUbscriberd");
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void SendPushNotification() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (Platform.isAndroid) {
        var title = notification?.title;

        print("asdasdasd");

        // var body = message.data['message'];
        var body = notification?.body;

        print(message);

        //var image = message.data['image'];
        var image =
            "https://9series.com/blog/wp-content/uploads/2019/04/Flutter-Future-of-App-Development.jpg";

        showNotification(title!, body!, image);
      } else if (Platform.isIOS) {
        var title = message.data['title'];
        var body = message.data['message'];
        var image = message.data['image'];
        print(notification);
        showNotification(title, body, image);
        print("onMessage :$message");
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp: $message");
    });

    /*FirebaseMessaging.onBackgroundMessage((RemoteMessage message) {
      print("onBackgroundMessage: $message");
    });*/

    _fcm.requestPermission(
        sound: true, badge: true, alert: true, provisional: false);

    //////Update Device Token/////////
    _fcm.getToken().then((token) {
      final tokenStr = token.toString();
      devicetoken = "Push Messaging token: $token";
      print(tokenStr);
      devicetoken = tokenStr;

      UpdateDeviceToken();
    });
  }

  showNotification(String title, String body, String image) async {
    await _demoNotification(title, body, image);
    // print(image);
  }

  Future<void> _demoNotification(
      String title, String body, String image) async {
    if (image != "") {
      //  print("asdad");
      // print(image);

      var attachmentPicturePath =
          await _downloadAndSaveFile(image, 'attachment_img.jpg');

      var iOSChannelSpecifics = IOSNotificationDetails(
        attachments: [
          IOSNotificationAttachment(
            attachmentPicturePath,
          )
        ],
      );

      var bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(attachmentPicturePath),
        largeIcon: FilePathAndroidBitmap(attachmentPicturePath),
        hideExpandedLargeIcon: false,
        contentTitle: title,
        htmlFormatContentTitle: true,
        summaryText: body,
        htmlFormatSummaryText: true,
      );

      final sound = 'not_sound.wav';

      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'CHANNEL ID 2',
        'CHANNEL NAME 2',
        importance: Importance.high,
        priority: Priority.high,
        // sound: RawResourceAndroidNotificationSound(sound.split('.').first),
        enableVibration: true,
        largeIcon: FilePathAndroidBitmap(attachmentPicturePath),
        styleInformation: bigPictureStyleInformation,
      );

      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
      await flutterLocalNotificationsPlugin
          .show(0, title, body, platformChannelSpecifics, payload: 'test');
    }
    /* else
      {
      // var attachmentPicturePath = await _downloadAndSaveFile(image, 'attachment_img.jpg');

      var attachmentPicturePath =
          await _downloadAndSaveFile(image, 'attachment_img.jpg');

      var iOSChannelSpecifics = IOSNotificationDetails(
        attachments: [IOSNotificationAttachment(attachmentPicturePath)],
      );

      var bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(attachmentPicturePath),
        contentTitle: title,
        htmlFormatContentTitle: true,
        summaryText: body,
        htmlFormatSummaryText: true,
      );

      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'CHANNEL ID 2',
        'CHANNEL NAME 2',
        importance: Importance.high,
        priority: Priority.high,
      );

      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
      await flutterLocalNotificationsPlugin
          .show(0, title, body, platformChannelSpecifics, payload: 'test');
    }*/
  }

  _downloadAndSaveFile(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.post(Uri.parse(url));
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  void UpdateDeviceToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user_id = pref.getString("user_id");

    var res = await http.post(Uri.parse(updatetokenurl), headers: {
      "Accept": "application/json"
    }, body: {
      "secrete": "dacb465d593bd139a6c28bb7289fa798",
      "user_id": user_id,
      "token": devicetoken,
    });
    var resp = json.decode(res.body);
  }

  ////////////////Notifiaction Finale Code Ends///////////////////

  ////////////////////////HOMEPAGE API////////////////////////////
  ////////////////////////HOMEPAGE API////////////////////////////
  ////////////////////////HOMEPAGE API////////////////////////////

  /////////////////SLIDERS VAR//////////////////////////
  List? sliders;
  var listslideritem = [];
  var _current = 0;
  /////////////////SLIDERS VAR//////////////////////////

  /////////////////MAINCATEGORY VAR/////////////////////
  List main_category_data = [];
  /////////////////MAINCATEGORY VAR/////////////////////

  ////////////////BOTTOMBANNERS VAR/////////////////////
  List bottombanner_data = [];
  ////////////////BOTTOMBANNERS VAR/////////////////////

  /////////////////LATESTPRODUCT VAR/////////////////////
  List latest_product_data = [];
  /////////////////LATESTPRODUCT VAR/////////////////////

  /////////////////RANDOMCATEGORY VAR/////////////////////
  List random_product_data = [];
  var random_category_title = "";
  /////////////////RANDOMCATEGORY VAR/////////////////////

  Future<String> getHomePage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user_id = pref.getString("user_id");
    configLoading();
    EasyLoading.show(status: 'Loading...');
    var res = await http.post(
        Uri.parse(global.api_base_url + "get_homepage_data"),
        headers: {"Accept": "application/json"},
        body: {"secrete": "dacb465d593bd139a6c28bb7289fa798"});
    setState(() {
      EasyLoading.dismiss();
      var resp = json.decode(res.body);
      if (resp['status'] == "0") {
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        setState(() {
          sliders = json.decode(res.body)['top_banners'];
          bottombanner_data = json.decode(res.body)['bottom_banners'];
          main_category_data = json.decode(res.body)['home_main_category'];
          latest_product_data = json.decode(res.body)['latest_product_data'];
          random_product_data = json.decode(res.body)['random_product_data'];
          random_category_title =
              json.decode(res.body)['random_category_title'];
        });
      }
    });
    return "Success";
  }
  ////////////////////////HOMEPAGE API////////////////////////////
  ////////////////////////HOMEPAGE API////////////////////////////
  ////////////////////////HOMEPAGE API////////////////////////////

  //////////////////////BOTTOM BAR API///////////////////////////

  var bottombar_url = global.api_happick_url + "/get_bottom_bar";
  List bottom_bar_data = [];

  Future<String> getBottomBar() async {
    configLoading();
    EasyLoading.show(status: 'Loading...');

    var res = await http.post(Uri.parse(bottombar_url), headers: {
      "Accept": "application/json"
    }, body: {
      "secrete": "dacb465d593bd139a6c28bb7289fa798",
    });
    //print(res.body);
    var resp = json.decode(res.body);
    if (resp['status'] == "0") {
      /*  Toast.show(resp['message'], context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);*/
      EasyLoading.dismiss();
    } else {
      EasyLoading.dismiss();
      setState(() {
        var convert = json.decode(res.body)['bottom_bar'];
        if (convert != null) {
          bottom_bar_data = convert;
        } else {
          // print("null");
        }
      });
    }

    return "Success";
  }

  //////////////////////BOTTOM BAR API///////////////////////////

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
          Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 5, top: 15, bottom: 5),
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
                            /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AllCatMain()));*/
                          },
                          child: Text("Explore",
                              style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  letterSpacing: 1,
                                ),
                              )),
                          elevation: 0.0,
                          //color: HexColor("#e43326"),
                          color: HexColor(global.primary_color),
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
            height: 350,
            child: Wrap(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      left: 12, right: 5, top: 15, bottom: 15),
                  child: Text(
                    "New arrival",
                    textDirection: TextDirection.ltr,
                    style: GoogleFonts.nunito(
                      textStyle: TextStyle(
                        color: HexColor("#6e6e6e"),
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: latest_product_data == null
                        ? 0
                        : latest_product_data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: 180,
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
                                    latest_product_data[index]['image_path'],
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
                                      latest_product_data[index]
                                          ['product_name'],
                                      style: GoogleFonts.nunito(fontSize: 11),
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/50.png',
                  height: 100,
                ),
                Image.asset(
                  'assets/30.png',
                  height: 110,
                ),
                Image.asset(
                  'assets/20.png',
                  height: 100,
                ),
              ],
            ),
          ),

          ///////////////////////CATEGORIES/////////////////////////////////////
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
                      Text(random_category_title,
                          textDirection: TextDirection.ltr,
                          style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                              color: HexColor("#6e6e6e"),
                              fontSize: 18.0,
                            ),
                          )),
                      /* Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              height: 30.0,
                              // margin: const EdgeInsets.only(left: 290, right: 10),
                              child: RaisedButton(
                                onPressed: () {
                                  */ /*  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AllCatMain()));*/ /*
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
                      ),*/
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
                            childAspectRatio: 0.59, crossAxisCount: 3),
                        scrollDirection: Axis.vertical,
                        itemCount: random_product_data == null
                            ? 0
                            : random_product_data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
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
                                      random_product_data[index]['image_path'],
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
                                        random_product_data[index]
                                            ['product_name'],
                                        style: GoogleFonts.nunito(fontSize: 11),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        })),
              ],
            ),
          ),

          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount:
                  bottombanner_data == null ? 0 : bottombanner_data.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    /* Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProdList(
                                categoryId: data[index]['category_id'])));*/
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      //border: Border.all(color: Colors.white, width: 2.0),
                      color: Colors.white,
                      border: Border.all(color: HexColor("e7e7e7e7")),

                      /* boxShadow: <BoxShadow>[
                    new BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: new Offset(0.0, 3.0),
                    ),
                  ],*/
                    ),
                    margin: EdgeInsets.only(top: 15.0),
                    child: Image.network(
                      bottombanner_data[index]['image_path'],
                    ),
                  ),
                );
              }),
          Container(
            color: Colors.white,
            child: Wrap(
              children: [
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    margin: EdgeInsets.only(top: 15.0),
                    height: heightx,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: bottom_bar_data == null
                            ? 0
                            : bottom_bar_data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              /* Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BottomBarDesc(
                                          product_id: bottom_bar_data[index]
                                              ['bottom_bar_id'],
                                          image_path: bottom_bar_data[index]
                                              ['image_path'],
                                          desc: bottom_bar_data[index]
                                              ['description'],
                                          title: bottom_bar_data[index]
                                              ['title'])));*/
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              padding: EdgeInsets.only(right: 15),
                              width: (deviceOrientetion == Orientation.portrait)
                                  ? MediaQuery.of(context).size.width / 3
                                  : MediaQuery.of(context).size.width / 3,
                              child: Column(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      Container(
                                        height: heightx - 50,
                                        margin: EdgeInsets.only(
                                          left: 10.0,
                                        ),
                                        child: FadeInImage.assetNetwork(
                                          placeholder:
                                              'images/product_placeholder.png',
                                          image: bottom_bar_data[index]
                                              ['image_path'],
                                          height: 80,
                                          width: 80,
                                        ),
                                        // child: Image.network(data[index]['image_path'], height: 100,),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 3.0),
                                    //child:Expanded(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                        right: 10, left: 10, top: 5),
                                    child: Text(
                                      bottom_bar_data[index]['title'],
                                      style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
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
