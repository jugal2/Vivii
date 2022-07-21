import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:vivii/globals.dart' as global;

class FutureInfiniteScroll extends StatefulWidget {
  const FutureInfiniteScroll({Key? key}) : super(key: key);

  @override
  _FutureInfiniteScrollState createState() => _FutureInfiniteScrollState();
}

class _FutureInfiniteScrollState extends State<FutureInfiniteScroll> {
  List data = [];
  int page = 1;
  bool isLoading = true;
  bool hasMoreData = true;
  var lastId = "";
  var total_records = "";

  makeApiRequest() async {
    print("FETCHING DATA");
    var response = await http.post(
      Uri.parse(global.api_base_url + "/get_products_load_more"),
      headers: {"Accept": "application/json"},
      body: {
        "secrete": "dacb465d593bd139a6c28bb7289fa798",
        "sub_sub_category_id": "1",
        "last_id": lastId,
      },
    );

    var resp = json.decode(response.body);

    if (response.statusCode == 200) {
      final dataItems = jsonDecode(response.body);
      // print("Last Id :" + lastId);
      setState(() {
        data.addAll(dataItems['products']);
        lastId = resp['last_id'];
        total_records = resp['total_records'];
        // print("Last Id2222 :" + lastId);
        // print("TOtal Records :" + total_records);
        // print(data.length);
        isLoading = false;
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
    makeApiRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome",
        ),
      ),
      //
      //

      body: Column(
        children: [
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                /* if ((scrollInfo.metrics.maxScrollExtent -
                            scrollInfo.metrics.pixels)
                        .round() ==
                    0) {
                  print("no more data");
                }*/
                print("Total Records" + total_records);
                print(data.length);

                if (!isLoading &&
                    (scrollInfo.metrics.maxScrollExtent -
                                scrollInfo.metrics.pixels)
                            .round() <=
                        200) {
                  page++;
                  makeApiRequest();
                  setState(() {
                    isLoading = true;
                  });
                }
                if (total_records.toString() == data.length.toString()) {
                  setState(() {
                    isLoading = false;
                  });
                }
                return true;
              },
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.59, crossAxisCount: 2),
                scrollDirection: Axis.vertical,
                itemCount: data == null ? 0 : data.length,
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
                              data[index]['image_path'],
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
                                data[index]['product_name'],
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
                              ' \u{20B9}' + " " + data[index]['sell_price'],
                              style: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                            ),
                            Text(
                              ' \u{20B9}' + " " + data[index]['price'],
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
                                  data[index]['discount_percentage']
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
                              data[index]['offer_price'],
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
                  );
                },
              ),
            ),
          ),
          //

          Container(
            height: isLoading ? 50.0 : 0.0,
            child: CircularProgressIndicator(),
          ),
          /*total_records.toString() == data.length.toString()
              ? Container(
                  child: Text("No More Data"),
                )
              : Container(),*/
          total_records.toString() == data.length.toString()
              ? Container(
                  height: hasMoreData ? 50.0 : 0.0,
                  child: Text("You have watched all the posts"),
                )
              : Text("false"),
        ],
      ),
    );
  }

  Widget card(String name, String imageUrl) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 25.0,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 25.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          5.0,
        ),
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
      ),
      child: Column(
        children: [
          //
          Text(
            imageUrl,
          ),
          //
          SizedBox(
            height: 12.0,
          ),
          //
          Text(
            name,
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    );
  }
}
