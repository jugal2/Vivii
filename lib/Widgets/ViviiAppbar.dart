import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:vivii/Screens/CategoiresModule/CategoriesPage.dart';
import 'package:vivii/globals.dart' as global;

AppBar ViViiAppbar(BuildContext context) {
  return AppBar(
    iconTheme: IconThemeData(
      color: Colors.grey[600],
    ),
    elevation: 1,
    //backgroundColor: Color.fromRGBO(8, 64, 106, 1),
    backgroundColor: Colors.white,
    //backgroundColor: Color.fromARGB(1, 8, 64, 106),
    centerTitle: true,
    leading: Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CategoriesPage()));
        },
        child: Image.asset(
          'assets/menu.png',
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
  );
}
